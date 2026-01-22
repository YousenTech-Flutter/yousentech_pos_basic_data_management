import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_shared_preferences/models/pos_categories_data/pos_category.dart';
import 'package:pos_shared_preferences/models/pos_categories_data/pos_category_note.dart';
import 'package:pos_shared_preferences/models/product_data/product.dart';
import 'package:pos_shared_preferences/models/product_data/product_name.dart';
import 'package:pos_shared_preferences/models/product_unit/data/product_unit.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_enums.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/app_drop_down_field.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:shared_widgets/utils/validator_helper.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/config/app_enums.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/config/app_list.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/account_tax/domain/account_tax_service.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/presentation/views/create_edit_customer.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/domain/product_service.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/domain/product_viewmodel.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/product_screen.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_viewmodel.dart';

class CreateEditeProductMobile extends StatefulWidget {
  final Product? objectToEdit;
  const CreateEditeProductMobile({super.key, this.objectToEdit});

  @override
  State<CreateEditeProductMobile> createState() =>
      _CreateEditeProductMobileState();
}

class _CreateEditeProductMobileState extends State<CreateEditeProductMobile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController(),
      barcodeController = TextEditingController(),
      defaultCodeController = TextEditingController(),
      unitPriceController = TextEditingController();
  final ProductController productController = Get.put(
    ProductController(),
    tag: 'productControllerMain',
  );

  String? errorMessage;
  int countErrors = 0;
  int pagesNumber = 0;
  Product? product;
  List<CategoryNote> categoryNotes = [];
  @override
  void initState() {
    super.initState();
    product = widget.objectToEdit != null
        ? Product.fromJson(widget.objectToEdit!.toJson())
        : null;
    if (product != null) {
      nameController.text = (SharedPr.lang == 'ar'
          ? product!.productName!.ar001
          : product!.productName!.enUS)!;
      barcodeController.text = product!.barcode ?? '';
      defaultCodeController.text = product!.defaultCode ?? '';
      unitPriceController.text = product!.unitPrice!.toString();
      categoryNotes = product!.productNotes ?? [];
    }
    product ??= Product(
      soPosCategId: productController.categoriesList.isNotEmpty
          ? productController.categoriesList[0].id
          : null,
      soPosCategName: productController.categoriesList.isNotEmpty
          ? (SharedPr.lang == 'ar'
              ? productController.categoriesList[0].name!.ar001
              : productController.categoriesList[0].name!.enUS)
          : null,
      uomId: productController.unitsList.isNotEmpty
          ? productController.unitsList[0].id
          : null,
      uomName: productController.unitsList.isNotEmpty
          ? (SharedPr.lang == 'ar'
              ? productController.unitsList[0].name!.ar001
              : productController.unitsList[0].name!.enUS)
          : null,
      taxesId: [productController.taxesList.first.id!],
      detailedType: DetailedType.consu.enUS,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Obx(() {
      return IgnorePointer(
        ignoring: productController.isLoading.value,
        child: Scaffold(
            backgroundColor: Get.find<ThemeController>().isDarkMode.value
                ? AppColor.darkModeBackgroundColor
                : const Color(0xFFF6F6F6),
            appBar: customAppBar(
              context: context,
              isMobile: true,
              onDarkModeChanged: () {},
            ),
            body: Stack(
              children: [
                GetBuilder<ProductController>(
                    tag: 'productControllerMain',
                    builder: (controller) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(context.setMinSize(16.92)),
                          child: Column(
                            spacing: context.setHeight(19),
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Get.find<ThemeController>()
                                          .isDarkMode
                                          .value
                                      ? const Color(0xFF2B2B2B)
                                      : AppColor.white,
                                  borderRadius: BorderRadius.circular(
                                      context.setMinSize(11.17)),
                                ),
                                child: Row(
                                  spacing: context.setWidth(10),
                                  children: [
                                    BackButton(
                                      color: Get.find<ThemeController>()
                                              .isDarkMode
                                              .value
                                          ? Colors.white
                                          : const Color(0xFF0C0C0C),
                                    ),
                                    Text(
                                      product?.id == null
                                          ? "add_new_product".tr
                                          : 'edit_product'.tr,
                                      style: TextStyle(
                                        color: Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? AppColor.white
                                            : AppColor.black,
                                        fontSize: context.setSp(14),
                                        fontFamily: 'SansBold',
                                        fontWeight: FontWeight.w600,
                                        height: 1.56,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: context.setHeight(240.01),
                                decoration: ShapeDecoration(
                                  color: Get.find<ThemeController>()
                                          .isDarkMode
                                          .value
                                      ? const Color(0xFF232323)
                                      : AppColor.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1.06,
                                      color: Get.find<ThemeController>()
                                              .isDarkMode
                                              .value
                                          ? const Color(0x82474747)
                                          : const Color(0xFFF3F4F6),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        context.setMinSize(11.17)),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(context.setMinSize(20)),
                                  child: Column(
                                    spacing: context.setHeight(10),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'product_image'.tr,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Get.find<ThemeController>()
                                                  .isDarkMode
                                                  .value
                                              ? AppColor.white
                                              : AppColor.black,
                                          fontSize: context.setSp(14),
                                          fontFamily: 'SansBold',
                                          fontWeight: FontWeight.w600,
                                          height: 1.56,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final ImagePicker picker =
                                              ImagePicker();
                                          final XFile? image =
                                              await picker.pickImage(
                                            source: ImageSource.gallery,
                                          );
                                          if (image != null) {
                                            String imagePath = image.path;
                                            File imageFile = File(imagePath);
                                            Uint8List bytes =
                                                await imageFile.readAsBytes();
                                            String base64String = base64.encode(
                                              bytes,
                                            );
                                            product!.image = base64String;
                                            setState(() {});
                                          }
                                        },
                                        child: CustomPaint(
                                          painter: DashedBorderPainter(),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Container(
                                              width: double.infinity,
                                              height:
                                                  context.setMinSize(143.80),
                                              alignment: Alignment.center,
                                              child: product == null ||
                                                      product!.image == null ||
                                                      product!.image == ''
                                                  ? Center(
                                                      child: Column(
                                                        spacing: context
                                                            .setHeight(10.62),
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.camera_alt,
                                                            size: context
                                                                .setMinSize(
                                                                    25.64),
                                                            color: Colors.grey,
                                                          ),
                                                          Text(
                                                            "upload".tr,
                                                            style: TextStyle(
                                                              color: const Color(
                                                                  0xFF9CA3AF),
                                                              fontSize: context
                                                                  .setSp(12),
                                                              fontFamily:
                                                                  'Tajawal',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 1.43,
                                                            ),
                                                          ),
                                                          ButtonClick(
                                                            color: AppColor.appColor,
                                                            data: 'select_image'.tr,
                                                            onTap:null ,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : isSvg(product!.image!
                                                          .toString())
                                                      ? SvgPicture.memory(
                                                          base64.decode(product!
                                                              .image!
                                                              .toString()),
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                        )
                                                      : Image.memory(
                                                          base64Decode(product!
                                                              .image!
                                                              .toString()),
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high,
                                                        ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: ShapeDecoration(
                                  color: Get.find<ThemeController>()
                                          .isDarkMode
                                          .value
                                      ? const Color(0xFF232323)
                                      : AppColor.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1.06,
                                      color: Get.find<ThemeController>()
                                              .isDarkMode
                                              .value
                                          ? const Color(0x82474747)
                                          : const Color(0xFFF3F4F6),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        context.setMinSize(11.17)),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(context.setMinSize(20)),
                                  child: Column(
                                    spacing: context.setHeight(10),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'معلومات المنتج الأساسية',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Get.find<ThemeController>()
                                                  .isDarkMode
                                                  .value
                                              ? AppColor.white
                                              : AppColor.black,
                                          fontSize: context.setSp(14),
                                          fontFamily: 'SansBold',
                                          fontWeight: FontWeight.w600,
                                          height: 1.56,
                                        ),
                                      ),
                                      //product_name
                                      ContainerTextField(
                                        controller: nameController,
                                        labelText: 'product_name'.tr,
                                        hintText: 'product_name'.tr,
                                        keyboardType: TextInputType.text,
                                        width: context.screenWidth,
                                        height: context.setHeight(40),
                                        fontSize: context.setSp(14),
                                        contentPadding: EdgeInsets.fromLTRB(
                                          context.setWidth(9.36),
                                          context.setHeight(10.29),
                                          context.setWidth(7.86),
                                          context.setHeight(4.71),
                                        ),
                                        showLable: true,
                                        borderColor: Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? Colors.white.withValues(
                                                alpha: 0.50,
                                              )
                                            : const Color(0xFFC2C3CB),
                                        fillColor: !Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? Colors.white.withValues(
                                                alpha: 0.43,
                                              )
                                            : const Color(0xFF2B2B2B),
                                        hintcolor: !Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? const Color(0xFF404040)
                                            : const Color(0xFF9CA3AF),
                                        color: !Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? const Color(0xFF404040)
                                            : const Color(0xFF6B7280),
                                        isAddOrEdit: true,
                                        borderRadius: context.setMinSize(
                                          8,
                                        ),
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: context.setWidth(
                                              10,
                                            ),
                                            vertical: context.setHeight(
                                              10,
                                            ),
                                          ),
                                          child: SvgPicture.asset(
                                            AppImages.productEmptySvg,
                                            package: 'shared_widgets',
                                            color: const Color(
                                              0xFF16A6B7,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            errorMessage =
                                                'required_message'.trParams({
                                              'field_name': 'product_name'.tr,
                                            });
                                            countErrors++;
                                            return "";
                                          }
                                          return null;
                                        },
                                      ),
                                      // product_unit_price
                                      ContainerTextField(
                                        controller: unitPriceController,
                                        labelText: 'product_unit_price'.tr,
                                        hintText: 'product_unit_price'.tr,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp('[0-9\$]+'),
                                          ),
                                        ],
                                        keyboardType: TextInputType.number,
                                        width: context.screenWidth,
                                        height: context.setHeight(
                                          40,
                                        ),
                                        fontSize: context.setSp(14),
                                        contentPadding: EdgeInsets.fromLTRB(
                                          context.setWidth(
                                            9.36,
                                          ),
                                          context.setHeight(
                                            10.29,
                                          ),
                                          context.setWidth(
                                            7.86,
                                          ),
                                          context.setHeight(
                                            4.71,
                                          ),
                                        ),
                                        showLable: true,
                                        borderColor: Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? Colors.white.withValues(
                                                alpha: 0.50,
                                              )
                                            : const Color(
                                                0xFFC2C3CB,
                                              ),
                                        fillColor: !Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? Colors.white.withValues(
                                                alpha: 0.43,
                                              )
                                            : const Color(
                                                0xFF2B2B2B,
                                              ),
                                        hintcolor: !Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? const Color(
                                                0xFF404040,
                                              )
                                            : const Color(
                                                0xFF9CA3AF,
                                              ),
                                        color: !Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? const Color(
                                                0xFF404040,
                                              )
                                            : const Color(
                                                0xFF6B7280,
                                              ),
                                        isAddOrEdit: true,
                                        borderRadius: context.setMinSize(8),
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: context.setWidth(6.3),
                                            vertical: context.setHeight(6.3),
                                          ),
                                          child: SvgPicture.asset(
                                            AppImages.dIV59,
                                            package: 'shared_widgets',
                                          ),
                                        ),
                                        validator: (value) {
                                          var message =
                                              ValidatorHelper.priceValidation(
                                            value: value!,
                                            field: 'product_unit_price'.tr,
                                          );
                                          if (message == "") {
                                            return null;
                                          }
                                          errorMessage = message;
                                          return "";
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: ShapeDecoration(
                                  color: Get.find<ThemeController>()
                                          .isDarkMode
                                          .value
                                      ? const Color(0xFF232323)
                                      : AppColor.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1.06,
                                      color: Get.find<ThemeController>()
                                              .isDarkMode
                                              .value
                                          ? const Color(0x82474747)
                                          : const Color(0xFFF3F4F6),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        context.setMinSize(11.17)),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(context.setMinSize(20)),
                                  child: Column(
                                    spacing: context.setHeight(10),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'more_options'.tr,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Get.find<ThemeController>()
                                                      .isDarkMode
                                                      .value
                                                  ? AppColor.white
                                                  : AppColor.black,
                                              fontSize: context.setSp(14),
                                              fontFamily: 'SansBold',
                                              fontWeight: FontWeight.w600,
                                              height: 1.56,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              productController
                                                  .toggleProductViewOptionsInfo();
                                            },
                                            child: Container(
                                                width: context.setWidth(21.15),
                                                height:
                                                    context.setHeight(21.15),
                                                decoration: ShapeDecoration(
                                                  color: Get.find<
                                                              ThemeController>()
                                                          .isDarkMode
                                                          .value
                                                      ? const Color(0xFF202020)
                                                      : const Color(0xFFF1F1F1),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      width: 1.06,
                                                      color: const Color(
                                                          0x21848484),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            context.setMinSize(
                                                                6.34)),
                                                  ),
                                                ),
                                                child: Center(
                                                    child: Transform(
                                                  alignment: Alignment.center,
                                                  transform: Matrix4.rotationX(
                                                    productController
                                                            .showProductOptionsInfo
                                                            .value
                                                        ? 0
                                                        : 3.14,
                                                  ),
                                                  child: SvgPicture.asset(
                                                    AppImages.arrowDown,
                                                    package: 'shared_widgets',
                                                    width:
                                                        context.setWidth(14.84),
                                                    height: context
                                                        .setHeight(14.84),
                                                  ),
                                                ))),
                                          )
                                        ],
                                      ),
                                      Obx(() {
                                        return productController
                                                .showProductOptionsInfo.value
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                spacing: context.setHeight(10),
                                                children: [
                                                  ContainerDropDownField(
                                                    fontSize: context.setSp(14),
                                                    width: context.screenWidth,
                                                    height: context.setHeight(
                                                      40,
                                                    ),
                                                    fillColor: !Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? Colors.white
                                                            .withValues(
                                                            alpha: 0.43,
                                                          )
                                                        : const Color(
                                                            0xFF2B2B2B,
                                                          ),
                                                    borderColor: Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? Colors.white
                                                            .withValues(
                                                            alpha: 0.50,
                                                          )
                                                        : const Color(
                                                            0xFFC2C3CB,
                                                          ),
                                                    hintcolor: !Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? const Color(
                                                            0xFF404040,
                                                          )
                                                        : const Color(
                                                            0xFF9CA3AF,
                                                          ),
                                                    borderRadius:
                                                        context.setMinSize(8),
                                                    hintText: 'taxes',
                                                    labelText: 'taxes'.tr,
                                                    prefixIcon: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: context
                                                            .setWidth(6.3),
                                                        vertical: context
                                                            .setHeight(6.3),
                                                      ),
                                                      child: SvgPicture.asset(
                                                        AppImages.tax,
                                                        package:
                                                            'shared_widgets',
                                                      ),
                                                    ),
                                                    value: (product!.taxesId
                                                            is List)
                                                        ? product!
                                                            .taxesId!.first
                                                        : product!.taxesId,
                                                    color: !Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? const Color(
                                                            0xFF404040,
                                                          )
                                                        : const Color(
                                                            0xFF6B7280,
                                                          ),
                                                    iconcolor: const Color(
                                                      0xFF9CA3AF,
                                                    ),
                                                    onChanged: (val) {
                                                      product!.taxesId = [val];
                                                    },
                                                    items:
                                                        productController
                                                            .taxesList
                                                            .map(
                                                              (
                                                                e,
                                                              ) =>
                                                                  DropdownMenuItem(
                                                                value: e.id,
                                                                child: Center(
                                                                  child: Text(
                                                                    (SharedPr.lang ==
                                                                            'ar'
                                                                        ? e.name!
                                                                            .ar001
                                                                        : e.name!
                                                                            .enUS)!,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Get.find<ThemeController>()
                                                                              .isDarkMode
                                                                              .value
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                            .toList(),
                                                    validator: (value) {
                                                      if (value == null) {
                                                        errorMessage =
                                                            'taxes'.trParams({
                                                          'field_name':
                                                              'taxes'.tr,
                                                        });
                                                        countErrors++;
                                                        return "";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  // product_category
                                                  ContainerDropDownField(
                                                    fontSize: context.setSp(14),
                                                    width: context.screenWidth,
                                                    height: context.setHeight(
                                                      40,
                                                    ),
                                                    fillColor: !Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? Colors.white
                                                            .withValues(
                                                            alpha: 0.43,
                                                          )
                                                        : const Color(
                                                            0xFF2B2B2B,
                                                          ),
                                                    borderColor: Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? Colors.white
                                                            .withValues(
                                                            alpha: 0.50,
                                                          )
                                                        : const Color(
                                                            0xFFC2C3CB,
                                                          ),
                                                    hintcolor: !Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? const Color(
                                                            0xFF404040,
                                                          )
                                                        : const Color(
                                                            0xFF9CA3AF,
                                                          ),
                                                    borderRadius:
                                                        context.setMinSize(8),
                                                    hintText:
                                                        'product_category',
                                                    labelText:
                                                        'product_category'.tr,
                                                    value:
                                                        product!.soPosCategId,
                                                    color: !Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? const Color(
                                                            0xFF404040,
                                                          )
                                                        : const Color(
                                                            0xFF6B7280,
                                                          ),
                                                    iconcolor: const Color(
                                                      0xFF9CA3AF,
                                                    ),
                                                    onChanged: (val) {
                                                      product!.soPosCategId =
                                                          val;
                                                      PosCategory posCategory =
                                                          productController
                                                              .categoriesList
                                                              .firstWhere(
                                                        (element) =>
                                                            element.id == val,
                                                        orElse: () =>
                                                            PosCategory(),
                                                      );
                                                      product!.soPosCategName =
                                                          (SharedPr.lang == 'ar'
                                                              ? posCategory
                                                                  .name!.ar001
                                                              : posCategory
                                                                  .name!.enUS);
                                                    },
                                                    items:
                                                        productController
                                                            .categoriesList
                                                            .map(
                                                              (
                                                                e,
                                                              ) =>
                                                                  DropdownMenuItem(
                                                                value: e.id,
                                                                child: Center(
                                                                  child: Text(
                                                                    (SharedPr.lang ==
                                                                            'ar'
                                                                        ? e.name!
                                                                            .ar001
                                                                        : e.name!
                                                                            .enUS)!,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Get.find<ThemeController>()
                                                                              .isDarkMode
                                                                              .value
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                            .toList(),
                                                    validator: (value) {
                                                      if (value == null) {
                                                        errorMessage =
                                                            'required_message'
                                                                .trParams({
                                                          'field_name':
                                                              'product_category'
                                                                  .tr,
                                                        });
                                                        countErrors++;
                                                        return "";
                                                      }
                                                      return null;
                                                    },
                                                  ),

                                                  Row(
                                                    spacing:
                                                        context.setWidth(16),
                                                    children: [
                                                      // product_barcode
                                                      Expanded(
                                                        child:
                                                            ContainerTextField(
                                                          controller:
                                                              barcodeController,
                                                          labelText:
                                                              'product_barcode'
                                                                  .tr,
                                                          hintText:
                                                              'product_barcode'
                                                                  .tr,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .allow(
                                                              RegExp(
                                                                  '[0-9\$]+'),
                                                            ),
                                                          ],
                                                          width: context
                                                              .screenWidth,
                                                          height:
                                                              context.setHeight(
                                                            40,
                                                          ),
                                                          fontSize:
                                                              context.setSp(14),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                            context.setWidth(
                                                              9.36,
                                                            ),
                                                            context.setHeight(
                                                              10.29,
                                                            ),
                                                            context.setWidth(
                                                              7.86,
                                                            ),
                                                            context.setHeight(
                                                              4.71,
                                                            ),
                                                          ),
                                                          showLable: true,
                                                          borderColor: Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? Colors.white
                                                                  .withValues(
                                                                  alpha: 0.50,
                                                                )
                                                              : const Color(
                                                                  0xFFC2C3CB,
                                                                ),
                                                          fillColor: !Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? Colors.white
                                                                  .withValues(
                                                                  alpha: 0.43,
                                                                )
                                                              : const Color(
                                                                  0xFF2B2B2B,
                                                                ),
                                                          hintcolor: !Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? const Color(
                                                                  0xFF404040,
                                                                )
                                                              : const Color(
                                                                  0xFF9CA3AF,
                                                                ),
                                                          color: !Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? const Color(
                                                                  0xFF404040,
                                                                )
                                                              : const Color(
                                                                  0xFF6B7280,
                                                                ),
                                                          isAddOrEdit: true,
                                                          borderRadius: context
                                                              .setMinSize(8),
                                                          prefixIcon: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal:
                                                                  context
                                                                      .setWidth(
                                                                          6.3),
                                                              vertical: context
                                                                  .setHeight(
                                                                      6.3),
                                                            ),
                                                            child: SvgPicture
                                                                .asset(
                                                              AppImages.barcode,
                                                              package:
                                                                  'shared_widgets',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      //default_code
                                                      Expanded(
                                                        child:
                                                            ContainerTextField(
                                                          controller:
                                                              defaultCodeController,
                                                          labelText:
                                                              'default_code'.tr,
                                                          hintText:
                                                              'default_code'.tr,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          // textAlign: TextAlign.justify,
                                                          width: context
                                                              .screenWidth,
                                                          height:
                                                              context.setHeight(
                                                            40,
                                                          ),
                                                          fontSize:
                                                              context.setSp(14),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                            context.setWidth(
                                                              9.36,
                                                            ),
                                                            context.setHeight(
                                                              10.29,
                                                            ),
                                                            context.setWidth(
                                                              7.86,
                                                            ),
                                                            context.setHeight(
                                                              4.71,
                                                            ),
                                                          ),
                                                          showLable: true,
                                                          borderColor: Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? Colors.white
                                                                  .withValues(
                                                                  alpha: 0.50,
                                                                )
                                                              : const Color(
                                                                  0xFFC2C3CB,
                                                                ),
                                                          fillColor: !Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? Colors.white
                                                                  .withValues(
                                                                  alpha: 0.43,
                                                                )
                                                              : const Color(
                                                                  0xFF2B2B2B,
                                                                ),
                                                          hintcolor: !Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? const Color(
                                                                  0xFF404040,
                                                                )
                                                              : const Color(
                                                                  0xFF9CA3AF,
                                                                ),
                                                          color: !Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? const Color(
                                                                  0xFF404040,
                                                                )
                                                              : const Color(
                                                                  0xFF6B7280,
                                                                ),
                                                          isAddOrEdit: true,
                                                          borderRadius: context
                                                              .setMinSize(8),
                                                          prefixIcon: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal:
                                                                  context
                                                                      .setWidth(
                                                                          10),
                                                              vertical: context
                                                                  .setHeight(
                                                                      10),
                                                            ),
                                                            child: SvgPicture
                                                                .asset(
                                                              AppImages.barcode,
                                                              package:
                                                                  'shared_widgets',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    spacing:
                                                        context.setWidth(16),
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            ContainerDropDownField(
                                                          fontSize:
                                                              context.setSp(14),
                                                          width: context
                                                              .screenWidth,
                                                          height:
                                                              context.setHeight(
                                                            40,
                                                          ),
                                                          fillColor: !Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? Colors.white
                                                                  .withValues(
                                                                  alpha: 0.43,
                                                                )
                                                              : const Color(
                                                                  0xFF2B2B2B,
                                                                ),
                                                          borderColor: Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? Colors.white
                                                                  .withValues(
                                                                  alpha: 0.50,
                                                                )
                                                              : const Color(
                                                                  0xFFC2C3CB,
                                                                ),
                                                          hintcolor: !Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? const Color(
                                                                  0xFF404040,
                                                                )
                                                              : const Color(
                                                                  0xFF9CA3AF,
                                                                ),
                                                          borderRadius: context
                                                              .setMinSize(8),
                                                          hintText:
                                                              'product_type',
                                                          labelText:
                                                              'product_type'.tr,
                                                          value: !SharedPr
                                                                      .userObj!
                                                                      .isPosInventoryModuleInstalled! &&
                                                                  product!.detailedType ==
                                                                      DetailedType
                                                                          .product
                                                                          .enUS
                                                              ? null
                                                              : product!
                                                                  .detailedType,
                                                          color: !Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? const Color(
                                                                  0xFF404040,
                                                                )
                                                              : const Color(
                                                                  0xFF6B7280,
                                                                ),
                                                          iconcolor:
                                                              const Color(
                                                            0xFF9CA3AF,
                                                          ),
                                                          onChanged: (val) {
                                                            product!.detailedType =
                                                                val;
                                                          },
                                                          items: (!SharedPr
                                                                      .userObj!
                                                                      .isPosInventoryModuleInstalled!
                                                                  ? productDetailedType
                                                                      .take(2)
                                                                  : productDetailedType)
                                                              .map(
                                                                (
                                                                  detailedTypeItem,
                                                                ) =>
                                                                    DropdownMenuItem(
                                                                  value:
                                                                      detailedTypeItem
                                                                          .enUS,
                                                                  child: Center(
                                                                    child: Text(
                                                                      (SharedPr.lang ==
                                                                              'ar'
                                                                          ? detailedTypeItem
                                                                              .ar001
                                                                          : detailedTypeItem
                                                                              .enUS),
                                                                      style:
                                                                          TextStyle(
                                                                        color: Get.find<ThemeController>().isDarkMode.value
                                                                            ? Colors.white
                                                                            : Colors.black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                              .toList(),
                                                          validator: (value) {
                                                            if (value == null) {
                                                              errorMessage =
                                                                  'required_message'
                                                                      .trParams({
                                                                'field_name':
                                                                    'product_type'
                                                                        .tr,
                                                              });
                                                              countErrors++;
                                                              return "";
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),

                                                      // product_unit
                                                      Expanded(
                                                        child:
                                                            ContainerDropDownField(
                                                          fontSize:
                                                              context.setSp(14),
                                                          width: context
                                                              .screenWidth,
                                                          height:
                                                              context.setHeight(
                                                            40,
                                                          ),
                                                          fillColor: !Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? Colors.white
                                                                  .withValues(
                                                                  alpha: 0.43,
                                                                )
                                                              : const Color(
                                                                  0xFF2B2B2B,
                                                                ),
                                                          borderColor: Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? Colors.white
                                                                  .withValues(
                                                                  alpha: 0.50,
                                                                )
                                                              : const Color(
                                                                  0xFFC2C3CB,
                                                                ),
                                                          hintcolor: !Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? const Color(
                                                                  0xFF404040,
                                                                )
                                                              : const Color(
                                                                  0xFF9CA3AF,
                                                                ),
                                                          borderRadius: context
                                                              .setMinSize(8),
                                                          hintText:
                                                              'product_unit',
                                                          labelText:
                                                              'product_unit'.tr,
                                                          value: product!.uomId,
                                                          color: !Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? const Color(
                                                                  0xFF404040,
                                                                )
                                                              : const Color(
                                                                  0xFF6B7280,
                                                                ),
                                                          iconcolor:
                                                              const Color(
                                                            0xFF9CA3AF,
                                                          ),
                                                          onChanged: (val) {
                                                            product!.uomId =
                                                                val;
                                                            ProductUnit
                                                                productUnit =
                                                                productController
                                                                    .unitsList
                                                                    .firstWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  val,
                                                              orElse: () =>
                                                                  ProductUnit(),
                                                            );
                                                            product!.uomName =
                                                                (SharedPr.lang ==
                                                                        'ar'
                                                                    ? productUnit
                                                                        .name!
                                                                        .ar001
                                                                    : productUnit
                                                                        .name!
                                                                        .enUS);
                                                          },
                                                          items:
                                                              productController
                                                                  .unitsList
                                                                  .map(
                                                                    (
                                                                      e,
                                                                    ) =>
                                                                        DropdownMenuItem(
                                                                      value:
                                                                          e.id,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          (SharedPr.lang == 'ar'
                                                                              ? e.name!.ar001
                                                                              : e.name!.enUS)!,
                                                                          style:
                                                                              TextStyle(
                                                                            color: Get.find<ThemeController>().isDarkMode.value
                                                                                ? Colors.white
                                                                                : Colors.black,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        top: BorderSide(
                                                          color: Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? const Color(
                                                                  0xFF3F3F3F,
                                                                )
                                                              : const Color(
                                                                  0xFF374151,
                                                                ),
                                                          width: 1,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      spacing:
                                                          context.setHeight(5),
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height:
                                                              context.setHeight(
                                                            5,
                                                          ),
                                                        ),
                                                        Text(
                                                          'more_options'.tr,
                                                          style: TextStyle(
                                                            color: Get.find<
                                                                        ThemeController>()
                                                                    .isDarkMode
                                                                    .value
                                                                ? const Color(
                                                                    0xFFF7F7F8,
                                                                  )
                                                                : const Color(
                                                                    0xFF2F343C,
                                                                  ),
                                                            fontSize:
                                                                context.setSp(
                                                              12,
                                                            ),
                                                            fontFamily:
                                                                'SansMedium',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            height: 2,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Checkbox(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    context
                                                                        .setMinSize(
                                                                      6.94,
                                                                    ),
                                                                  ), // هنا نتحكم بالدائرة أو الحواف
                                                                ),
                                                                value: product!
                                                                        .quickMenuAvailability ??
                                                                    false,
                                                                onChanged:
                                                                    (val) {
                                                                  product?.quickMenuAvailability =
                                                                      val!;
                                                                  setState(
                                                                      () {});
                                                                },
                                                                fillColor:
                                                                    WidgetStateProperty
                                                                        .all(
                                                                  const Color(
                                                                    0xFFFDFDFD,
                                                                  ),
                                                                ),
                                                                checkColor:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                              Text(
                                                                'quick_menu_availability'
                                                                    .tr,
                                                                style:
                                                                    TextStyle(
                                                                  color: Get.find<
                                                                              ThemeController>()
                                                                          .isDarkMode
                                                                          .value
                                                                      ? const Color(
                                                                          0xFFB7B7B7,
                                                                        )
                                                                      : const Color(
                                                                          0xFF404040,
                                                                        ),
                                                                  fontSize: context
                                                                      .setSp(
                                                                          13),
                                                                  fontFamily:
                                                                      'Tajawal',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  height: 1.5,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  ContainerDropDownField(
                                                    fontSize: context.setSp(14),
                                                    width: context.screenWidth,
                                                    height:
                                                        context.setHeight(40),
                                                    fillColor: !Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF2B2B2B),
                                                    borderColor: Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? Colors.white
                                                            .withValues(
                                                            alpha: 0.50,
                                                          )
                                                        : const Color(
                                                            0xFFC2C3CB),
                                                    hintcolor: !Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? const Color(
                                                            0xFF404040)
                                                        : const Color(
                                                            0xFF9CA3AF),
                                                    borderRadius:
                                                        context.setMinSize(
                                                      8,
                                                    ),
                                                    hintText: 'product_note',
                                                    labelText:
                                                        'product_note'.tr,
                                                    value: null,
                                                    color: !Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? const Color(
                                                            0xFF404040)
                                                        : const Color(
                                                            0xFF6B7280),
                                                    iconcolor: const Color(
                                                      0xFF9CA3AF,
                                                    ),
                                                    onChanged: (val) {
                                                      categoryNotes.add(val);
                                                      setState(() {});
                                                    },
                                                    items:
                                                        product?.productCategory
                                                            ?.categoryNotes
                                                            ?.map(
                                                              (e) =>
                                                                  DropdownMenuItem(
                                                                value: e,
                                                                child: Center(
                                                                  child: Text(
                                                                    e.note!,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Get.find<ThemeController>()
                                                                              .isDarkMode
                                                                              .value
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                            .toList(),
                                                  ),
                                                  Wrap(
                                                    spacing: 8.0,
                                                    runSpacing: 4.0,
                                                    children:
                                                        categoryNotes.map((c) {
                                                      return Container(
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: !SharedPr
                                                                  .isDarkMode!
                                                              ? Colors.white
                                                                  .withValues(
                                                                  alpha: 0.43,
                                                                )
                                                              : const Color(
                                                                  0xFF2B2B2B,
                                                                ),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: BorderSide(
                                                              color: Get.find<
                                                                          ThemeController>()
                                                                      .isDarkMode
                                                                      .value
                                                                  ? const Color(
                                                                      0xFF1B1B1B,
                                                                    )
                                                                  : const Color(
                                                                      0xFFF3F3F3,
                                                                    ),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              context
                                                                  .setMinSize(
                                                                16,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                            context.setMinSize(
                                                              10,
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            spacing: context
                                                                .setWidth(25),
                                                            children: [
                                                              Text(
                                                                c.note!,
                                                                style:
                                                                    TextStyle(
                                                                  color: Get.find<
                                                                              ThemeController>()
                                                                          .isDarkMode
                                                                          .value
                                                                      ? Colors
                                                                          .white
                                                                      : const Color(
                                                                          0xFF4B5563,
                                                                        ),
                                                                  fontSize:
                                                                      context
                                                                          .setSp(
                                                                    14,
                                                                  ),
                                                                  fontFamily:
                                                                      'Tajawal',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 1.43,
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  categoryNotes
                                                                      .remove(
                                                                          c);
                                                                  setState(
                                                                      () {});
                                                                },
                                                                child: Icon(
                                                                  Icons.clear,
                                                                  size: context
                                                                      .setMinSize(
                                                                    16,
                                                                  ),
                                                                  color:
                                                                      const Color(
                                                                    0xFF6B7280,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              )
                                            : Container();
                                      })
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                spacing: context.setWidth(16),
                                children: [
                                  Expanded(
                                    child: ButtonClick(
                                      color: AppColor.appColor,
                                      data: (product!.id != null
                                              ? 'edit_product'
                                              : 'add_product')
                                          .tr,
                                      onTap: _onPressed,
                                    ),
                                  ),
                                  Expanded(
                                    child: ButtonClick(
                                      color: const Color(0xFF4B5563),
                                      data: "back".tr,
                                      onTap: () {
                                        Get.back();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                productController.isLoading.value
                    ? const LoadingWidget()
                    : Container(),
              ],
            )),
      );
    }));
  }

  _onPressed() async {
    try {
      // for(int i=0 ; SharedPr.chosenUserObj.p)
      LoadingDataController loadingDataController =
          Get.find<LoadingDataController>();
      productController.isLoading.value = true;
      productController.searchResults.clear();
      productController.update();
      ProductService.productDataServiceInstance = null;
      ProductService.getInstance();
      countErrors = 0;
      if (_formKey.currentState!.validate()) {
        ProductName processedProductName;
        if (product!.id == null) {
          processedProductName = ProductName(
            enUS: nameController.text,
            ar001: nameController.text,
          );
        } else {
          processedProductName = ProductName(
            enUS: SharedPr.lang == 'en'
                ? nameController.text
                : product!.productName!.enUS,
            ar001: SharedPr.lang == 'ar'
                ? nameController.text
                : product!.productName!.ar001,
          );
        }
        product!
          ..productName = processedProductName
          ..barcode =
              barcodeController.text == "" ? null : barcodeController.text
          ..unitPrice = double.parse(unitPriceController.text)
          ..defaultCode = defaultCodeController.text == ""
              ? null
              : defaultCodeController.text
          ..uomId = 1
          ..productNotes = categoryNotes;

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
          responseResult = await productController.createProduct(
            product: product!,
          );
        } else {
          responseResult = await productController.updateProduct(
            product: product!,
          );
        }
        await loadingDataController.getitems();
        if (responseResult.status) {
          if (widget.objectToEdit == null && pagesNumber == 1) {
            productController.pagingList.add(responseResult.data!);
          }
          // var productIndex =productController.pagingList.indexOf(widget.objectToEdit);
          var productIndex = productController.pagingList.indexWhere(
            (item) => item.id == widget.objectToEdit?.id,
          );
          if (productIndex != -1) {
            productController.pagingList[productIndex] = product!;
          }

          productController.update();
          product = Product();
          productController.isLoading.value = false;
          productController.update();

          appSnackBar(
            messageType: MessageTypes.success,
            message: responseResult.message,
          );
          Get.back();
          productController.pagnationpagesNumber = 0;
          await productController.resetPagingList(selectedpag: 0);
        } else {
          productController.isLoading.value = false;
          productController.update();

          appSnackBar(message: responseResult.message);
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
    } catch (e) {
      productController.isLoading.value = false;
      appSnackBar(status: false, message: e.toString());
    }
  }
}
