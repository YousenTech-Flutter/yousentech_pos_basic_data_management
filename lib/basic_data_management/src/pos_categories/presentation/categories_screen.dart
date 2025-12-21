import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_enums.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos_categories/domain/pos_category_service.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos_categories/domain/pos_category_viewmodel.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos_categories/presentation/create_edit_category.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos_categories/utils/build_category_body_table.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos_categories/widgets/show_diff_category_dialog.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/product_screen.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/build_basic_data_table.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/define_type_function.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/config/app_enums.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_viewmodel.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  LoadingDataController loadingDataController =
      Get.find<LoadingDataController>();
  TextEditingController searchController = TextEditingController();
  late final PosCategoryController posCategoryController;
  @override
  void initState() {
    super.initState();
    PosCategoryService.posCategoryDataServiceInstance = null;
    PosCategoryService.getInstance();
    posCategoryController = Get.put(
      PosCategoryController(),
      tag: 'categoryControllerMain',
    );
    categoriesData();
  }

  @override
  void dispose() {
    searchController.dispose();
    posCategoryController.searchResults.clear();
    super.dispose();
  }

  Future categoriesData() async {
    await posCategoryController.categoriesData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return IgnorePointer(
          ignoring: loadingDataController.isUpdate.value,
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor:  Get.find<ThemeController>().isDarkMode.value 
                  ? AppColor.darkModeBackgroundColor
                  : Color(0xFFDDDDDD),
              appBar: customAppBar(
                context: context,
                onDarkModeChanged: () {
                  // setState(() {});
                },
              ),
              body: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color:  Get.find<ThemeController>().isDarkMode.value 
                          ? AppColor.darkModeBackgroundColor
                          : null,
                      gradient:  Get.find<ThemeController>().isDarkMode.value 
                          ? null
                          : LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [const Color(0xFFF0F9FF), Colors.white],
                            ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.setHeight(16),
                        horizontal: context.setWidth(20.5),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: context.setHeight(10),
                            right: context.setWidth(-170),
                            child: SvgPicture.asset(
                              AppImages.imageBackground,
                              package: 'shared_widgets',
                            ),
                          ),
                          GetBuilder<PosCategoryController>(
                            tag: 'categoryControllerMain',
                            builder: (controller) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: context.setHeight(16),
                                  left: context.setWidth(20.5),
                                  right: context.setWidth(20.5),
                                ),
                                child: Container(
                                  height: double.infinity,
                                  decoration: ShapeDecoration(
                                    color:  Get.find<ThemeController>().isDarkMode.value 
                                        ? Colors.black.withValues(alpha: 0.17)
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        color:  Get.find<ThemeController>().isDarkMode.value 
                                            ? Colors.white.withValues(alpha: 0.50)
                                            : Color(0x0C000000),
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        context.setMinSize(16),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: context.setHeight(11),
                                      horizontal: context.setWidth(23),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        spacing: context.setHeight(8),
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color:  Get.find<ThemeController>().isDarkMode.value 
                                                      ? const Color(0xFF3F3F3F)
                                                      : const Color(0xFFDADADA),
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                BackButton(
                                                  color:  Get.find<ThemeController>().isDarkMode.value 
                                                      ? Colors.white
                                                      : const Color(0xFF0C0C0C),
                                                ),
                                                Text(
                                                  'pos_category_list'.tr,
                                                  style: TextStyle(
                                                    color:  Get.find<ThemeController>().isDarkMode.value 
                                                        ? Colors.white
                                                        : const Color(0xFF0C0C0C),
                                                    fontSize: context.setSp(25),
                                                    fontFamily: 'Tajawal',
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.45,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                spacing: context.setWidth(11),
                                                children: [
                                                  ButtonClick(
                                                    data: 'add_new_pos_category'.tr,
                                                    onTap: () {
                                                      createEditeCategory(
                                                          context: context);
                                                    },
                                                    color: const Color(0xFF16A6B7),
                                                  ),
                                                  ButtonClick(
                                                    data: 'synchronization'.tr,
                                                    onTap: () async {
                                                      loadingDataController.isUpdate.value = true;
        
                                                      var result =
                                                          await synchronizeBasedOnModelType(
                                                        type: Loaddata.categories
                                                            .toString(),
                                                      );
        
                                                      if (result == true) {
                                                        appSnackBar(
                                                          message:
                                                              'synchronized'.tr,
                                                          messageType:
                                                              MessageTypes.success,
                                                          isDismissible: false,
                                                        );
                                                      } else if (result is String) {
                                                        appSnackBar(
                                                          message: result,
                                                          messageType: MessageTypes
                                                              .connectivityOff,
                                                        );
                                                      } else if (result == null) {
                                                        appSnackBar(
                                                          message:
                                                              'synchronization_problem'
                                                                  .tr,
                                                          isDismissible: false,
                                                        );
                                                      } else {
                                                        appSnackBar(
                                                          message:
                                                              'synchronized_successfully'
                                                                  .tr,
                                                          messageType:
                                                              MessageTypes.success,
                                                          isDismissible: false,
                                                        );
                                                      }
        
                                                      loadingDataController.update([
                                                        'card_loading_data',
                                                      ]);
        
                                                      loadingDataController.isUpdate.value = false;
                                                    },
                                                    color: const Color(0xFFF2AC57),
                                                    isSync: true,
                                                  ),
                                                  ButtonClick(
                                                    data: "Update_All".tr,
                                                    onTap: () async {
                                                      var result =
                                                          await loadingDataController
                                                              .updateAll(
                                                        name: Loaddata.categories
                                                            .toString(),
                                                      );
                                                      if (result == true) {
                                                        appSnackBar(
                                                          message:
                                                              'update_success'.tr,
                                                          messageType:
                                                              MessageTypes.success,
                                                          isDismissible: false,
                                                        );
                                                      } else if (result is String) {
                                                        appSnackBar(
                                                          message: result,
                                                          messageType: MessageTypes
                                                              .connectivityOff,
                                                        );
                                                      } else {
                                                        appSnackBar(
                                                          message:
                                                              'update_Failed'.tr,
                                                          messageType:
                                                              MessageTypes.error,
                                                          isDismissible: false,
                                                        );
                                                      }
                                                      loadingDataController.update([
                                                        'card_loading_data',
                                                      ]);
                                                    },
                                                    textColor:  Get.find<ThemeController>().isDarkMode.value 
                                                        ? Colors.white
                                                        : const Color(0xFF0C0C0C),
                                                    color:  Get.find<ThemeController>().isDarkMode.value 
                                                        ? const Color(0xFF292929)
                                                        : const Color(0xFFD5D5D5),
                                                  ),
                                                  ButtonClick(
                                                    data: 'display'.tr,
                                                    onTap: () async {
                                                      var result =
                                                          await displayDataDiffBasedOnModelType(
                                                        type: Loaddata.categories
                                                            .toString(),
                                                      );
                                                      if (result is List &&
                                                          result.isNotEmpty) {
                                                        showDiffCategoriesDialog(
                                                          items: result,
                                                          context: context,
                                                        );
                                                      } else if (result is String) {
                                                        appSnackBar(
                                                          message: result,
                                                          messageType: MessageTypes
                                                              .connectivityOff,
                                                        );
                                                      } else {
                                                        appSnackBar(
                                                          message:
                                                              "empty_filter".tr,
                                                          messageType:
                                                              MessageTypes.success,
                                                        );
                                                      }
                                                    },
                                                    textColor:  Get.find<ThemeController>().isDarkMode.value 
                                                        ? Colors.white
                                                        : const Color(0xFF0C0C0C),
                                                    color:  Get.find<ThemeController>().isDarkMode.value 
                                                        ? const Color(0xFF292929)
                                                        : const Color(0xFFD5D5D5),
                                                  ),
                                                ],
                                              ),
                                              GetBuilder<LoadingDataController>(
                                                id: 'card_loading_data',
                                                builder: (controller) {
                                                  int remote = loadingDataController
                                                          .itemdata[
                                                      Loaddata.categories.name
                                                          .toString()]["remote"];
                                                  int local = loadingDataController
                                                          .itemdata[
                                                      Loaddata.categories.name
                                                          .toString()]["local"];
                                                  String syncData = (remote == 0
                                                      ? "0"
                                                      : local > remote
                                                          ? (remote /
                                                                  (local == 0
                                                                      ? 1
                                                                      : local) *
                                                                  100)
                                                              .toStringAsFixed(0)
                                                          : ((local / remote) * 100)
                                                              .toStringAsFixed(0));
                                                  return Row(
                                                    spacing:
                                                        context.setWidth(13.27),
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            context.setWidth(200),
                                                        height:
                                                            context.setHeight(7),
                                                        child:
                                                            LinearProgressIndicator(
                                                          value: double.parse(
                                                                  syncData) /
                                                              100,
                                                          minHeight: 8,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                            9999,
                                                          ),
                                                          backgroundColor:
                                                               Get.find<ThemeController>().isDarkMode.value 
                                                                  ? const Color(
                                                                      0x26F7F7F7,
                                                                    )
                                                                  : const Color(
                                                                      0x268B8B8B,
                                                                    ),
                                                          color:
                                                               Get.find<ThemeController>().isDarkMode.value 
                                                                  ? const Color(
                                                                      0xFF18BBCD,
                                                                    )
                                                                  : const Color(
                                                                      0xFF16A6B7,
                                                                    ),
                                                        ),
                                                      ),
                                                      Text(
                                                        '${'synchronization'.tr} $syncData %',
                                                        textAlign: TextAlign.right,
                                                        style: TextStyle(
                                                          color:
                                                               Get.find<ThemeController>().isDarkMode.value 
                                                                  ? Colors.white
                                                                  : const Color(
                                                                      0xFF0C0C0C,
                                                                    ),
                                                          fontSize:
                                                              context.setSp(15),
                                                          fontFamily: 'Tajawal',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 1.50,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          ContainerTextField(
                                            controller: searchController,
                                            labelText: "${'search'.tr} .....",
                                            hintText: "${'search'.tr} .....",
                                            keyboardType: TextInputType.text,
                                            width: context.screenWidth,
                                            height: context.setHeight(35),
                                            fontSize: context.setSp(14),
                                            contentPadding: EdgeInsets.fromLTRB(
                                              context.setWidth(9.36),
                                              context.setHeight(10.29),
                                              context.setWidth(7.86),
                                              context.setHeight(4.71),
                                            ),
                                            showLable: false,
                                            borderColor: ! Get.find<ThemeController>().isDarkMode.value 
                                                ? Color(0xFFC2C3CB)
                                                : null,
                                            fillColor: ! Get.find<ThemeController>().isDarkMode.value 
                                                ? Colors.white.withValues(
                                                    alpha: 0.43,
                                                  )
                                                : const Color(0xFF2B2B2B),
                                            hintcolor: ! Get.find<ThemeController>().isDarkMode.value 
                                                ? Color(0xFFC2C3CB)
                                                : const Color(0xFF9CA3AF),
                                            color: ! Get.find<ThemeController>().isDarkMode.value 
                                                ? Color(0xFFC2C3CB)
                                                : const Color(0xFFC2C3CB),
                                            isAddOrEdit: true,
                                            borderRadius: context.setMinSize(10),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: context.setWidth(9.96),
                                                vertical: context.setHeight(5.95),
                                              ),
                                              child: SvgPicture.asset(
                                                AppImages.search,
                                                package: 'shared_widgets',
                                              ),
                                            ),
                                            onChanged: (text) async {
                                              if (searchController.text == '') {
                                                posCategoryController.searchResults
                                                    .clear();
                                                posCategoryController.update();
                                              } else {
                                                posCategoryController.search(
                                                  searchController.text,
                                                );
                                              }
                                            },
                                          ),
                                          buildBasicDataColumnHeader(
                                            context: context,
                                            data: [
                                              {"name": "number", "flex": 1},
                                              {"name": "name", "flex": 2},
                                              {
                                                "name": "parent_category",
                                                "flex": 2
                                              },
                                              {"name": "actions", "flex": 1},
                                            ],
                                          ),
                                          buildCategoryBodyTable(
                                            context: context,
                                            data: searchController.text.isNotEmpty
                                                ? posCategoryController
                                                    .searchResults
                                                : posCategoryController
                                                    .posCategoryList,
                                          ),
        
                                          // GetBuilder<LoadingDataController>(
                                          //   id: "pagin",
                                          //   builder: (loadingDataController) {
                                          //     return PagnationWidget(
                                          //       pagesNumber:
                                          //           customerController
                                          //               .pagnationpagesNumber,
                                          //       totalItems:
                                          //           searchController.text != ''
                                          //               ? customerController
                                          //                   .searchResults
                                          //                   .length
                                          //               : customerController
                                          //                   .searchResults
                                          //                   .isNotEmpty
                                          //               ? customerController
                                          //                   .seachCustomerPagingList
                                          //                   .length
                                          //               : loadingDataController
                                          //                   .itemdata[Loaddata
                                          //                   .customers
                                          //                   .name
                                          //                   .toString()]["local"],
                                          //       itemsPerPage: 10,
                                          //       onPageChanged: (page) async {
                                          //         customerController.selectedPagnation =
                                          //             1;
                                          //         customerController
                                          //             .pagnationpagesNumber = page;
                                          //         await customerController
                                          //             .getAllCustomerLocal(
                                          //               paging: true,
                                          //               type: "",
                                          //               pageselecteed: page,
                                          //             );
                                          //       },
                                          //     );
                                          //   },
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(() {
                    if (loadingDataController.isUpdate.value) {
                      return const LoadingWidget();
                    } else {
                      return const SizedBox
                          .shrink(); // Return an empty widget when not loading
                    }
                  })
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
