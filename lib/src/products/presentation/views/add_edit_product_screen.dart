import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_shared_preferences/models/pos_categories_data/pos_category.dart';
import 'package:pos_shared_preferences/models/product_data/product.dart';
import 'package:pos_shared_preferences/models/product_data/product_name.dart';
import 'package:pos_shared_preferences/models/product_unit/data/product_unit.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_enum.dart';
import 'package:shared_widgets/config/app_styles.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_drop_down_field.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:shared_widgets/utils/validator_helper.dart';
import 'package:yousentech_pos_basic_data_management/src/account_tax/domain/account_tax_service.dart';
import 'package:yousentech_pos_basic_data_management/src/products/presentation/widget/tital.dart';
import 'package:yousentech_pos_loading_synchronizing_data/config/app_enums.dart';
import 'package:yousentech_pos_loading_synchronizing_data/utils/fetch_date.dart';
import '../../domain/product_service.dart';
import '../../domain/product_viewmodel.dart';

// ignore: must_be_immutable
class AddProductScreen extends StatefulWidget {
  Product? objectToEdit;

  AddProductScreen({super.key, this.objectToEdit});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ProductController productController =
      Get.put(ProductController(), tag: 'productControllerMain');
  // TODO :CHEACK IF THE CODE IS NESSICERE
  // final DashboardController dashboardController =
  //     Get.put(DashboardController.getInstance());
  final TextEditingController nameController = TextEditingController(),
      barcodeController = TextEditingController(),
      unitPriceController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Product? product;
  String? errorMessage;
  int countErrors = 0;
  int pagesNumber = 0;
  // List<ProductUnit> productUnitList = [];
  back() async {
    productController.object = null;
    productController.updateHideMenu(false);
    // productController.update();
    // await loadingDataController.getitems();
  }

  @override
  void initState() {
    super.initState();

    productController.categoriesData();
    product = widget.objectToEdit != null
        ? Product.fromJson(widget.objectToEdit!.toJson())
        : null;
    if (product?.id != null) {
      // nameController.text = product!.productName!;
      nameController.text = (SharedPr.lang == 'ar'
          ? product!.productName!.ar001
          : product!.productName!.enUS)!;
      barcodeController.text = product!.barcode ?? '';
      unitPriceController.text = product!.unitPrice!.toString();
    }
    // print(productController.unitsList);
    product ??= Product();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
        tag: 'productControllerMain',
        builder: (controller) {
          return IgnorePointer(
            ignoring: productController.isLoading.value,
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitalWidget(
                          title: (product?.id == null)
                              ? 'add_new_product'
                              : 'edit_product'),
                      Container(
                        margin:
                            EdgeInsets.only(top: 10.r, left: 20.r, right: 20.r),
                        padding: EdgeInsets.all(20.r),
                        width: 0.6.sw,
                        height: 0.52.sh,
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(5.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.semitransparentblack,
                              blurRadius: 35,
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            ContainerTextField(
                                              controller: nameController,
                                              height: 30.h,
                                              labelText: '',
                                              hintText: 'product_name'.tr,
                                              fontSize: 10.r,
                                              fillColor: AppColor.white,
                                              borderColor: AppColor.silverGray,
                                              hintcolor: AppColor.black
                                                  .withOpacity(0.5),
                                              isAddOrEdit: true,
                                              borderRadius: 5.r,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.r,
                                                    vertical: 5.r),
                                                child: SvgPicture.asset(
                                                  "assets/image/name_product.svg",
                                                  package:
                                                      'yousentech_pos_basic_data_management',
                                                  width: 19.r,
                                                  height: 19.r,
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  errorMessage =
                                                      'required_message'
                                                          .trParams({
                                                    'field_name':
                                                        'product_name'.tr
                                                  });
                                                  countErrors++;
                                                  return "";
                                                }
                                                return null;
                                              },
                                              onChanged: (text) async {},
                                            ),
                                            SizedBox(
                                              height: 10.r,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ContainerTextField(
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              '[0-9\$]+')),
                                                    ],
                                                    controller:
                                                        unitPriceController,
                                                    height: 30.h,
                                                    labelText: '',
                                                    hintText:
                                                        'product_unit_price'.tr,
                                                    fontSize: 10.r,
                                                    fillColor: AppColor.white,
                                                    borderColor:
                                                        AppColor.silverGray,
                                                    hintcolor: AppColor.black
                                                        .withOpacity(0.5),
                                                    isAddOrEdit: true,
                                                    borderRadius: 5.r,
                                                    prefixIcon: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.r,
                                                              vertical: 5.r),
                                                      child: SvgPicture.asset(
                                                        "assets/image/price_2.svg",
                                                        package:
                                                            'yousentech_pos_basic_data_management',
                                                        width: 19.r,
                                                        height: 19.r,
                                                        color: AppColor.amber,
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      var message = ValidatorHelper
                                                          .priceValidation(
                                                              value: value!,
                                                              field:
                                                                  'product_unit_price'
                                                                      .tr);
                                                      if (message == "") {
                                                        return null;
                                                      }
                                                      errorMessage = message;
                                                      return "";
                                                      // if (value == null || value.isEmpty) {
                                                      //   errorMessage = 'required_message'.trParams(
                                                      //       {'field_name': 'product_unit_price'.tr});
                                                      //   countErrors++;
                                                      //   return "";
                                                      // }
                                                      // return null;
                                                    },
                                                    onChanged: (text) async {},
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.r,
                                                ),
                                                Expanded(
                                                  child: ContainerTextField(
                                                    controller:
                                                        barcodeController,
                                                    height: 30.h,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              '[0-9\$]+')),
                                                    ],
                                                    labelText: '',
                                                    hintText:
                                                        'product_barcode'.tr,
                                                    fontSize: 10.r,
                                                    fillColor: AppColor.white,
                                                    borderColor:
                                                        AppColor.silverGray,
                                                    hintcolor: AppColor.black
                                                        .withOpacity(0.5),
                                                    isAddOrEdit: true,
                                                    borderRadius: 5.r,
                                                    prefixIcon: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.r,
                                                              vertical: 5.r),
                                                      child: SvgPicture.asset(
                                                        "assets/image/search_barcode.svg",
                                                        package:
                                                            'yousentech_pos_basic_data_management',
                                                        width: 19.r,
                                                        height: 19.r,
                                                        color: AppColor.amber,
                                                      ),
                                                    ),
                                                    // validator: (value) {
                                                    //   if (value == null ||
                                                    //       value.isEmpty) {
                                                    //     errorMessage =
                                                    //         'required_message'
                                                    //             .trParams({
                                                    //       'field_name':
                                                    //           'product_barcode'.tr
                                                    //     });
                                                    //     countErrors++;
                                                    //     return "";
                                                    //   }
                                                    //   return null;
                                                    // },
                                                    onChanged: (text) async {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.r,
                                            ),

                                            ContainerDropDownField(
                                              // width: Get.width * 0.45,
                                              // height: MediaQuery.sizeOf(context)
                                              //         .height *
                                              //     0.05,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.r,
                                                    vertical: 5.r),
                                                child: SvgPicture.asset(
                                                  "assets/image/categories_menu_icon.svg",
                                                  package:
                                                      'yousentech_pos_basic_data_management',
                                                  width: 19.r,
                                                  height: 19.r,
                                                  color: AppColor.amber
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                              fontSize: 10.r,
                                              fillColor: AppColor.white,
                                              borderColor: AppColor.silverGray,
                                              hintcolor: AppColor.black
                                                  .withOpacity(0.5),
                                              borderRadius: 5.r,
                                              hintText: 'product_category',
                                              labelText: 'product_category'.tr,
                                              value: product!.soPosCategId,
                                              color: AppColor.black,
                                              // isPIN: true,

                                              iconcolor: AppColor.black,

                                              onChanged: (val) {
                                                product!.soPosCategId = val;
                                                PosCategory posCategory =
                                                    controller
                                                        .categoriesList
                                                        .firstWhere(
                                                            (element) =>
                                                                element.id ==
                                                                val,
                                                            orElse: () =>
                                                                PosCategory());
                                                product!.soPosCategName =
                                                    (SharedPr.lang == 'ar'
                                                        ? posCategory
                                                            .name!.ar001
                                                        : posCategory
                                                            .name!.enUS);
                                                // product!.soPosCategName =
                                                //     (SharedPr.lang == 'ar'
                                                //         ? posCategory
                                                //             .name!.ar001
                                                //         : posCategory
                                                //             .name!.enUS);
                                              },
                                              validator: (value) {
                                                if (value == null) {
                                                  errorMessage =
                                                      'required_message'
                                                          .trParams({
                                                    'field_name':
                                                        'product_category'.tr
                                                  });
                                                  countErrors++;
                                                  return "";
                                                }
                                                return null;
                                              },
                                              items: controller.categoriesList
                                                  .map((e) => DropdownMenuItem(
                                                        // value: e.id,
                                                        value: e.id,
                                                        child: Center(
                                                            child: Text((SharedPr
                                                                        .lang ==
                                                                    'ar'
                                                                ? e.name!.ar001
                                                                : e.name!
                                                                    .enUS)!)),
                                                      ))
                                                  .toList(),
                                            ),

                                            SizedBox(
                                              height: 10.r,
                                            ), // Text('product_unit'.tr,
                                            //     style: AppStyle.textStyle(
                                            //         color: AppColor.black,
                                            //         fontSize: Get.width * 0.01,
                                            //         fontWeight: FontWeight.bold)),
                                            // SizedBox(height: Get.height * 0.01),
                                            ContainerDropDownField(
                                              width: Get.width * 0.45,
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.05,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.r,
                                                    vertical: 5.r),
                                                child: SvgPicture.asset(
                                                  "assets/image/productunit_menu_icon.svg",
                                                  package:
                                                      'yousentech_pos_basic_data_management',
                                                  width: 19.r,
                                                  height: 19.r,
                                                  color: AppColor.amber
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                              hintText: 'product_unit'.tr,
                                              labelText: 'product_unit'.tr,
                                              fontSize: 10.r,
                                              color: AppColor.black,
                                              fillColor: AppColor.white,
                                              borderColor: AppColor.silverGray,
                                              hintcolor: AppColor.black
                                                  .withOpacity(0.5),
                                              borderRadius: 5.r,
                                              // validator: (value) {
                                              //   if (value == null) {
                                              //     errorMessage = 'required_message'.trParams(
                                              //         {'field_name': 'product_unit'.tr});
                                              //     countErrors++;
                                              //     return "";
                                              //   }
                                              //   return null;
                                              // },
                                              value: product!.uomId,

                                              // isPIN: true,

                                              iconcolor: AppColor.black,

                                              onChanged: (val) {
                                                product!.uomId = val;
                                                ProductUnit productUnit =
                                                    controller
                                                        .unitsList
                                                        .firstWhere(
                                                            (element) =>
                                                                element.id ==
                                                                val,
                                                            orElse: () =>
                                                                ProductUnit());
                                                product!.uomName = (SharedPr
                                                            .lang ==
                                                        'ar'
                                                    ? productUnit.name!.ar001
                                                    : productUnit.name!.enUS);
                                                // product!.uomName = (SharedPr.lang == 'ar' ? productUnit.name! : productUnit.name!);
                                              },
                                              items: controller.unitsList
                                                  .map((e) => DropdownMenuItem(
                                                        // value: e.id,
                                                        value: e.id,
                                                        child: Center(
                                                            child: Text((SharedPr
                                                                        .lang ==
                                                                    'ar'
                                                                ? e.name!.ar001
                                                                : e.name!
                                                                    .enUS)!)),
                                                        // child: Center(child: Text((SharedPr.lang == 'ar' ? e.name! : e.name!))),
                                                      ))
                                                  .toList(),
                                            ),
                                            const Spacer(),
                                            Container(
                                              decoration: ShapeDecoration(
                                                color: AppColor.blueGray,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.r)),
                                              ),
                                              child: CheckboxListTile(
                                                  fillColor: (product
                                                              ?.quickMenuAvailability ==
                                                          null)
                                                      ? WidgetStateProperty.all(
                                                          AppColor.white)
                                                      : product!
                                                              .quickMenuAvailability!
                                                          ? WidgetStateProperty
                                                              .all(AppColor
                                                                  .cyanTeal)
                                                          : WidgetStateProperty
                                                              .all(AppColor
                                                                  .white),
                                                  value: product
                                                          ?.quickMenuAvailability ??
                                                      false,
                                                  title: Text(
                                                    'quick_menu_availability'
                                                        .tr,
                                                    style: TextStyle(
                                                      color:
                                                          AppColor.lavenderGray,
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  onChanged: (val) {
                                                    product?.quickMenuAvailability =
                                                        val!;
                                                    setState(() {});
                                                  }),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 10.r,
                                    ),
                                    Expanded(
                                        child: Container(
                                      height: 300.h,
                                      padding: EdgeInsets.all(5.r),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 300.h,
                                            decoration: BoxDecoration(
                                                color: product == null ||
                                                        product!.image ==
                                                            null ||
                                                        product!.image == ''
                                                    ? AppColor.cyanTeal
                                                        .withOpacity(0.2)
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                border: Border.all(
                                                    color: AppColor.silverGray
                                                        .withOpacity(0.3))),
                                            child: product == null ||
                                                    product!.image == null ||
                                                    product!.image == ''
                                                ? null
                                                : isSvg(product!.image!
                                                        .toString())
                                                    ? SvgPicture.memory(
                                                        base64.decode(product!
                                                            .image!
                                                            .toString()),
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Image.memory(
                                                        base64Decode(product!
                                                            .image!
                                                            .toString()),
                                                        fit: BoxFit.fill,
                                                        filterQuality:
                                                            FilterQuality.high),
                                          ),
                                          Positioned(
                                              left: 5.r,
                                              top: 5.r,
                                              child: InkWell(
                                                onTap: () async {
                                                  final ImagePicker picker =
                                                      ImagePicker();
                                                  final XFile? image =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .gallery);
                                                  if (image != null) {
                                                    String imagePath =
                                                        image.path;
                                                    File imageFile =
                                                        File(imagePath);
                                                    Uint8List bytes =
                                                        await imageFile
                                                            .readAsBytes();
                                                    String base64String =
                                                        base64.encode(bytes);
                                                    product!.image =
                                                        base64String;
                                                    setState(() {});
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: AppColor.cyanTeal,
                                                      shape: BoxShape.circle),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: SvgPicture.asset(
                                                        "assets/image/edit.svg",
                                                        package:
                                                            'yousentech_pos_basic_data_management',
                                                        width: 20.r,
                                                        height: 20.r,
                                                        color: AppColor.white),
                                                  ),
                                                ),
                                              ))
                                          // Container(
                                          //   padding: EdgeInsets.all(5.r),
                                          //   decoration: BoxDecoration(
                                          //       color: AppColor.cyanTeal,
                                          //       shape: BoxShape.circle),
                                          //   child: SvgPicture.asset(
                                          //     'assets/image/edit.svg',
                                          //     color: AppColor.white,
                                          //     height: 20.r,
                                          //     width: 20.r,
                                          //   ),
                                          // ),
                                          // Expanded(
                                          //   child: Column(
                                          //     crossAxisAlignment:
                                          //         CrossAxisAlignment.center,
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment.center,
                                          //     children: [
                                          //       ClipRRect(
                                          //         borderRadius:
                                          //             BorderRadius.circular(25),
                                          //         child: product!.image != null
                                          //             ? Image.memory(
                                          //                 base64Decode(
                                          //                     product!.image!),
                                          //                 fit: BoxFit.fill,
                                          //                 width: Get.width * 0.05,
                                          //                 height:
                                          //                     Get.width * 0.05,
                                          //               )
                                          //             : Icon(
                                          //                 Icons.photo,
                                          //                 color:
                                          //                     AppColor.cyanTeal,
                                          //                 size: 100.r,
                                          //               ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30.r,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ButtonElevated(
                                        text: (product?.id != null
                                                ? 'edit_product'
                                                : 'add_new_product')
                                            .tr,
                                        borderRadius: 5.r,
                                        backgroundColor: AppColor.cyanTeal,
                                        showBoxShadow: false,
                                        textStyle: AppStyle.textStyle(
                                            color: Colors.white,
                                            fontSize: 3.sp,
                                            fontWeight: FontWeight.w700),
                                        onPressed: _onPressed),
                                  ),
                                  SizedBox(width: Get.width * 0.01),
                                  Expanded(
                                    child: ButtonElevated(
                                        text: 'back'.tr,
                                        borderRadius: 5.r,
                                        borderColor: AppColor.silverGray,
                                        textStyle: AppStyle.textStyle(
                                            color: AppColor.slateGray,
                                            fontSize: 3.sp,
                                            fontWeight: FontWeight.normal),
                                        onPressed: () async {
                                          productController.searchResults
                                              .clear();
                                          productController.update();
                                          await productController
                                              .resetPagingList(selectedpag: 0);
                                          back();

                                          // Get.back();
                                        }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                  // SingleChildScrollView(
                  //   child: Center(
                  //     child: Container(
                  //       width: Get.width * 0.5,
                  //       padding: const EdgeInsets.all(8),
                  //       child: Column(
                  //         children: [
                  //           Row(
                  //             children: [
                  //               TextButton(
                  //                   onPressed: () {
                  //                     back();
                  //                   },
                  //                   child: Text("${"products".tr} ")),
                  //               Text(
                  //                   "/ ${(product?.id == null) ? 'add_new_product'.tr : 'edit_product'.tr} "),
                  //             ],
                  //           ),
                  //           Card(
                  //             child: Form(
                  //               key: _formKey,
                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(30.0),
                  //                 child: Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     // Center(
                  //                     //   child: sideUserMenu[
                  //                     //               SideUserMenu.dataManagement]![0]
                  //                     //           .last
                  //                     //           .first is IconData
                  //                     //       ? Icon(
                  //                     //           sideUserMenu[
                  //                     //                   SideUserMenu.dataManagement]![0]
                  //                     //               .last
                  //                     //               .first,
                  //                     //           size:
                  //                     //               MediaQuery.of(context).size.height *
                  //                     //                   0.1,
                  //                     //         )
                  //                     //       : Image.asset(
                  //                     //           "assets/image/${sideUserMenu[SideUserMenu.dataManagement]![0].last.first}.png",
                  //                     //           width:
                  //                     //               MediaQuery.of(context).size.height *
                  //                     //                   0.1,
                  //                     //           color: AppColor.purple,
                  //                     //         ),
                  //                     // ),

                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Column(
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.start,
                  //                           children: [
                  //                             Text(
                  //                                 ((product?.id == null)
                  //                                         ? 'add_new_product'
                  //                                         : 'edit_product')
                  //                                     .tr,
                  //                                 style: AppStyle.textStyle(
                  //                                     color: AppColor.black,
                  //                                     fontSize: Get.width * 0.02,
                  //                                     fontWeight: FontWeight.bold)
                  //                                 //  AppStyle.header1,
                  //                                 ),
                  //                             Text('add_new_product_message'.tr,
                  //                                 style: AppStyle.textStyle(
                  //                                     color: AppColor.grey,
                  //                                     fontSize: Get.width * 0.01,
                  //                                     fontWeight: FontWeight.bold)),
                  //                           ],
                  //                         ),
                  //                         IconButton(
                  //                           onPressed: () async {
                  //                             final ImagePicker picker = ImagePicker();
                  //                             final XFile? image =
                  //                                 await picker.pickImage(
                  //                                     source: ImageSource.gallery);
                  //                             if (image != null) {
                  //                               String imagePath = image.path;
                  //                               File imageFile = File(imagePath);
                  //                               Uint8List bytes =
                  //                                   await imageFile.readAsBytes();
                  //                               String base64String =
                  //                                   base64.encode(bytes);
                  //                               product!.image = base64String;
                  //                               setState(() {});
                  //                             }
                  //                           },
                  //                           icon: Container(
                  //                             width: Get.width * 0.05,
                  //                             height: Get.width * 0.05,
                  //                             decoration: BoxDecoration(
                  //                               borderRadius: const BorderRadius.all(
                  //                                   Radius.circular(25)),
                  //                               color: AppColor.purple.withOpacity(0.1),
                  //                             ),
                  //                             child: ClipRRect(
                  //                               borderRadius: BorderRadius.circular(25),
                  //                               child: product!.image != null
                  //                                   ? Image.memory(
                  //                                       base64Decode(product!.image!),
                  //                                       fit: BoxFit.fill,
                  //                                       width: Get.width * 0.05,
                  //                                       height: Get.width * 0.05,
                  //                                     )
                  //                                   : Icon(
                  //                                       Icons.photo,
                  //                                       color: AppColor.purple,
                  //                                       size: Get.width * 0.05,
                  //                                     ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     SizedBox(height: Get.height * 0.01),
                  //                     // Text('product_name'.tr,
                  //                     //     style: AppStyle.textStyle(
                  //                     //         color: AppColor.black,
                  //                     //         fontSize: Get.width * 0.01,
                  //                     //         fontWeight: FontWeight.bold)
                  //                     //     //  AppStyle.header1,
                  //                     //     ),
                  //                     // SizedBox(height: Get.height * 0.01),
                  //                     ContainerTextField(
                  //                       width: Get.width * 0.45,
                  //                       prefixIcon: Icon(
                  //                         Icons.person,
                  //                         size: 4.sp,
                  //                         color: AppColor.black,
                  //                       ),
                  //                       height:
                  //                           MediaQuery.sizeOf(context).height * 0.05,
                  //                       controller: nameController,
                  //                       isPIN: true,
                  //                       isAddOrEdit: true,
                  //                       hintText: 'product_name'.tr,
                  //                       labelText: 'product_name'.tr,
                  //                       hintcolor: AppColor.black.withOpacity(0.5),
                  //                       iconcolor: AppColor.black,
                  //                       color: AppColor.black,
                  //                       fontSize: Get.width * 0.01,
                  //                       validator: (value) {
                  //                         if (value == null || value.isEmpty) {
                  //                           errorMessage = 'required_message'.trParams(
                  //                               {'field_name': 'product_name'.tr});
                  //                           countErrors++;
                  //                           return "";
                  //                         }
                  //                         return null;
                  //                       },
                  //                     ),
                  //                     SizedBox(height: Get.height * 0.02),
                  //                     // Text('product_unit_price'.tr,
                  //                     //     style: AppStyle.textStyle(
                  //                     //         color: AppColor.black,
                  //                     //         fontSize: Get.width * 0.01,
                  //                     //         fontWeight: FontWeight.bold)
                  //                     //     //  AppStyle.header1,
                  //                     //     ),
                  //                     // SizedBox(height: Get.height * 0.01),
                  //                     ContainerTextField(
                  //                       width: Get.width * 0.45,
                  //                       prefixIcon: Icon(
                  //                         Icons.price_change,
                  //                         size: 4.sp,
                  //                         color: AppColor.black,
                  //                       ),
                  //                       height:
                  //                           MediaQuery.sizeOf(context).height * 0.05,
                  //                       inputFormatters: [
                  //                         FilteringTextInputFormatter.allow(
                  //                             RegExp('[0-9\$]+')),
                  //                       ],
                  //                       controller: unitPriceController,
                  //                       isPIN: true,
                  //                       isAddOrEdit: true,
                  //                       hintText: 'product_unit_price'.tr,
                  //                       labelText: 'product_unit_price'.tr,
                  //                       hintcolor: AppColor.black.withOpacity(0.5),
                  //                       iconcolor: AppColor.black,
                  //                       color: AppColor.black,
                  //                       fontSize: Get.width * 0.01,
                  //                       validator: (value) {
                  //                         var message = ValidatorHelper.priceValidation(
                  //                             value: value!,
                  //                             field: 'product_unit_price'.tr);
                  //                         if (message == "") {
                  //                           return null;
                  //                         }
                  //                         errorMessage = message;
                  //                         return "";
                  //                         // if (value == null || value.isEmpty) {
                  //                         //   errorMessage = 'required_message'.trParams(
                  //                         //       {'field_name': 'product_unit_price'.tr});
                  //                         //   countErrors++;
                  //                         //   return "";
                  //                         // }
                  //                         // return null;
                  //                       },
                  //                     ),
                  //                     SizedBox(height: Get.height * 0.02),
                  //                     // Text('product_barcode'.tr,
                  //                     //     style: AppStyle.textStyle(
                  //                     //         color: AppColor.black,
                  //                     //         fontSize: Get.width * 0.01,
                  //                     //         fontWeight: FontWeight.bold)
                  //                     //     //  AppStyle.header1,
                  //                     //     ),
                  //                     // SizedBox(height: Get.height * 0.01),
                  //                     ContainerTextField(
                  //                       width: Get.width * 0.45,
                  //                       prefixIcon: Icon(
                  //                         Icons.barcode_reader,
                  //                         size: 4.sp,
                  //                         color: AppColor.black,
                  //                       ),

                  //                       height:
                  //                           MediaQuery.sizeOf(context).height * 0.05,
                  //                       inputFormatters: [
                  //                         FilteringTextInputFormatter.allow(
                  //                             RegExp('[0-9\$]+')),
                  //                       ],
                  //                       controller: barcodeController,
                  //                       isPIN: true,
                  //                       isAddOrEdit: true,
                  //                       hintText: 'product_barcode'.tr,
                  //                       labelText: 'product_barcode'.tr,
                  //                       hintcolor: AppColor.black.withOpacity(0.5),
                  //                       iconcolor: AppColor.black,
                  //                       color: AppColor.black,
                  //                       fontSize: Get.width * 0.01,
                  //                       // validator: (value) {
                  //                       //   if (value == null || value.isEmpty) {
                  //                       //     errorMessage = 'required_message'.trParams(
                  //                       //         {'field_name': 'product_barcode'.tr});
                  //                       //     countErrors++;
                  //                       //     return "";
                  //                       //   }
                  //                       //   return null;
                  //                       // },
                  //                     ),
                  //                     SizedBox(height: Get.height * 0.02),
                  //                     // Text('product_category'.tr,
                  //                     //     style: AppStyle.textStyle(
                  //                     //         color: AppColor.black,
                  //                     //         fontSize: Get.width * 0.01,
                  //                     //         fontWeight: FontWeight.bold)),
                  //                     // SizedBox(height: Get.height * 0.01),
                  //                     ContainerDropDownField(
                  //                       width: Get.width * 0.45,
                  //                       height:
                  //                           MediaQuery.sizeOf(context).height * 0.05,
                  //                       prefixIcon: Icons.category,
                  //                       hintText: 'product_category'.tr,
                  //                       labelText: 'product_category'.tr,
                  //                       value: product!.soPosCategId,
                  //                       color: AppColor.black,
                  //                       // isPIN: true,
                  //                       hintcolor: AppColor.black.withOpacity(0.5),
                  //                       iconcolor: AppColor.black,
                  //                       fontSize: Get.width * 0.01,
                  //                       onChanged: (val) {
                  //                         product!.soPosCategId = val;
                  //                         PosCategory posCategory =
                  //                             controller.categoriesList.firstWhere(
                  //                                 (element) => element.id == val,
                  //                                 orElse: () => PosCategory());
                  //                         // product!.soPosCategName = posCategory.name;
                  //                         product!.soPosCategName =
                  //                             (SharedPr.lang == 'ar'
                  //                                 ? posCategory.name!.ar001
                  //                                 : posCategory.name!.enUS);
                  //                         product!.soPosCategName =
                  //                             (SharedPr.lang == 'ar'
                  //                                 ? posCategory.name!.ar001
                  //                                 : posCategory.name!.enUS);
                  //                       },
                  //                       validator: (value) {
                  //                         if (value == null) {
                  //                           errorMessage = 'required_message'.trParams(
                  //                               {'field_name': 'product_category'.tr});
                  //                           countErrors++;
                  //                           return "";
                  //                         }
                  //                         return null;
                  //                       },
                  //                       items: controller.categoriesList
                  //                           .map((e) => DropdownMenuItem(
                  //                                 // value: e.id,
                  //                                 value: e.id,
                  //                                 child: Center(
                  //                                     child: Text((SharedPr.lang == 'ar'
                  //                                         ? e.name!.ar001
                  //                                         : e.name!.enUS)!)),
                  //                               ))
                  //                           .toList(),
                  //                     ),
                  //                     SizedBox(height: Get.height * 0.02),
                  //                     // Text('product_unit'.tr,
                  //                     //     style: AppStyle.textStyle(
                  //                     //         color: AppColor.black,
                  //                     //         fontSize: Get.width * 0.01,
                  //                     //         fontWeight: FontWeight.bold)),
                  //                     // SizedBox(height: Get.height * 0.01),
                  //                     ContainerDropDownField(
                  //                       width: Get.width * 0.45,
                  //                       height:
                  //                           MediaQuery.sizeOf(context).height * 0.05,
                  //                       prefixIcon: Icons.category,
                  //                       hintText: 'product_unit'.tr,
                  //                       labelText: 'product_unit'.tr,
                  //                       // validator: (value) {
                  //                       //   if (value == null) {
                  //                       //     errorMessage = 'required_message'.trParams(
                  //                       //         {'field_name': 'product_unit'.tr});
                  //                       //     countErrors++;
                  //                       //     return "";
                  //                       //   }
                  //                       //   return null;
                  //                       // },
                  //                       value: product!.uomId,
                  //                       color: AppColor.black,
                  //                       // isPIN: true,

                  //                       hintcolor: AppColor.black.withOpacity(0.5),
                  //                       iconcolor: AppColor.black,
                  //                       fontSize: Get.width * 0.01,
                  //                       onChanged: (val) {
                  //                         product!.uomId = val;
                  //                         ProductUnit productUnit = controller.unitsList
                  //                             .firstWhere(
                  //                                 (element) => element.id == val,
                  //                                 orElse: () => ProductUnit());
                  //                         product!.uomName = (SharedPr.lang == 'ar'
                  //                             ? productUnit.name!.ar001
                  //                             : productUnit.name!.enUS);
                  //                         // product!.uomName = (SharedPr.lang == 'ar' ? productUnit.name! : productUnit.name!);
                  //                       },
                  //                       items: controller.unitsList
                  //                           .map((e) => DropdownMenuItem(
                  //                                 // value: e.id,
                  //                                 value: e.id,
                  //                                 child: Center(
                  //                                     child: Text((SharedPr.lang == 'ar'
                  //                                         ? e.name!.ar001
                  //                                         : e.name!.enUS)!)),
                  //                                 // child: Center(child: Text((SharedPr.lang == 'ar' ? e.name! : e.name!))),
                  //                               ))
                  //                           .toList(),
                  //                     ),
                  //                     SizedBox(height: Get.height * 0.02),

                  //                     CheckboxListTile(
                  //                         value:
                  //                             product?.quickMenuAvailability ?? false,
                  //                         title: Text('quick_menu_availability'.tr),
                  //                         onChanged: (val) {
                  //                           product?.quickMenuAvailability = val!;
                  //                           setState(() {});
                  //                         }),
                  //                     SizedBox(height: Get.height * 0.02),
                  //                     Row(
                  //                       mainAxisAlignment: MainAxisAlignment.end,
                  //                       children: [
                  //                         ButtonElevated(
                  //                             width: Get.width * 0.15,
                  //                             text: 'cancel'.tr,
                  //                             backgroundColor: AppColor.shadepurple,
                  //                             onPressed: () {
                  //                               // productController.isLoading.value = false;
                  //                               back();
                  //                             }),
                  //                         SizedBox(width: Get.width * 0.01),
                  //                         // Obx(() {
                  //                         //   if (productController.isLoading.value) {
                  //                         //     return CircularProgressIndicator(
                  //                         //       color: AppColor.purple,
                  //                         //       // backgroundColor: AppColor.black,
                  //                         //     );
                  //                         //   } else {
                  //                         //     return

                  //                             ButtonElevated(
                  //                                 width: Get.width * 0.15,
                  //                                 text: (product?.id != null
                  //                                         ? 'edit_product'
                  //                                         : 'add_new_product')
                  //                                     .tr,
                  //                                 backgroundColor: AppColor.shadepurple,
                  //                                 onPressed: _onPressed)

                  //                         //         ;
                  //                         //   }
                  //                         // }),
                  //                       ],
                  //                     )
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  productController.isLoading.value
                      ? const LoadingWidget()
                      : Container(),
                ],
              ),
            ),
          );
        });
  }

  _onPressed() async {
    productController.isLoading.value = true;
    productController.searchResults.clear();
    productController.update();
    ProductService.productDataServiceInstance = null;
    ProductService.getInstance();
    countErrors = 0;
    if (_formKey.currentState!.validate()) {
      ProductName processedProductName;
      if (product!.id == null) {
        processedProductName =
            ProductName(enUS: nameController.text, ar001: nameController.text);
      } else {
        processedProductName = ProductName(
            enUS: SharedPr.lang == 'en'
                ? nameController.text
                : product!.productName!.enUS,
            ar001: SharedPr.lang == 'ar'
                ? nameController.text
                : product!.productName!.ar001);
      }
      product!
        // ..productName = nameController.text
        ..productName = processedProductName
        // ..productName = jsonEncode({"en_US": nameController.text, "ar_001": nameController.text})
        ..barcode = barcodeController.text == "" ? null : barcodeController.text
        ..unitPrice = double.parse(unitPriceController.text)
        ..uomId = 1;

      // if (product!.uomId == null && productController.unitsList.isNotEmpty) {
      //   product!.uomName = productController.unitsList[0].name;
      //   product!.uomId = productController.unitsList[0].id;
      // }

      ResponseResult responseResult;
      if (product?.id == null) {
        final AccountTaxService accountTaxService =
            AccountTaxService.getInstance();
        var result = await accountTaxService.search("15%");
        if (result is List) {
          if (result.isNotEmpty) {
            product!.taxesId = [result[0].id!];
          } else {
            var result = await accountTaxService.search("");
            product!.taxesId = [result[0].id!];
          }
        }
        responseResult =
            await productController.createProduct(product: product!);
      } else {
        responseResult =
            await productController.updateProduct(product: product!);
      }
      await loadingDataController.getitems();
      pagesNumber = (loadingDataController
                  .itemdata[Loaddata.products.name.toString()]['local'] ~/
              productController.limit) +
          (loadingDataController.itemdata[Loaddata.products.name.toString()]
                          ['local'] %
                      productController.limit !=
                  0
              ? 1
              : 0);
      if (responseResult.status) {
        if (widget.objectToEdit == null && pagesNumber == 1) {
          // customerController.customerList.add(func.data);
          productController.pagingList.add(responseResult.data!);
        }
        // var productIndex =productController.pagingList.indexOf(widget.objectToEdit);
        var productIndex = productController.pagingList
            .indexWhere((item) => item.id == widget.objectToEdit?.id);
        if (productIndex != -1) {
          productController.pagingList[productIndex] = product!;
        }

        productController.update();
        // await loadingDataController.getitems();
        product = null;
        productController.isLoading.value = false;
        productController.update();

        appSnackBar(
          messageType: MessageTypes.success,
          message: responseResult.message,
        );
        back();
        await productController.resetPagingList(selectedpag: 0);
      } else {
        productController.isLoading.value = false;
        productController.update();

        appSnackBar(
          message: responseResult.message,
        );
      }
      await productController.productsData();
      productController.isLoading.value = false;
      productController.update();
    } else {
      productController.isLoading.value = false;
      productController.update();

      appSnackBar(
        message: countErrors > 1 ? 'enter_required_info'.tr : errorMessage!,
      );
    }
  }
}
