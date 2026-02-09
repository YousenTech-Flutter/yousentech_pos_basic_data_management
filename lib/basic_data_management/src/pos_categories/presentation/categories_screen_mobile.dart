import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos_categories/presentation/create_edit_category_mobile.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos_categories/widgets/show_diff_category_dialog.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/product_screen.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/define_type_function.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/config/app_enums.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_viewmodel.dart';

class CategoriesScreenMobile extends StatefulWidget {
  const CategoriesScreenMobile({super.key});

  @override
  State<CategoriesScreenMobile> createState() => _CategoriesScreenMobileState();
}

class _CategoriesScreenMobileState extends State<CategoriesScreenMobile> {
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
            backgroundColor: Get.find<ThemeController>().isDarkMode.value
              ? AppColor.darkModeBackgroundColor
              :  const Color(0xFFE3E3E3),
              
            appBar: customAppBar(
              context: context,
              isMobile: true,
              onDarkModeChanged: () {},
            ),
            body: Padding(
              padding: EdgeInsets.only(
                top: context.setHeight(16),
                bottom: context.setHeight(5),
                right: context.setWidth(10),
                left: context.setWidth(10),
              ),
              child: Stack(
                children: [
                  Stack(
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
                          return SingleChildScrollView(
                            child: Column(
                              spacing: context.setHeight(10),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? const Color(0xFF3F3F3F)
                                            : const Color(0xFFDADADA),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: context.setMinSize(5),
                                    ),
                                    child: Text(
                                      'pos_category_list'.tr,
                                      style: TextStyle(
                                        color: Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? Colors.white
                                            : const Color(0xFF0C0C0C),
                                        fontSize: context.setSp(16),
                                        fontFamily: 'SansBold',
                                        fontWeight: FontWeight.w700,
                                        height: 1.45,
                                      ),
                                    ),
                                  ),
                                ),
                                GetBuilder<LoadingDataController>(
                                  id: 'card_loading_data',
                                  builder: (controller) {
                                    int remote = loadingDataController.itemdata[
                                            Loaddata.categories.name.toString()]
                                        ["remote"];
                                    int local = loadingDataController.itemdata[
                                            Loaddata.categories.name.toString()]
                                        ["local"];
                                    String syncData = (remote == 0
                                        ? "0"
                                        : local > remote
                                            ? (remote /
                                                    (local == 0 ? 1 : local) *
                                                    100)
                                                .toStringAsFixed(0)
                                            : ((local / remote) * 100)
                                                .toStringAsFixed(0));
                                    return Container(
                                      decoration: ShapeDecoration(
                                        color: Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? const Color(0xFF292929)
                                            : Colors.white
                                                .withValues(alpha: 0.84),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              context.setMinSize(8.46)),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            context.setMinSize(10)),
                                        child: Column(
                                          spacing: context.setHeight(10),
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${'synchronization'.tr} $syncData %',
                                                  style: TextStyle(
                                                    color: Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF0C0C0C,
                                                          ),
                                                    fontSize: context.setSp(12),
                                                    fontFamily: 'SansRegular',
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              height: context.setHeight(7),
                                              child: LinearProgressIndicator(
                                                value: double.parse(syncData) /
                                                    100,
                                                minHeight: 8,
                                                borderRadius:
                                                    BorderRadius.circular(9999),
                                                backgroundColor:
                                                    Get.find<ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? const Color(
                                                            0x26F7F7F7,
                                                          )
                                                        : const Color(
                                                            0x268B8B8B,
                                                          ),
                                                color:
                                                    Get.find<ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? AppColor.appColor
                                                        : AppColor.appColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Row(
                                  spacing: context.setWidth(8),
                                  children: [
                                    Expanded(
                                      child: ButtonClick(
                                        data: 'add_new_pos_category'.tr,
                                        fontSize: 12,
                                        horizontal: 10,
                                        onTap: () {
                                          Get.to(() =>
                                              CreateEditeCategoryMobile());
                                        },
                                        color: AppColor.appColor,
                                      ),
                                    ),
                                    Expanded(
                                      child: ButtonClick(
                                        data: 'synchronization'.tr,
                                        fontSize: 12,
                                        horizontal: 10,
                                        onTap: () async {
                                          loadingDataController.isUpdate.value =
                                              true;

                                          var result =
                                              await synchronizeBasedOnModelType(
                                            type:
                                                Loaddata.categories.toString(),
                                          );

                                          if (result == true) {
                                            appSnackBar(
                                              message: 'synchronized'.tr,
                                              messageType: MessageTypes.success,
                                              isDismissible: false,
                                            );
                                          } else if (result is String) {
                                            appSnackBar(
                                              message: result,
                                              messageType:
                                                  MessageTypes.connectivityOff,
                                            );
                                          } else if (result == null) {
                                            appSnackBar(
                                              message:
                                                  'synchronization_problem'.tr,
                                              isDismissible: false,
                                            );
                                          } else {
                                            appSnackBar(
                                              message:
                                                  'synchronized_successfully'
                                                      .tr,
                                              messageType: MessageTypes.success,
                                              isDismissible: false,
                                            );
                                          }

                                          loadingDataController.update([
                                            'card_loading_data',
                                          ]);

                                          loadingDataController.isUpdate.value =
                                              false;
                                        },
                                        color: const Color(0xFFF2AC57),
                                        isSync: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: ButtonClick(
                                        data: "Update_All".tr,
                                        fontSize: 12,
                                        horizontal: 10,
                                        onTap: () async {
                                          var result =
                                              await loadingDataController
                                                  .updateAll(
                                            name:
                                                Loaddata.categories.toString(),
                                          );
                                          if (result == true) {
                                            appSnackBar(
                                              message: 'update_success'.tr,
                                              messageType: MessageTypes.success,
                                              isDismissible: false,
                                            );
                                          } else if (result is String) {
                                            appSnackBar(
                                              message: result,
                                              messageType:
                                                  MessageTypes.connectivityOff,
                                            );
                                          } else {
                                            appSnackBar(
                                              message: 'update_Failed'.tr,
                                              messageType: MessageTypes.error,
                                              isDismissible: false,
                                            );
                                          }
                                          loadingDataController.update([
                                            'card_loading_data',
                                          ]);
                                        },
                                        textColor: Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? Colors.white
                                            : const Color(0xFF0C0C0C),
                                        color: Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? const Color(0xFF292929)
                                            : const Color(0xFFD5D5D5),
                                      ),
                                    ),
                                    Expanded(
                                      child: ButtonClick(
                                        data: 'difference'.tr,
                                        fontSize: 12,
                                        horizontal: 0,
                                        onTap: () async {
                                          var result =
                                              await displayDataDiffBasedOnModelType(
                                            type:
                                                Loaddata.categories.toString(),
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
                                              messageType:
                                                  MessageTypes.connectivityOff,
                                            );
                                          } else {
                                            appSnackBar(
                                              message: "empty_filter".tr,
                                              messageType: MessageTypes.success,
                                            );
                                          }
                                        },
                                        textColor: Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? Colors.white
                                            : const Color(0xFF0C0C0C),
                                        color: Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? const Color(0xFF292929)
                                            : const Color(0xFFD5D5D5),
                                      ),
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
                                  borderColor: !Get.find<ThemeController>()
                                          .isDarkMode
                                          .value
                                      ? Color(0xFFC2C3CB)
                                      : null,
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
                                      ? Color(0xFFC2C3CB)
                                      : const Color(0xFF9CA3AF),
                                  color: !Get.find<ThemeController>()
                                          .isDarkMode
                                          .value
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
                                Text(
                                  'categorys_list'.tr,
                                  style: TextStyle(
                                    color: Get.find<ThemeController>()
                                            .isDarkMode
                                            .value
                                        ? Colors.white
                                        : const Color(0xFF374151),
                                    fontSize: context.setSp(14.80),
                                    fontFamily: 'SansMedium',
                                    fontWeight: FontWeight.w500,
                                    height: 1.43,
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: (searchController.text.isNotEmpty
                                          ? posCategoryController.searchResults
                                          : posCategoryController
                                              .posCategoryList)
                                      .length,
                                  itemBuilder: (context, index) {
                                    var item = (searchController.text.isNotEmpty
                                        ? posCategoryController.searchResults
                                        : posCategoryController
                                            .posCategoryList)[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(() => CreateEditeCategoryMobile(
                                              objectToEdit: item,
                                            ));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: context.setHeight(10)),
                                        child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(
                                                context.setMinSize(7)),
                                            decoration: ShapeDecoration(
                                              color: Get.find<ThemeController>()
                                                      .isDarkMode
                                                      .value
                                                  ? const Color(0xFF353535)
                                                  : AppColor.white,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 1.06,
                                                  color: Get.find<
                                                              ThemeController>()
                                                          .isDarkMode
                                                          .value
                                                      ? const Color(0xFF353535)
                                                      : const Color(0xFFE8E8E8),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        context.setMinSize(10)),
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              spacing: context.setWidth(12.69),
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          context
                                                              .setMinSize(15)),
                                                  child: Container(
                                                    color: Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? const Color(
                                                            0xFF2A2A2A)
                                                        : Color(0xFFECEFF2),
                                                    width:
                                                        context.setWidth(50.75),
                                                    height:
                                                        context.setWidth(50.75),
                                                    child: Center(
                                                      child: SvgPicture.asset(
                                                        AppImages
                                                            .productEmptySvg,
                                                        package:
                                                            'shared_widgets',
                                                        color: Get.find<
                                                                    ThemeController>()
                                                                .isDarkMode
                                                                .value
                                                            ? null
                                                            : const Color(
                                                                0xFF666C6D),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    spacing:
                                                        context.setHeight(5),
                                                    children: [
                                                      Text(
                                                        item.getPosCategoryNameBasedOnLang,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Get.find<
                                                                      ThemeController>()
                                                                  .isDarkMode
                                                                  .value
                                                              ? AppColor.white
                                                              : AppColor.black,
                                                          fontFamily:
                                                              'SansMedium',
                                                          fontSize:
                                                              context.setSp(
                                                            12,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      Row(
                                                        spacing:
                                                            context.setWidth(8),
                                                        children: [
                                                          Text(
                                                            "${"parent_category".tr} :",
                                                            style: TextStyle(
                                                              color: const Color(
                                                                  0xFF6B7280),
                                                              fontSize: context
                                                                  .setSp(12),
                                                              fontFamily:
                                                                  'SansBold',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1.50,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              item.getPosParentCategoryNameBasedOnLang ??
                                                                  "-",
                                                              style: TextStyle(
                                                                overflow: TextOverflow
                                                              .ellipsis,
                                                                color: AppColor
                                                                    .appColor,
                                                                fontSize: context
                                                                    .setSp(12),
                                                                fontFamily:
                                                                    'SansBold',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                height: 1.50,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
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
        ),
      );
    });
  }
}
