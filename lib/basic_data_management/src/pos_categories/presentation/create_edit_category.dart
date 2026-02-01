import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/pos_categories_data/pos_category.dart';
import 'package:pos_shared_preferences/models/pos_categories_data/pos_category_name.dart';
import 'package:pos_shared_preferences/models/pos_categories_data/pos_category_note.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_enums.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_dialog.dart';
import 'package:shared_widgets/shared_widgets/app_drop_down_field.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos_categories/domain/pos_category_service.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos_categories/domain/pos_category_viewmodel.dart';

import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/product_screen.dart';

void createEditeCategory({
  required BuildContext context,
  PosCategory? objectToEdit,
}) {
  final PosCategoryController posCategoryController = Get.put(
    PosCategoryController(),
    tag: 'categoryControllerMain',
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String? errorMessage;
  int countErrors = 0;
  bool isOpen = false;
  PosCategory? posCategory;
  List<CategoryNote> categoryNotes = [];
  posCategory =
      objectToEdit != null ? PosCategory.fromJson(objectToEdit.toJson()) : null;

  if (posCategory?.id != null) {
    nameController.text = (SharedPr.lang == 'ar'
        ? posCategory?.name?.ar001
        : posCategory?.name?.enUS)!;
    categoryNotes = posCategory!.categoryNotes ?? [];
  }
  posCategory ??= PosCategory();
  back() async {
    posCategoryController.updateHideMenu(false);
    posCategoryController.object = null;
    Get.back();
  }

  _onPressed() async {
    try {
      posCategoryController.isLoading.value = true;
      posCategoryController.update();
      PosCategoryService.posCategoryDataServiceInstance = null;
      PosCategoryService.getInstance();

      countErrors = 0;
      if (_formKey.currentState!.validate()) {
        // posCategory!.categoryNotes = categoryNotes;
        // (posCategory ??= PosCategory()).name =
        //     posCategory!.id == null
        //         ? PosCategoryName(
        //           enUS: nameController.text,
        //           ar001: nameController.text,
        //         )
        //         : PosCategoryName(
        //           enUS:
        //               SharedPr.lang == 'en'
        //                   ? nameController.text
        //                   : posCategory!.name!.enUS,
        //           ar001:
        //               SharedPr.lang == 'ar'
        //                   ? nameController.text
        //                   : posCategory!.name!.ar001,
        //         );
        // عيّن الملاحظات
        posCategory!.categoryNotes = categoryNotes;

        // إذا الفئة جديدة (ما لها id بعد)
        if (posCategory!.id == null) {
          posCategory!.name = PosCategoryName(
            enUS: nameController.text,
            ar001: nameController.text,
          );
        } else {
          // إذا كانت فئة موجودة مسبقاً — حدّث فقط الاسم حسب اللغة الحالية
          posCategory!.name = PosCategoryName(
            enUS: SharedPr.lang == 'en'
                ? nameController.text
                : posCategory!.name?.enUS ?? '',
            ar001: SharedPr.lang == 'ar'
                ? nameController.text
                : posCategory!.name?.ar001 ?? '',
          );
        }

        ResponseResult responseResult;
        if (posCategory?.id == null) {
          responseResult = await posCategoryController.createPosCategory(
            posCategory: posCategory!,
          );
        } else {
          // posCategory?.name = PosCategoryName(enUS: nameController.text, ar001: nameController.text);
          // if (kDebugMode) {
          //   print('posCategory?.name : ${posCategory?.name}');
          // }
          responseResult = await posCategoryController.updatePosCategory(
            posCategory: posCategory!,
          );
        }
        if (responseResult.status) {
          if (objectToEdit == null) {
            posCategoryController.posCategoryList.add(responseResult.data!);
          }

          var posCategoryIndex =
              posCategoryController.posCategoryList.indexWhere(
            (item) => item.id == objectToEdit?.id,
          );
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
          appSnackBar(message: responseResult.message);
        }
      } else {
        posCategoryController.isLoading.value = false;
        posCategoryController.update();
        appSnackBar(
          message: countErrors > 1 ? 'enter_required_info'.tr : errorMessage!,
        );
      }
    } catch (e) {
      posCategoryController.isLoading.value = false;
      appSnackBar(status: false, message: e.toString());
    }
  }

  dialogcontent(
    barrierDismissible: true,
    content: StatefulBuilder(
      builder: (BuildContext context, setState) {
        return GetBuilder<PosCategoryController>(
          tag: 'categoryControllerMain',
          builder: (controller) {
            return Builder(
              builder: (context) {
                return Container(
                  width: context.setWidth(720),
                  height: context.setHeight(440),
                  padding: EdgeInsets.all(context.setMinSize(20)),
                  child: Obx(
                    () => IgnorePointer(
                      ignoring: posCategoryController.isLoading.value,
                      child: Stack(
                        children: [
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.setWidth(5),
                                vertical: context.setHeight(5),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  spacing: context.setHeight(27),
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      spacing: context.setHeight(10),
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (posCategory?.id == null)
                                                  ? "add_new_pos_category".tr
                                                  : 'edit_pos_category'.tr,
                                              style: TextStyle(
                                                color:  Get.find<ThemeController>().isDarkMode.value 
                                                    ? Colors.white
                                                    : const Color(
                                                        0xFF0C0C0C,
                                                      ),
                                                fontSize: context.setSp(18),
                                                fontFamily: 'Tajawal',
                                                fontWeight: FontWeight.w500,
                                                height: 1.42,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: SvgPicture.asset(
                                                AppImages.cancel,
                                                package: 'shared_widgets',
                                                width: context.setWidth(13),
                                                height: context.setHeight(13),
                                                color:  Get.find<ThemeController>().isDarkMode.value 
                                                    ? null
                                                    : const Color(
                                                        0xFF0C0C0C,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: context.setWidth(720),
                                          // decoration: ShapeDecoration(
                                          //   color:
                                          //        Get.find<ThemeController>().isDarkMode.value 
                                          //           ? const Color(0xFF292929)
                                          //           : Colors.white,
                                          //   shape: RoundedRectangleBorder(
                                          //     // side: BorderSide(
                                          //     //   width: 0.78,
                                          //     //   color: const Color(0xFFE5E7EB),
                                          //     // ),
                                          //     borderRadius:
                                          //         BorderRadius.circular(
                                          //           context.setMinSize(12.41),
                                          //         ),
                                          //   ),
                                          // ),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                              context.setMinSize(16),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              spacing: context.setWidth(16),
                                              children: [
                                                ButtonClick(
                                                  color: const Color(
                                                    0xFF16A6B7,
                                                  ),
                                                  data: (posCategory
                                                              ?.id ==
                                                          null)
                                                      ? "add_new_pos_category"
                                                          .tr
                                                      : 'edit_pos_category'.tr,
                                                  onTap: _onPressed,
                                                ),
                                                ButtonClick(
                                                  color: null,
                                                  data: 'back'.tr,
                                                  horizontal: 18,
                                                  borderColor: const Color(
                                                    0xFFD1D5DB,
                                                  ),
                                                  onTap: () {
                                                    Get.back();
                                                  },
                                                ),
                                                
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(
                                            context.setMinSize(16),
                                          ),
                                          decoration: ShapeDecoration(
                                            color:  Get.find<ThemeController>().isDarkMode.value 
                                                ? const Color(0xFF292929)
                                                : Colors.white,
                                            shape: RoundedRectangleBorder(
                                              // side: BorderSide(
                                              //   width: 0.78,
                                              //   color: const Color(0xFFE5E7EB),
                                              // ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                context.setMinSize(12.41),
                                              ),
                                            ),
                                            shadows: [
                                              BoxShadow(
                                                color: Color(0x0C000000),
                                                blurRadius: 1.55,
                                                offset: Offset(0, 0.78),
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            spacing: context.setHeight(16),
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ContainerTextField(
                                                controller: nameController,
                                                labelText:
                                                    'pos_category_name'.tr,
                                                hintText:
                                                    'pos_category_name'.tr,
                                                keyboardType:
                                                    TextInputType.text,
                                                width: context.screenWidth,
                                                height: context.setHeight(40),
                                                fontSize: context.setSp(14),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                  context.setWidth(9.36),
                                                  context.setHeight(10.29),
                                                  context.setWidth(7.86),
                                                  context.setHeight(4.71),
                                                ),
                                                showLable: false,
                                                borderColor: Get.find<ThemeController>().isDarkMode.value
                                                    ? Colors.white.withValues(
                                                        alpha: 0.50,
                                                      )
                                                    : const Color(
                                                        0xFFC2C3CB,
                                                      ),
                                                fillColor: ! Get.find<ThemeController>().isDarkMode.value 
                                                    ? Colors.white.withValues(
                                                        alpha: 0.43,
                                                      )
                                                    : const Color(
                                                        0xFF2B2B2B,
                                                      ),
                                                hintcolor: ! Get.find<ThemeController>().isDarkMode.value 
                                                    ? const Color(
                                                        0xFF6B7280,
                                                      )
                                                    : const Color(
                                                        0xFF9CA3AF,
                                                      ),
                                                color: ! Get.find<ThemeController>().isDarkMode.value 
                                                    ? const Color(
                                                        0xFF6B7280,
                                                      )
                                                    : const Color(
                                                        0xFF6B7280,
                                                      ),
                                                isAddOrEdit: true,
                                                borderRadius:
                                                    context.setMinSize(8),
                                                prefixIcon: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        context.setWidth(10),
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
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    errorMessage =
                                                        'required_message'
                                                            .trParams({
                                                      'field_name':
                                                          'pos_category_name'
                                                              .tr,
                                                    });
                                                    countErrors++;
                                                    return "";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              ContainerDropDownField(
                                                fontSize: context.setSp(14),
                                                width: context.screenWidth,
                                                height: context.setHeight(40),
                                                fillColor: ! Get.find<ThemeController>().isDarkMode.value 
                                                    ? Colors.white
                                                    : const Color(
                                                        0xFF2B2B2B,
                                                      ),
                                                borderColor: Get.find<ThemeController>().isDarkMode.value
                                                    ? Colors.white.withValues(
                                                        alpha: 0.50,
                                                      )
                                                    : const Color(
                                                        0xFFC2C3CB,
                                                      ),
                                                hintcolor: ! Get.find<ThemeController>().isDarkMode.value 
                                                    ? const Color(
                                                        0xFF404040,
                                                      )
                                                    : const Color(
                                                        0xFF9CA3AF,
                                                      ),
                                                borderRadius:
                                                    context.setMinSize(8),
                                                hintText: 'parent_category',
                                                labelText: 'parent_category'.tr,
                                                value: posCategory?.parentId,
                                                color: ! Get.find<ThemeController>().isDarkMode.value 
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
                                                  posCategory!.parentId = val;
                                                  PosCategory category =
                                                      controller.posCategoryList
                                                          .firstWhere(
                                                    (element) =>
                                                        element.id == val,
                                                    orElse: () => PosCategory(),
                                                  );
                                                  posCategory!.parentName =
                                                      category.name;
                                                },
                                                items: controller
                                                    .posCategoryList
                                                    .where(
                                                      (item) =>
                                                          item.id !=
                                                          posCategory?.id,
                                                    )
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
                                                                ? e.name!.ar001
                                                                : e.name!
                                                                    .enUS)!,
                                                            style: TextStyle(
                                                              color: Get.find<ThemeController>().isDarkMode.value
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                              
                                              InkWell(
                                                onTap: () {
                                                  isOpen = !isOpen;
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  decoration: ShapeDecoration(
                                                    color:  Get.find<ThemeController>().isDarkMode.value 
                                                        ? Colors.black
                                                            .withValues(
                                                            alpha: 0.37,
                                                          )
                                                        : const Color(
                                                            0xFFF9FAFB,
                                                          ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        context.setMinSize(
                                                          8,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      context.setMinSize(10),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'additional_notes'.tr,
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                            color: Get.find<ThemeController>().isDarkMode.value
                                                                ? Colors.white
                                                                : const Color(
                                                                    0xFF0C0C0C,
                                                                  ),
                                                            fontSize: context
                                                                .setSp(13.27),
                                                            fontFamily:
                                                                'Tajawal',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 1.50,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: context
                                                              .setWidth(30),
                                                          height: context
                                                              .setHeight(30),
                                                          child: Transform(
                                                            alignment: Alignment
                                                                .center,
                                                            transform: isOpen
                                                                ? Matrix4
                                                                    .rotationX(
                                                                    3.14,
                                                                  )
                                                                : Matrix4
                                                                    .rotationZ(
                                                                    90 *
                                                                        3.1416 /
                                                                        180,
                                                                  ),
                                                            child: SvgPicture
                                                                .asset(
                                                              AppImages
                                                                  .arrowDown,
                                                              package:
                                                                  'shared_widgets',
                                                              color:
                                                                  const Color(
                                                                0xFF9CA3AF,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (isOpen) ...[
                                                Row(
                                                  spacing: context.setWidth(16),
                                                  children: [
                                                    Expanded(
                                                      child: ContainerTextField(
                                                        controller:
                                                            noteController,
                                                        labelText:
                                                            'add_note'.tr,
                                                        hintText: 'add_note'.tr,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        width:
                                                            context.screenWidth,
                                                        height: context
                                                            .setHeight(40),
                                                        fontSize: context.setSp(
                                                          14,
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
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
                                                        showLable: false,
                                                        borderColor:
                                                             Get.find<ThemeController>().isDarkMode.value 
                                                                ? Colors.white
                                                                    .withValues(
                                                                    alpha: 0.50,
                                                                  )
                                                                : const Color(
                                                                    0xFFC2C3CB,
                                                                  ),
                                                        fillColor: !Get.find<ThemeController>().isDarkMode.value
                                                            ? Colors.white
                                                                .withValues(
                                                                alpha: 0.43,
                                                              )
                                                            : const Color(
                                                                0xFF2B2B2B,
                                                              ),
                                                        hintcolor: !Get.find<ThemeController>().isDarkMode.value
                                                            ? const Color(
                                                                0xFF6B7280,
                                                              )
                                                            : const Color(
                                                                0xFF9CA3AF,
                                                              ),
                                                        color: !Get.find<ThemeController>().isDarkMode.value
                                                            ? const Color(
                                                                0xFF6B7280,
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
                                                            horizontal: context
                                                                .setWidth(
                                                              10,
                                                            ),
                                                            vertical: context
                                                                .setHeight(
                                                              10,
                                                            ),
                                                          ),
                                                          child:
                                                              SvgPicture.asset(
                                                            AppImages
                                                                .productEmptySvg,
                                                            package:
                                                                'shared_widgets',
                                                            color: const Color(
                                                              0xFF16A6B7,
                                                            ),
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                    ButtonElevated(
                                                      text: 'addition'.tr,
                                                      height:context.setHeight(40) ,
                                                      width: context.setWidth(
                                                        100,
                                                      ),
                                                      borderRadius: context.setMinSize(9),
                                                      borderColor: const Color(
                                                        0xFF16A6B7,
                                                      ),
                                                      textStyle: TextStyle(
                                                        color: const Color(
                                                          0xFF16A6B7,
                                                        ),
                                                        fontSize: context.setSp(
                                                          13.27,
                                                        ),
                                                        fontFamily: 'Tajawal',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      onPressed: () {
                                                        if (noteController
                                                            .text.isNotEmpty) {
                                                          categoryNotes.add(
                                                            CategoryNote(
                                                              note:
                                                                  noteController
                                                                      .text,
                                                            ),
                                                          );
                                                          noteController.text =
                                                              '';
                                                          setState(() {});
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Wrap(
                                                  spacing: 8.0,
                                                  runSpacing: 4.0,
                                                  children:
                                                      (categoryNotes).map((c) {
                                                    return Container(
                                                      decoration:
                                                          ShapeDecoration(
                                                        color:
                                                             Get.find<ThemeController>().isDarkMode.value 
                                                                ? const Color(
                                                                    0xFF1B1B1B,
                                                                  )
                                                                : const Color(
                                                                    0xFFF3F3F3,
                                                                  ),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            color: Get.find<ThemeController>().isDarkMode.value
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
                                                            context.setMinSize(
                                                              16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                          context.setMinSize(
                                                            10,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          spacing: context
                                                              .setWidth(25),
                                                          children: [
                                                            Text(
                                                              c.note!,
                                                              style: TextStyle(
                                                                color: Get.find<ThemeController>().isDarkMode.value
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
                                                                  c,
                                                                );
                                                                setState(
                                                                  () {},
                                                                );
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
                                            
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Container(
                                    //   width: context.setWidth(720),
                                    //   decoration: ShapeDecoration(
                                    //     color:
                                    //          Get.find<ThemeController>().isDarkMode.value 
                                    //             ? const Color(0xFF292929)
                                    //             : Colors.white,
                                    //     shape: RoundedRectangleBorder(
                                    //       // side: BorderSide(
                                    //       //   width: 0.78,
                                    //       //   color: const Color(0xFFE5E7EB),
                                    //       // ),
                                    //       borderRadius: BorderRadius.circular(
                                    //         context.setMinSize(12.41),
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   child: Padding(
                                    //     padding: EdgeInsets.all(
                                    //       context.setMinSize(16),
                                    //     ),
                                    //     child: Row(
                                    //       spacing: context.setWidth(16),
                                    //       children: [
                                    //         ButtonClick(
                                    //           color: const Color(0xFF16A6B7),
                                    //           data:
                                    //               (posCategory?.id == null)
                                    //                   ? "add_new_pos_category".tr
                                    //                   : 'edit_pos_category'.tr,
                                    //           onTap: _onPressed,
                                    //         ),
                                    //         ButtonElevated(
                                    //           text: 'back'.tr,
                                    //           width: context.setWidth(100),
                                    //           borderRadius: context.setMinSize(
                                    //             9,
                                    //           ),
                                    //           borderColor: const Color(
                                    //             0xFFD1D5DB,
                                    //           ),
                                    //           textStyle: TextStyle(
                                    //             color:
                                    //                  Get.find<ThemeController>().isDarkMode.value 
                                    //                     ? Colors.white
                                    //                     : const Color(
                                    //                       0xFF374151,
                                    //                     ),
                                    //             fontSize: context.setSp(13.27),
                                    //             fontFamily: 'Tajawal',
                                    //             fontWeight: FontWeight.w400,
                                    //           ),
                                    //           onPressed: () {
                                    //             Get.back();
                                    //           },
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          posCategoryController.isLoading.value
                              ? const LoadingWidget()
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ),
    context: context,
  ).then((_) {});
}
