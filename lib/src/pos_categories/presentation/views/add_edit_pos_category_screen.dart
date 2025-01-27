// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/pos_categories_data/pos_category.dart';
import 'package:pos_shared_preferences/models/pos_categories_data/pos_category_name.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_enum.dart';
import 'package:shared_widgets/config/app_styles.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_drop_down_field.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:yousentech_pos_basic_data_management/src/pos_categories/domain/pos_category_service.dart';
import '../../../products/presentation/widget/tital.dart';
import '../../domain/pos_category_viewmodel.dart';

class AddPosCategoryScreen extends StatefulWidget {
  PosCategory? objectToEdit;

  AddPosCategoryScreen({super.key, this.objectToEdit});

  @override
  State<AddPosCategoryScreen> createState() => _AddPosCategoryScreenState();
}

class _AddPosCategoryScreenState extends State<AddPosCategoryScreen> {
  final PosCategoryController posCategoryController =
      Get.put(PosCategoryController(), tag: 'categoryControllerMain');
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PosCategory? posCategory;
  String? errorMessage;
  int countErrors = 0;
  back() async {
    posCategoryController.updateHideMenu(false);
    posCategoryController.object = null;
    Get.back();
    // posCategoryController.update();
    // await loadingDataController.getitems();
  }

  @override
  void initState() {
    super.initState();
    posCategory = widget.objectToEdit != null
        ? PosCategory.fromJson(widget.objectToEdit!.toJson())
        : null;

    if (posCategory?.id != null) {
      nameController.text = (SharedPr.lang == 'ar'
          ? posCategory?.name?.ar001
          : posCategory?.name?.enUS)!;
    }
    posCategory ??= PosCategory();
  }
  // TODO :CHEACK IF THE CODE IS NESSICERE
  // final DashboardController dashboardController =
  //     Get.put(DashboardController.getInstance());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosCategoryController>(
        tag: 'categoryControllerMain',
        builder: (controller) {
          print("posCategory!.parentId ${posCategory?.parentId}");
          return IgnorePointer(
            ignoring: posCategoryController.isLoading.value,
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: Get.width * 0.5,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitalWidget(
                              title: (posCategory?.id == null)
                                  ? 'add_new_pos_category'.tr
                                  : 'edit_pos_category'.tr),
                          Container(
                              margin: EdgeInsets.only(
                                  top: 10.r, left: 20.r, right: 20.r),
                              padding: EdgeInsets.all(20.r),
                              width: 0.6.sw,
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
                                  child: Column(children: [
                                    ContainerTextField(
                                      focusNode: nameFocusNode,
                                      controller: nameController,
                                      height: 30.h,
                                      width: 0.6.sw,
                                      labelText: '',
                                      hintText: 'pos_category_name'.tr,
                                      fontSize: 10.r,
                                      fillColor: AppColor.white,
                                      borderColor: AppColor.silverGray,
                                      hintcolor:
                                          AppColor.black.withOpacity(0.5),
                                      isAddOrEdit: true,
                                      borderRadius: 5.r,
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.r, vertical: 5.r),
                                        child: SvgPicture.asset(
                                          "assets/image/name_product.svg",
                                          package:
                                              'yousentech_pos_basic_data_management',
                                          width: 19.r,
                                          height: 19.r,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          errorMessage = 'required_message'
                                              .trParams({
                                            'field_name': 'pos_category_name'.tr
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
                                    ContainerDropDownField(
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.r, vertical: 5.r),
                                        child: SvgPicture.asset(
                                          "assets/image/categories_menu_icon.svg",
                                          package:
                                              'yousentech_pos_basic_data_management',
                                          width: 19.r,
                                          height: 19.r,
                                          color:
                                              AppColor.amber.withOpacity(0.5),
                                        ),
                                      ),
                                      fontSize: 10.r,
                                      fillColor: AppColor.white,
                                      borderColor: AppColor.silverGray,
                                      hintcolor:
                                          AppColor.black.withOpacity(0.5),
                                      borderRadius: 5.r,
                                      hintText: 'parent_category'.tr,
                                      labelText: 'parent_category'.tr,
                                      value: posCategory?.parentId,
                                      color: AppColor.black,
                                      iconcolor: AppColor.black,
                                      onChanged: (val) {
                                        posCategory!.parentId = val;
                                        PosCategory category = controller
                                            .posCategoryList
                                            .firstWhere(
                                                (element) => element.id == val,
                                                orElse: () => PosCategory());
                                        posCategory!.parentName =
                                            category.name!;
                                      },
                                      validator: (value) {
                                        return null;
                                      },
                                      items: controller.posCategoryList
                                          .where((item) =>
                                              item.id != posCategory?.id)
                                          .map((e) => DropdownMenuItem(
                                                // value: e.id,
                                                value: e.id,
                                                child: Center(
                                                    child: Text(
                                                        (SharedPr.lang == 'ar'
                                                            ? e.name!.ar001
                                                            : e.name!.enUS)!)),
                                              ))
                                          .toList(),
                                    ),
                                    SizedBox(
                                      height: 20.r,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ButtonElevated(
                                              text: (posCategory?.id != null
                                                      ? 'edit_pos_category'
                                                      : 'add_new_pos_category')
                                                  .tr,
                                              borderRadius: 5.r,
                                              backgroundColor:
                                                  AppColor.cyanTeal,
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
                                                  fontWeight:
                                                      FontWeight.normal),
                                              onPressed: () {
                                                back();

                                                // Get.back();
                                              }),
                                        ),
                                      ],
                                    ),
                                  ]))),
                          // Card(
                          //   // surfaceTintColor: AppColor.white,
                          //   child: Form(
                          //     key: _formKey,
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(30.0),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         mainAxisAlignment: MainAxisAlignment.start,
                          //         mainAxisSize: MainAxisSize.min,
                          //         children: [
                          //           Center(
                          //             child: sideUserMenu[SideUserMenu
                          //                         .dataManagement]![1]
                          //                     .last
                          //                     .first is IconData
                          //                 ? Icon(
                          //                     sideUserMenu[SideUserMenu
                          //                             .dataManagement]![1]
                          //                         .last
                          //                         .first,
                          //                     size: MediaQuery.of(context)
                          //                             .size
                          //                             .height *
                          //                         0.1,
                          //                     color: AppColor.purple,
                          //                   )
                          //                 : Image.asset(
                          //                     "assets/image/${sideUserMenu[SideUserMenu.dataManagement]![1].last.first}.png",
                          //                     width: MediaQuery.of(context)
                          //                             .size
                          //                             .height *
                          //                         0.1,
                          //                     color: AppColor.purple,
                          //                   ),
                          //           ),

                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Column(
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.start,
                          //                 children: [
                          //                   Text(
                          //                       ((posCategory?.id == null)
                          //                               ? 'add_new_pos_category'
                          //                               : 'edit_pos_category')
                          //                           .tr,
                          //                       style: AppStyle.textStyle(
                          //                           color: AppColor.black,
                          //                           fontSize: Get.width * 0.02,
                          //                           fontWeight: FontWeight.bold)
                          //                       //  AppStyle.header1,
                          //                       ),
                          //                   Text(
                          //                       'add_new_pos_category_message'
                          //                           .tr,
                          //                       style: AppStyle.textStyle(
                          //                           color: AppColor.grey,
                          //                           fontSize: Get.width * 0.01,
                          //                           fontWeight:
                          //                               FontWeight.bold)),
                          //                 ],
                          //               ),
                          //             ],
                          //           ),
                          //           // Text((sideUserMenu[SideUserMenu.prodects]!.last.first)
                          //           //     .toString()),

                          //           SizedBox(height: Get.height * 0.02),
                          //           Text('pos_category_name'.tr,
                          //               style: AppStyle.textStyle(
                          //                   color: AppColor.black,
                          //                   fontSize: Get.width * 0.01,
                          //                   fontWeight: FontWeight.bold)
                          //               //  AppStyle.header1,
                          //               ),
                          //           SizedBox(height: Get.height * 0.01),

                          //           ContainerTextField(
                          //             focusNode: nameFocusNode,
                          //             width: Get.width * 0.45,
                          //             prefixIcon: Icon(
                          //               Icons.person,
                          //               size: 4.sp,
                          //               color: AppColor.black,
                          //             ),
                          //             height:
                          //                 MediaQuery.sizeOf(context).height *
                          //                     0.05,
                          //             controller: nameController,
                          //             isAddOrEdit: true,
                          //             isPIN: true,
                          //             hintText: 'pos_category_name'.tr,
                          //             labelText: 'pos_category_name'.tr,
                          //             hintcolor:
                          //                 AppColor.black.withOpacity(0.5),
                          //             iconcolor: AppColor.black,
                          //             color: AppColor.black,
                          //             fontSize: Get.width * 0.01,
                          //             validator: (value) {
                          //               if (value == null || value.isEmpty) {
                          //                 errorMessage = 'required_message'
                          //                     .trParams({
                          //                   'field_name': 'pos_category_name'.tr
                          //                 });
                          //                 countErrors++;
                          //                 return "";
                          //               }
                          //               return null;
                          //             },
                          //           ),
                          //           SizedBox(height: Get.height * 0.02),

                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.end,
                          //             children: [
                          //               ButtonElevated(
                          //                   width: Get.width * 0.15,
                          //                   text: 'cancel'.tr,
                          //                   backgroundColor:
                          //                       AppColor.shadepurple,
                          //                   onPressed: () {
                          //                     back();
                          //                   }),
                          //               SizedBox(width: Get.width * 0.01),
                          //               // Obx(() {
                          //               //   if (posCategoryController.isLoading.value) {
                          //               //     return CircularProgressIndicator(
                          //               //       color: AppColor.purple,
                          //               //       // backgroundColor: AppColor.black,
                          //               //     );
                          //               //   } else {
                          //               //     return
                          //               ButtonElevated(
                          //                   text: (posCategory?.id != null
                          //                           ? 'edit_pos_category'
                          //                           : 'add_new_pos_category')
                          //                       .tr,
                          //                   width: Get.width * 0.15,
                          //                   backgroundColor:
                          //                       AppColor.shadepurple,
                          //                   onPressed: _onPressed)
                          //               //   ;
                          //               //   }
                          //               // }),
                          //             ],
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  posCategoryController.isLoading.value
                      ? const LoadingWidget()
                      : Container(),
                ],
              ),
            ),
          );
        });
  }

  _onPressed() async {
    posCategoryController.isLoading.value = true;
    posCategoryController.update();
    PosCategoryService.posCategoryDataServiceInstance = null;
    PosCategoryService.getInstance();

    countErrors = 0;
    if (_formKey.currentState!.validate()) {
      (posCategory ??= PosCategory()).name = posCategory!.id == null
          ? PosCategoryName(
              enUS: nameController.text, ar001: nameController.text)
          : PosCategoryName(
              enUS: SharedPr.lang == 'en'
                  ? nameController.text
                  : posCategory!.name!.enUS,
              ar001: SharedPr.lang == 'ar'
                  ? nameController.text
                  : posCategory!.name!.ar001);

      ResponseResult responseResult;
      if (posCategory?.id == null) {
        responseResult = await posCategoryController.createPosCategory(
            posCategory: posCategory!);
      } else {
        // posCategory?.name = PosCategoryName(enUS: nameController.text, ar001: nameController.text);
        // if (kDebugMode) {
        //   print('posCategory?.name : ${posCategory?.name}');
        // }
        responseResult = await posCategoryController.updatePosCategory(
            posCategory: posCategory!);
      }
      if (responseResult.status) {
        if (widget.objectToEdit == null) {
          posCategoryController.posCategoryList.add(responseResult.data!);
        }

        var posCategoryIndex = posCategoryController.posCategoryList
            .indexWhere((item) => item.id == widget.objectToEdit?.id);
        if (posCategoryIndex != -1) {
          posCategoryController.posCategoryList[posCategoryIndex] =
              posCategory!;
        }
        posCategoryController.update();
        posCategory = null;
        posCategoryController.isLoading.value = false;
        posCategoryController.update();
        appSnackBar(
          messageType: MessageTypes.success,
          message: responseResult.message,
        );
        back();
      } else {
        posCategoryController.isLoading.value = false;
        posCategoryController.update();
        appSnackBar(
          message: responseResult.message,
        );
      }
    } else {
      posCategoryController.isLoading.value = false;
      posCategoryController.update();
      appSnackBar(
        message: countErrors > 1 ? 'enter_required_info'.tr : errorMessage!,
      );
    }
  }
}
