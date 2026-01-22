// ignore_for_file: must_be_immutable, use_build_context_synchronousl

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/product_unit/data/product_unit.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_enums.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
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
  final scrollController = ScrollController();
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
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        fetch();
      }
    });
  }

  Future fetch() async {
    productController.selectedPagnation = 1;
    if(productController.hasMore.value){
      productController.pagnationpagesNumber++;
    }
    await productController.displayProductList(
      skipOffset: true,
      paging: true,
      type: "",
      pageselecteed: productController.pagnationpagesNumber,
    );
  }
  //   Future refresh() async {
  //   await productController.productsData();
  // }

  @override
  void dispose() {
    searchController.text = '';
    productController.disposeCategoriesCheckFiltter();
    productController.searchResults.clear();
    productController.filtterResults.clear();
    searchController.clear();
    Get.delete<ProductController>(tag: 'productControllerMain');
    scrollController.dispose();
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
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    spacing: context.setHeight(10),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color:
                                  Get.find<ThemeController>().isDarkMode.value
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
                              ButtonElevated(
                                text: 'categories_management'.tr,
                                height: context.setHeight(40),
                                width: context.setWidth(150),
                                borderRadius: context.setMinSize(9),
                                borderColor: AppColor.appColor,
                                textStyle: TextStyle(
                                  color: AppColor.appColor,
                                  fontSize: context.setSp(11),
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
                                  : ((local / remote) * 100)
                                      .toStringAsFixed(0));
                          return Container(
                            decoration: ShapeDecoration(
                              color:
                                  Get.find<ThemeController>().isDarkMode.value
                                      ? const Color(0xFF292929)
                                      : Colors.white.withValues(alpha: 0.84),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    context.setMinSize(8.46)),
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
                                      color: Get.find<ThemeController>()
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
                              color:
                                  Get.find<ThemeController>().isDarkMode.value
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
                              color:
                                  Get.find<ThemeController>().isDarkMode.value
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
                              color:
                                  !Get.find<ThemeController>().isDarkMode.value
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'products_list'.tr,
                            style: TextStyle(
                              color:
                                  Get.find<ThemeController>().isDarkMode.value
                                      ? Colors.white
                                      : const Color(0xFF374151),
                              fontSize: context.setSp(14.80),
                              fontFamily: 'SansMedium',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              productController.toggleProductsViewMode();
                            },
                            child: SvgPicture.asset(
                              AppImages.menueGrid,
                              package: 'shared_widgets',
                              color:
                                  Get.find<ThemeController>().isDarkMode.value
                                      ? Colors.white
                                      : null,
                              width: context.setWidth(23.26),
                              height: context.setHeight(23.26),
                            ),
                          )
                        ],
                      ),
                      Obx(() {
                        if (productController.productsViewMode.value ==
                            ProductsViewMode.list) {
                          return GetBuilder<LoadingDataController>(
                            id: "pagin",
                            builder: (controller) {
                              var result = productController
                                          .selectedPagnation ==
                                      1
                                  ? (productController.filtterResults.isEmpty &
                                          productController
                                              .searchResults.isEmpty)
                                      ? productController.pagingList
                                      : productController.seachFilterPagingList
                                  : productController.isHaveCheck.value &&
                                          searchController.text == ''
                                      ? productController.filtterResults
                                      : (productController.isHaveCheck.value ||
                                                  !productController
                                                      .isHaveCheck.value) &&
                                              searchController.text != ''
                                          ? productController.searchResults
                                          : (productController
                                                      .filtterResults.isEmpty &
                                                  productController
                                                      .searchResults.isEmpty)
                                              ? productController.pagingList
                                              : productController
                                                  .seachFilterPagingList;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: result.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < result.length) {
                                    var item = result[index];
                                    return Padding(
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
                                            shadows: [
                                              BoxShadow(
                                                color: Color(0x00000000),
                                                blurRadius: 10.57,
                                                offset: Offset(0, 4.23),
                                                spreadRadius: 0,
                                              )
                                            ],
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            spacing: context.setWidth(12.69),
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        context.setMinSize(15)),
                                                child: Container(
                                                  color: item.image == null ||
                                                          isSvg(item.image!
                                                              .toString())
                                                      ? Get.find<ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? const Color(
                                                              0xFF2A2A2A)
                                                          : Color(0xFFECEFF2)
                                                      : null,
                                                  width:
                                                      context.setWidth(50.75),
                                                  height:
                                                      context.setWidth(50.75),
                                                  child: item.image == null ||
                                                          isSvg(item.image!
                                                              .toString())
                                                      ? Center(
                                                          child:
                                                              SvgPicture.asset(
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
                                                        )
                                                      : Image.memory(
                                                          base64.decode(item
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
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  spacing: context.setHeight(5),
                                                  children: [
                                                    Text(
                                                      item.getProductNameBasedOnLang,
                                                      overflow:TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Get.find<
                                                                    ThemeController>()
                                                                .isDarkMode
                                                                .value
                                                            ? AppColor.white
                                                            : AppColor.black,
                                                        fontFamily: 'SansMedium',
                                                        fontSize: context.setSp(
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
                                                          '${item.unitPrice}',
                                                          style: TextStyle(
                                                            color:
                                                                AppColor.appColor,
                                                            fontSize:
                                                                context.setSp(14),
                                                            fontFamily:
                                                                'SansBold',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 1.50,
                                                          ),
                                                        ),
                                                        SvgPicture.asset(
                                                          AppImages.riyal,
                                                          color:
                                                              AppColor.appColor,
                                                          package:
                                                              'shared_widgets',
                                                          width: context
                                                              .setWidth(11.63),
                                                          height: context
                                                              .setHeight(10.57),
                                                        )
                                                      ],
                                                    ),
                                                    Text(
                                                      item.soPosCategName!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xFF6B7280),
                                                        fontSize:
                                                            context.setSp(12.69),
                                                        fontFamily: 'SansRegular',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.50,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                    );
                                  } else {
                                    return productController.hasMore.value && productController.isLoading.value
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: AppColor.appColor,
                                            ),
                                          )
                                        : Container();
                                  }
                                },
                              );
                            },
                          );
                        } else {
                          return GetBuilder<LoadingDataController>(
                              id: "pagin",
                              builder: (controller) {
                                var result = productController
                                            .selectedPagnation ==
                                        1
                                    ? (productController
                                                .filtterResults.isEmpty &
                                            productController
                                                .searchResults.isEmpty)
                                        ? productController.pagingList
                                        : productController
                                            .seachFilterPagingList
                                    : productController.isHaveCheck.value &&
                                            searchController.text == ''
                                        ? productController.filtterResults
                                        : (productController
                                                        .isHaveCheck.value ||
                                                    !productController
                                                        .isHaveCheck.value) &&
                                                searchController.text != ''
                                            ? productController.searchResults
                                            : (productController.filtterResults
                                                        .isEmpty &
                                                    productController
                                                        .searchResults.isEmpty)
                                                ? productController.pagingList
                                                : productController
                                                    .seachFilterPagingList;
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: context.setWidth(10),
                                    mainAxisSpacing: context.setHeight(10),
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: result.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index < result.length) {
                                      var item = result[index];
                                      return GestureDetector(
                                        onTap: () async {},
                                        child: Container(
                                          decoration: ShapeDecoration(
                                            color: Get.find<ThemeController>()
                                                    .isDarkMode
                                                    .value
                                                ? Colors.black
                                                    .withValues(alpha: 0.17)
                                                : Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 0.81,
                                                color: Colors.white
                                                    .withValues(alpha: 0.50),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                context.setMinSize(12.93),
                                              ),
                                            ),
                                            shadows: Get.find<ThemeController>()
                                                    .isDarkMode
                                                    .value
                                                ? null
                                                : [
                                                    BoxShadow(
                                                      color: Color(0x19000000),
                                                      blurRadius: 10,
                                                      offset: Offset(0, 4),
                                                      spreadRadius: 0,
                                                    ),
                                                  ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: context.setWidth(8),
                                              vertical: context.setHeight(8),
                                            ),
                                            child: Column(
                                              spacing: context.setHeight(10),
                                              children: [
                                                Container(
                                                  width: context.setWidth(175),
                                                  height:
                                                      context.setHeight(110),
                                                  decoration: ShapeDecoration(
                                                    image: DecorationImage(
                                                      image: item.image ==
                                                                  null ||
                                                              isSvg(item.image
                                                                  .toString())
                                                          ? AssetImage(
                                                              Get.find<ThemeController>()
                                                                      .isDarkMode
                                                                      .value
                                                                  ? AppImages
                                                                      .productEmptyDark
                                                                  : AppImages
                                                                      .productEmpty,
                                                              package:
                                                                  'shared_widgets',
                                                            )
                                                          : MemoryImage(
                                                              base64Decode(item
                                                                  .image
                                                                  .toString()),
                                                            ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        context
                                                            .setMinSize(9.70),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        top: 4,
                                                        right: SharedPr.lang ==
                                                                "ar"
                                                            ? 5
                                                            : null,
                                                        left: SharedPr.lang ==
                                                                "ar"
                                                            ? null
                                                            : 5,
                                                        child: Container(
                                                          height: context
                                                              .setHeight(25),
                                                          decoration:
                                                              ShapeDecoration(
                                                            color: const Color(
                                                                0xA016A6B7),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                context
                                                                    .setMinSize(
                                                                        99),
                                                              ),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal:
                                                                  context
                                                                      .setWidth(
                                                                          10),
                                                            ),
                                                            child: Row(
                                                              spacing: context
                                                                  .setWidth(5),
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "${item.unitPrice}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: context
                                                                        .setSp(
                                                                            12.43),
                                                                    fontFamily:
                                                                        'SansBold',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    height:
                                                                        1.56,
                                                                  ),
                                                                ),
                                                                SvgPicture
                                                                    .asset(
                                                                  AppImages
                                                                      .riyal,
                                                                  package:
                                                                      'shared_widgets',
                                                                  color: AppColor
                                                                      .white,
                                                                  width: context
                                                                      .setMinSize(
                                                                          15),
                                                                  height: context
                                                                      .setMinSize(
                                                                          15),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  item.getProductNameBasedOnLang,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? AppColor.white
                                                        : AppColor.black,
                                                    fontSize: context.setSp(12),
                                                    fontFamily: 'SansMedium',
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.43,
                                                  ),
                                                ),
                                                Text(
                                                  item.soPosCategName!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF6B7280),
                                                    fontSize:
                                                        context.setSp(12.69),
                                                    fontFamily: 'SansRegular',
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.50,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return productController.hasMore.value && productController.isLoading.value
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                color: AppColor.appColor,
                                              ),
                                            )
                                          : Container();
                                    }
                                  },
                                );
                              }); // Return an empty widget when not loading
                        }
                      }),
                    ],
                  ),
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
