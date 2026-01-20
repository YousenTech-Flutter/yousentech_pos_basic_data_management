// ignore_for_file: must_be_immutable, use_build_context_synchronousl

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_enums.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos_categories/presentation/categories_screen.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/domain/product_service.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/domain/product_viewmodel.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/create_edit_product.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/product_screen.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/utils/filter_product_by_category.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/widgets/show_diff_product_dialog.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/define_type_function.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/config/app_enums.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_viewmodel.dart';

class ProductScreenMobile extends StatefulWidget {
  const ProductScreenMobile({super.key});
  @override
  State<ProductScreenMobile> createState() => _ProductScreenMobileState();
}

class _ProductScreenMobileState extends State<ProductScreenMobile> {
  TextEditingController searchController = TextEditingController();
  LoadingDataController loadingDataController =
      Get.find<LoadingDataController>();
  late final ProductController productController;
  @override
  void initState() {
    super.initState();
    ProductService.productDataServiceInstance = null;
    ProductService.getInstance();
    productController = Get.put(
      ProductController(),
      tag: 'productControllerMain',
    );
    productController.selectedPagnation = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.disposeCategoriesCheckFiltter();
    });
  }

  @override
  void dispose() {
    searchController.text = '';
    productController.disposeCategoriesCheckFiltter();
    productController.searchResults.clear();
    productController.filtterResults.clear();
    searchController.clear();
    Get.delete<ProductController>(tag: 'productControllerMain');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: loadingDataController.isUpdate.value,
      child: Padding(
        padding: EdgeInsets.only(
          top: context.setHeight(16),
          bottom: context.setHeight(5),
          right: context.setWidth(10),
          left: context.setWidth(10),
        ),
        child: Stack(
          children: [
            GetBuilder<ProductController>(
              tag: 'productControllerMain',
              builder: (controller) {
                return Column(
                  spacing: context.setHeight(10),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Get.find<ThemeController>().isDarkMode.value
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'product_list'.tr,
                              style: TextStyle(
                                color:
                                    Get.find<ThemeController>().isDarkMode.value
                                        ? Colors.white
                                        : const Color(0xFF0C0C0C),
                                fontSize: context.setSp(16),
                                fontFamily: 'SansBold',
                                fontWeight: FontWeight.w700,
                                height: 1.45,
                              ),
                            ),
                            ButtonElevated(
                              text: 'إدارة الفئات'.tr,
                              height: context.setHeight(30),
                              width: context.setWidth(100),
                              borderRadius: context.setMinSize(9),
                              borderColor: AppColor.appColor,
                              textStyle: TextStyle(
                                color: AppColor.appColor,
                                fontSize: context.setSp(12),
                                fontFamily: 'SansMedium',
                                fontWeight: FontWeight.w400,
                              ),
                              onPressed: () {
                                Get.to(() => CategoriesScreen());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    GetBuilder<LoadingDataController>(
                      id: 'card_loading_data',
                      builder: (controller) {
                        int remote = loadingDataController
                                .itemdata[Loaddata.products.name.toString()]
                            ["remote"];
                        int local = loadingDataController
                                .itemdata[Loaddata.products.name.toString()]
                            ["local"];
                        String syncData = (remote == 0
                            ? "0"
                            : local > remote
                                ? (remote / (local == 0 ? 1 : local) * 100)
                                    .toStringAsFixed(0)
                                : ((local / remote) * 100).toStringAsFixed(0));
                        return Container(
                          decoration: ShapeDecoration(
                            color:Get.find<ThemeController>()
                                          .isDarkMode
                                          .value
                                      ? const Color(0xFF292929)
                                      :  Colors.white.withValues(alpha: 0.84),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(context.setMinSize(8.46) ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(context.setMinSize(10)),
                            child: Column(
                              spacing: context.setHeight(10),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${'synchronization'.tr} $syncData %',
                                      style: TextStyle(
                                        color: Get.find<ThemeController>()
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
                                    value: double.parse(syncData) / 100,
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(9999),
                                    backgroundColor: Get.find<ThemeController>()
                                            .isDarkMode
                                            .value
                                        ? const Color(
                                            0x26F7F7F7,
                                          )
                                        : const Color(
                                            0x268B8B8B,
                                          ),
                                    color: Get.find<ThemeController>()
                                            .isDarkMode
                                            .value
                                        ?AppColor.appColor
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
                            data: 'add_product'.tr,
                            fontSize: 12,
                            horizontal: 10,
                            onTap: () {
                              createEditeProduct(
                                context: context,
                              );
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
                              loadingDataController.isUpdate.value = true;
                              var result = await synchronizeBasedOnModelType(
                                type: Loaddata.products.toString(),
                              );

                              if (result == true) {
                                appSnackBar(
                                  message: 'synchronized'.tr,
                                  messageType: MessageTypes.success,
                                  isDismissible: false,
                                );
                              } else if (result == false) {
                                appSnackBar(
                                  message: 'synchronized_successfully'.tr,
                                  messageType: MessageTypes.success,
                                  isDismissible: false,
                                );
                              } else if (result is String) {
                                appSnackBar(
                                  message: result,
                                  messageType: MessageTypes.connectivityOff,
                                );
                              } else {
                                appSnackBar(
                                  message: 'synchronization_problem'.tr,
                                  isDismissible: false,
                                );
                              }
                              loadingDataController.isUpdate.value = false;
                              loadingDataController.update([
                                'card_loading_data',
                              ]);
                              loadingDataController.update([
                                'loading',
                              ]);
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
                                  await loadingDataController.updateAll(
                                name: Loaddata.products.toString(),
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
                                  messageType: MessageTypes.connectivityOff,
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
                            textColor:
                                Get.find<ThemeController>().isDarkMode.value
                                    ? Colors.white
                                    : const Color(0xFF0C0C0C),
                            color: Get.find<ThemeController>().isDarkMode.value
                                ? const Color(0xFF292929)
                                : const Color(0xFFD5D5D5),
                          ),
                        ),
                        Expanded(
                          child: ButtonClick(
                            data: 'display'.tr,
                            fontSize: 12,
                            horizontal: 0,
                            onTap: () async {
                              var result =
                                  await displayDataDiffBasedOnModelType(
                                type: Loaddata.products.toString(),
                              );
                              if (result is List && result.isNotEmpty) {
                                showDiffProductsDialog(
                                  items: result,
                                  context: context,
                                );
                              } else if (result is String) {
                                appSnackBar(
                                  message: result,
                                  messageType: MessageTypes.connectivityOff,
                                );
                              } else {
                                appSnackBar(
                                  message: "empty_filter".tr,
                                  messageType: MessageTypes.success,
                                );
                              }
                              loadingDataController.isUpdate.value = false;
                            },
                            textColor:
                                Get.find<ThemeController>().isDarkMode.value
                                    ? Colors.white
                                    : const Color(0xFF0C0C0C),
                            color: Get.find<ThemeController>().isDarkMode.value
                                ? const Color(0xFF292929)
                                : const Color(0xFFD5D5D5),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: context.setWidth(10),
                      children: [
                        Expanded(
                          child: ContainerTextField(
                            controller: searchController,
                            labelText: "${'search_product'.tr} .....",
                            hintText: "${'search_product'.tr} .....",
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
                            borderColor:
                                !Get.find<ThemeController>().isDarkMode.value
                                    ? Color(0xFFC2C3CB)
                                    : null,
                            fillColor:
                                !Get.find<ThemeController>().isDarkMode.value
                                    ? Colors.white.withValues(
                                        alpha: 0.43,
                                      )
                                    : const Color(0xFF2B2B2B),
                            hintcolor:
                                !Get.find<ThemeController>().isDarkMode.value
                                    ? Color(0xFFC2C3CB)
                                    : const Color(0xFF9CA3AF),
                            color: !Get.find<ThemeController>().isDarkMode.value
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
                                productController.searchResults.clear();
                                productController.update();
                                loadingDataController.update([
                                  "pagin",
                                ]);
                              } else {
                                await productController.search(
                                  searchController.text,
                                );
                              }
                              productController.pagnationpagesNumber = 0;
                            },
                          ),
                        ),
                        Builder(
                          builder: (iconContext) {
                            return InkWell(
                              onTap: () async {
                                searchController.text = '';
                                productController.searchResults.clear();
                                productController.update();
                                filtterProductByCategory(
                                  context: iconContext,
                                  productController: productController,
                                );
                              },
                              child: Container(
                                width: context.setWidth(52),
                                height: context.setHeight(35.5),
                                decoration: ShapeDecoration(
                                  color: Get.find<ThemeController>()
                                          .isDarkMode
                                          .value
                                      ? const Color(0xFF292929)
                                      : AppColor.white,
                                  shape: RoundedRectangleBorder(
                                    side: Get.find<ThemeController>()
                                            .isDarkMode
                                            .value
                                        ? BorderSide.none
                                        : BorderSide(
                                            width: 1,
                                            color: Color(0xFFC2C3CB),
                                          ),
                                    borderRadius: BorderRadius.circular(
                                      context.setMinSize(10),
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppImages.filter,
                                    package: 'shared_widgets',
                                    width: context.setWidth(20),
                                    height: context.setHeight(20),
                                    color: Get.find<ThemeController>()
                                            .isDarkMode
                                            .value
                                        ? null
                                        : const Color(
                                            0xFF686868,
                                          ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            Obx(() {
              if (loadingDataController.isUpdate.value) {
                return const LoadingWidget();
              } else {
                return const SizedBox
                    .shrink(); // Return an empty widget when not loading
              }
            }),
          ],
        ),
      ),
    );
  }
}
