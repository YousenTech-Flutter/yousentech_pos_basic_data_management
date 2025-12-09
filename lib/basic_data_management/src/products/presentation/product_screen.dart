// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_enums.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/presentation/views/customer_screen.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos_categories/presentation/categories_screen.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/domain/product_service.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/domain/product_viewmodel.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/create_edit_product.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/utils/build_product_body_table.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/utils/filter_product_by_category.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/widgets/show_diff_product_dialog.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/build_basic_data_table.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/define_type_function.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/config/app_enums.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_viewmodel.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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
        padding: EdgeInsets.symmetric(
          vertical: context.setHeight(16),
          horizontal: context.setWidth(20.5),
        ),
        child: Stack(
          children: [
            GetBuilder<ProductController>(
              tag: 'productControllerMain',
              builder: (controller) {
                return Container(
                  height: !Platform.isAndroid ? double.infinity : null,
                  decoration: ShapeDecoration(
                    color:
                        SharedPr.isDarkMode!
                            ? Colors.black.withValues(alpha: 0.17)
                            : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color:
                            SharedPr.isDarkMode!
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            spacing: context.setHeight(8),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color:
                                          SharedPr.isDarkMode!
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'product_list'.tr,
                                        style: TextStyle(
                                          color:
                                              SharedPr.isDarkMode!
                                                  ? Colors.white
                                                  : const Color(0xFF0C0C0C),
                                          fontSize: context.setSp(25),
                                          fontFamily: 'Tajawal',
                                          fontWeight: FontWeight.w700,
                                          height: 1.45,
                                        ),
                                      ),
                                      ButtonElevated(
                                        text: 'إدارة الفئات'.tr,
                                        width: context.setWidth(150),
                                        borderRadius: context.setMinSize(9),
                                        borderColor: const Color(0xFF16A6B7),
                                        textStyle: TextStyle(
                                          color: const Color(0xFF16A6B7),
                                          fontSize: context.setSp(13.27),
                                          fontFamily: 'Tajawal',
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
                    
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    spacing: context.setWidth(11),
                                    children: [
                                      ButtonClick(
                                        data: 'add_product'.tr,
                                        onTap: () {
                                          createEditeProduct(
                                            context: context,
                                          );
                                        },
                                        color: const Color(0xFF16A6B7),
                                      ),
                                      ButtonClick(
                                        data: 'synchronization'.tr,
                                        onTap: () async {
                                          loadingDataController
                                              .isUpdate
                                              .value = true;
                                          var result =
                                              await synchronizeBasedOnModelType(
                                                type:
                                                    Loaddata.products
                                                        .toString(),
                                              );
                    
                                          if (result == true) {
                                            appSnackBar(
                                              message: 'synchronized'.tr,
                                              messageType:
                                                  MessageTypes.success,
                                              isDismissible: false,
                                            );
                                          } else if (result == false) {
                                            appSnackBar(
                                              message:
                                                  'synchronized_successfully'
                                                      .tr,
                                              messageType:
                                                  MessageTypes.success,
                                              isDismissible: false,
                                            );
                                          } else if (result is String) {
                                            appSnackBar(
                                              message: result,
                                              messageType:
                                                  MessageTypes
                                                      .connectivityOff,
                                            );
                                          } else {
                                            appSnackBar(
                                              message:
                                                  'synchronization_problem'
                                                      .tr,
                                              isDismissible: false,
                                            );
                                          }
                                          loadingDataController
                                              .isUpdate
                                              .value = false;
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
                                      ButtonClick(
                                        data: "Update_All".tr,
                                        onTap: () async {
                                          var result =
                                              await loadingDataController
                                                  .updateAll(
                                                    name:
                                                        Loaddata.products
                                                            .toString(),
                                                  );
                                          if (result == true) {
                                            appSnackBar(
                                              message: 'update_success'.tr,
                                              messageType:
                                                  MessageTypes.success,
                                              isDismissible: false,
                                            );
                                          } else if (result is String) {
                                            appSnackBar(
                                              message: result,
                                              messageType:
                                                  MessageTypes
                                                      .connectivityOff,
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
                                            SharedPr.isDarkMode!
                                                ? Colors.white
                                                : const Color(0xFF0C0C0C),
                                        color:
                                            SharedPr.isDarkMode!
                                                ? const Color(0xFF292929)
                                                : const Color(0xFFD5D5D5),
                                      ),
                                      ButtonClick(
                                        data: 'display'.tr,
                                        onTap: () async {
                                          var result =
                                              await displayDataDiffBasedOnModelType(
                                                type:
                                                    Loaddata.products
                                                        .toString(),
                                              );
                                          if (result is List &&
                                              result.isNotEmpty) {
                                            showDiffProductsDialog(
                                              items: result,
                                              context: context,
                                            );
                                          } else if (result is String) {
                                            appSnackBar(
                                              message: result,
                                              messageType:
                                                  MessageTypes
                                                      .connectivityOff,
                                            );
                                          } else {
                                            appSnackBar(
                                              message: "empty_filter".tr,
                                              messageType:
                                                  MessageTypes.success,
                                            );
                                          }
                                          loadingDataController
                                              .isUpdate
                                              .value = false;
                                        },
                                        textColor:
                                            SharedPr.isDarkMode!
                                                ? Colors.white
                                                : const Color(0xFF0C0C0C),
                                        color:
                                            SharedPr.isDarkMode!
                                                ? const Color(0xFF292929)
                                                : const Color(0xFFD5D5D5),
                                      ),
                                    ],
                                  ),
                                  GetBuilder<LoadingDataController>(
                                    id: 'card_loading_data',
                                    builder: (controller) {
                                      int remote =
                                          loadingDataController
                                              .itemdata[Loaddata.products.name
                                              .toString()]["remote"];
                                      int local =
                                          loadingDataController
                                              .itemdata[Loaddata.products.name
                                              .toString()]["local"];
                                      String syncData =
                                          (remote == 0
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
                                        spacing: context.setWidth(13.27),
                                        children: [
                                          SizedBox(
                                            width: context.setWidth(200),
                                            height: context.setHeight(7),
                                            child: LinearProgressIndicator(
                                              value:
                                                  double.parse(syncData) /
                                                  100,
                                              minHeight: 8,
                                              borderRadius:
                                                  BorderRadius.circular(9999),
                                              backgroundColor:
                                                  SharedPr.isDarkMode!
                                                      ? const Color(
                                                        0x26F7F7F7,
                                                      )
                                                      : const Color(
                                                        0x268B8B8B,
                                                      ),
                                              color:
                                                  SharedPr.isDarkMode!
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
                                                  SharedPr.isDarkMode!
                                                      ? Colors.white
                                                      : const Color(
                                                        0xFF0C0C0C,
                                                      ),
                                              fontSize: context.setSp(15),
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.w500,
                                              height: 1.50,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                    
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: context.setWidth(16),
                                children: [
                                  Expanded(
                                    child: ContainerTextField(
                                      controller: searchController,
                                      labelText:
                                          "${'search_product'.tr} .....",
                                      hintText:
                                          "${'search_product'.tr} .....",
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
                                          !SharedPr.isDarkMode!
                                              ? Color(0xFFC2C3CB)
                                              : null,
                                      fillColor:
                                          !SharedPr.isDarkMode!
                                              ? Colors.white.withValues(
                                                alpha: 0.43,
                                              )
                                              : const Color(0xFF2B2B2B),
                                      hintcolor:
                                          !SharedPr.isDarkMode!
                                              ? Color(0xFFC2C3CB)
                                              : const Color(0xFF9CA3AF),
                                      color:
                                          !SharedPr.isDarkMode!
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
                                          productController.searchResults
                                              .clear();
                                          productController.update();
                                          loadingDataController.update([
                                            "pagin",
                                          ]);
                                        } else {
                                          await productController.search(
                                            searchController.text,
                                          );
                                        }
                                        productController
                                            .pagnationpagesNumber = 0;
                                      },
                                    ),
                                  ),
                    
                                  Builder(
                                    builder: (iconContext) {
                                      return InkWell(
                                        onTap: () async {
                                          searchController.text = '';
                                          productController.searchResults
                                              .clear();
                                          productController.update();
                                          filtterProductByCategory(
                                            context: iconContext,
                                            productController:
                                                productController,
                                          );
                                        },
                                        child: Container(
                                          width: context.setWidth(52),
                                          height: context.setHeight(35.5),
                                          decoration: ShapeDecoration(
                                            color:
                                                SharedPr.isDarkMode!
                                                    ? const Color(0xFF292929)
                                                    : const Color(0xFFF8F9FB),
                                            shape: RoundedRectangleBorder(
                                              side:
                                                  SharedPr.isDarkMode!
                                                      ? BorderSide.none
                                                      : BorderSide(
                                                        width: 1,
                                                        color: const Color(
                                                          0xFFF1F3F9,
                                                        ),
                                                      ),
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                              color:
                                                  SharedPr.isDarkMode!
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
                    
                              buildBasicDataColumnHeader(
                                context: context,
                                data: [
                                  {"name": "number", "flex": 1},
                                  {"name": "product_image", "flex": 1},
                                  {"name": "product_name", "flex": 2},
                                  {"name": "product_unit_price", "flex": 2},
                                  {"name": "unit", "flex": 1},
                                  {"name": "actions", "flex": 1},
                                ],
                              ),
                              GetBuilder<LoadingDataController>(
                                id: "pagin",
                                builder: (controller) {
                                  var result =
                                      productController.selectedPagnation == 1
                                          ? (productController
                                                      .filtterResults
                                                      .isEmpty &
                                                  productController
                                                      .searchResults
                                                      .isEmpty)
                                              ? productController.pagingList
                                              : productController
                                                  .seachFilterPagingList
                                          : productController
                                                  .isHaveCheck
                                                  .value &&
                                              searchController.text == ''
                                          ? productController.filtterResults
                                          : (productController
                                                      .isHaveCheck
                                                      .value ||
                                                  !productController
                                                      .isHaveCheck
                                                      .value) &&
                                              searchController.text != ''
                                          ? productController.searchResults
                                          : (productController
                                                  .filtterResults
                                                  .isEmpty &
                                              productController
                                                  .searchResults
                                                  .isEmpty)
                                          ? productController.pagingList
                                          : productController
                                              .seachFilterPagingList;
                                  return buildProductBodyTable(
                                    context: context,
                                    data: result,
                                  );
                                },
                              ),
                    
                              // if(!Platform.isAndroid)...[
                              //   SizedBox(height: context.setHeight(12),)
                              // ]
                              // ,
                            ],
                          ),
                        ),
                        GetBuilder<LoadingDataController>(
                          id: "pagin",
                          builder: (loadingDataController) {
                            int result =
                                productController.selectedPagnation == 1
                                    ? (productController
                                                .filtterResults
                                                .isEmpty &
                                            productController
                                                .searchResults
                                                .isEmpty)
                                        ? loadingDataController
                                            .itemdata[Loaddata.products.name
                                            .toString()]["local"]
                                        : productController
                                            .searchResults
                                            .isEmpty
                                        ? productController
                                            .filtterResults
                                            .length
                                        : productController
                                            .searchResults
                                            .length
                                    : productController.isHaveCheck.value &&
                                        searchController.text == ''
                                    ? productController.filtterResults.length
                                    : (productController.isHaveCheck.value ||
                                            !productController
                                                .isHaveCheck
                                                .value) &&
                                        searchController.text != ''
                                    ? productController.searchResults.length
                                    : (productController
                                            .filtterResults
                                            .isEmpty &
                                        productController
                                            .searchResults
                                            .isEmpty)
                                    ? loadingDataController.itemdata[Loaddata
                                        .products
                                        .name
                                        .toString()]["local"]
                                    : productController
                                        .seachFilterPagingList
                                        .length;
                            return PagnationWidget(
                              totalItems: result,
                              itemsPerPage: Platform.isWindows ? 18 : 10,
                              pagesNumber:
                                  productController.pagnationpagesNumber,
                              onPageChanged: (page) async {
                                productController.selectedPagnation = 1;
                                productController.pagnationpagesNumber = page;
                                await productController.displayProductList(
                                  paging: true,
                                  type: "",
                                  pageselecteed: page,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            Obx(() {
              if (loadingDataController.isUpdate.value) {
                return const LoadingWidget();
              } else {
                return const SizedBox.shrink(); // Return an empty widget when not loading
              }
            }),
          ],
        ),
      ),
    );
  }
}

class ButtonClick extends StatelessWidget {
  String data;
  Function()? onTap;
  Color? color;
  Color? textColor;
  bool isSync;
  ButtonClick({
    super.key,
    required this.data,
    required this.onTap,
    required this.color,
    this.isSync = false,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.63),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.setHeight(6),
            horizontal: context.setWidth(16),
          ),
          child: Center(
            child: Row(
              spacing: context.setWidth(6.63),
              children: [
                if (isSync) ...[
                  SvgPicture.asset(
                    AppImages.syncImage2,
                    package: 'shared_widgets',
                    width: context.setWidth(13.27),
                    height: context.setHeight(13.27),
                    color: Colors.white,
                  ),
                ],

                Text(
                  data,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: context.setSp(16),
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
