// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_enum.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_no_data.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/mac_address_helper.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/config/app_list.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/domain/product_service.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/views/add_edit_product_screen.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/widget/show_product.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/widget/tital.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/utils/build_body_table.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/utils/filtter_product_categ.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/build_basic_data_table.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/define_type_function.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/config/app_enums.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/config/app_list.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_viewmodel.dart';
import 'package:yousentech_pos_loading_synchronizing_data/yousentech_pos_loading_synchronizing_data.dart';
import '../../domain/product_viewmodel.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // TextEditingController searchBarController = TextEditingController();
  late final ProductController productController;
  Color iconcolor = AppColor.greyWithOpcity;
  TextEditingController searchBarController = TextEditingController();
  TextEditingController pagnationController = TextEditingController();
  LoadingDataController loadingDataController =
      Get.find<LoadingDataController>();
  int selectedpag = 0;
  int skip = 0;
  int pagesNumber = 0;
  @override
  void initState() {
    super.initState();
    ProductService.productDataServiceInstance = null;
    ProductService.getInstance();
    productController =
        Get.put(ProductController(), tag: 'productControllerMain');
    // selectedpag = productController.page.value;
    selectedpag = 0;
    getPagingList();
  }

  @override
  void dispose() {
    searchBarController.text = '';
    // searchBarController.dispose();
    productController.disposeCategoriesCheckFiltter();
    productController.searchResults.clear();
    productController.filtterResults.clear();
    pagnationController.clear();
    Get.delete<ProductController>(tag: 'productControllerMain');
    super.dispose();
  }

  Future getPagingList() async {
    await productController.displayProductList(
      paging: true,
      type: "current",
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: loadingDataController.isUpdate.value,
      child: Container(
        color: AppColor.dashbordcolor,
        child: Stack(
          children: [
            GetBuilder<ProductController>(
                // id: "update_customer",
                tag: 'productControllerMain',
                builder: (controller) {
                  if (productController.hideMainScreen.value) {
                    searchBarController.text = '';
                    selectedpag = 0;
                  }
                  return !productController.hideMainScreen.value
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TitalWidget(
                                      title: 'product_list',
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 10.r, left: 20.r, right: 20.r),
                                      child: Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    bool trustedDevice =
                                                        await MacAddressHelper
                                                            .isTrustedDevice();
                                                    if (trustedDevice) {
                                                      productController
                                                          .updateHideMenu(true);
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 30.h,
                                                    width: 15.w,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.r)),
                                                      color: AppColor.white,
                                                      border: Border.all(
                                                          color: AppColor
                                                              .silverGray),
                                                    ),
                                                    child: Center(
                                                      child: SvgPicture.asset(
                                                        "assets/image/product_add.svg",
                                                        package:
                                                            'yousentech_pos_basic_data_management',
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        fit: BoxFit.fill,
                                                        width: 19.r,
                                                        height: 19.r,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.r,
                                                ),
                                                Expanded(
                                                  child: ContainerTextField(
                                                    controller:
                                                        searchBarController,
                                                    height: 30.h,
                                                    labelText: '',
                                                    hintText: 'search'.tr,
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
                                                        "assets/image/search_quick.svg",
                                                        package:
                                                            'yousentech_pos_basic_data_management',
                                                        width: 19.r,
                                                        height: 19.r,
                                                      ),
                                                    ),
                                                    suffixIcon:
                                                        searchBarController
                                                                .text.isNotEmpty
                                                            ? Builder(builder:
                                                                (iconContext) {
                                                                return SizedBox(
                                                                  width: 50.r,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            searchBarController.text =
                                                                                '';
                                                                            productController.searchResults.clear();
                                                                            productController.update();
                                                                            selectedpag =
                                                                                0;
                                                                            pagnationController.text =
                                                                                (1).toString();
                                                                            await productController.resetPagingList(selectedpag: selectedpag);
                                                                            filtterProductByCategory(
                                                                                context: iconContext,
                                                                                product: productController.productList,
                                                                                productController: productController);
                                                                          },
                                                                          child: Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: 5.r, vertical: 7.r),
                                                                              child: SvgPicture.asset(
                                                                                "assets/image/ep_filter.svg",
                                                                                package: 'yousentech_pos_basic_data_management',
                                                                                width: 19.r,
                                                                                height: 19.r,
                                                                              ))),
                                                                      InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            searchBarController.text =
                                                                                '';
                                                                            productController.searchResults.clear();
                                                                            productController.update();
                                                                            selectedpag =
                                                                                0;
                                                                            pagnationController.text =
                                                                                (1).toString();
                                                                            await productController.resetPagingList(selectedpag: selectedpag);
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.cancel_outlined,
                                                                            color:
                                                                                AppColor.red,
                                                                            size:
                                                                                15.r,
                                                                          )),
                                                                    ],
                                                                  ),
                                                                );
                                                              })
                                                            : Builder(builder:
                                                                (iconContext) {
                                                                return InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    searchBarController
                                                                        .text = '';
                                                                    productController
                                                                        .searchResults
                                                                        .clear();
                                                                    productController
                                                                        .update();
                                                                    selectedpag =
                                                                        0;
                                                                    pagnationController
                                                                            .text =
                                                                        (1).toString();
                                                                    await productController.resetPagingList(
                                                                        selectedpag:
                                                                            selectedpag);
                                                                    filtterProductByCategory(
                                                                        context:
                                                                            iconContext,
                                                                        product:
                                                                            productController
                                                                                .productList,
                                                                        productController:
                                                                            productController);
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            5.r,
                                                                        vertical:
                                                                            7.r),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      "assets/image/ep_filter.svg",
                                                                      package:
                                                                          'yousentech_pos_basic_data_management',
                                                                      width:
                                                                          19.r,
                                                                      height:
                                                                          19.r,
                                                                    ),
                                                                  ),
                                                                );
                                                              }),
                                                    onChanged: (text) async {
                                                      if (searchBarController
                                                              .text ==
                                                          '') {
                                                        productController
                                                            .searchResults
                                                            .clear();
                                                        productController
                                                            .update();
                                                        selectedpag = 0;
                                                        await productController
                                                            .resetPagingList(
                                                                selectedpag:
                                                                    selectedpag);
                                                      } else {
                                                        await productController
                                                            .search(
                                                                searchBarController
                                                                    .text);
                                                        productController
                                                            .page.value = 0;
                                                        selectedpag = 0;
                                                        await productController
                                                            .displayProductList(
                                                                paging: true,
                                                                type: "",
                                                                pageselecteed:
                                                                    selectedpag);
                                                      }
                                                      pagnationController.text =
                                                          (1).toString();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.r,
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    bool isTrustedDevice =
                                                        await MacAddressHelper
                                                            .isTrustedDevice();
                                                    if (isTrustedDevice) {
                                                      var e = loaddata.entries
                                                          .firstWhere(
                                                              (element) =>
                                                                  element.key ==
                                                                  Loaddata
                                                                      .products);
                                                      var result =
                                                          await loadingDataController
                                                              .updateAll(
                                                                  name: e.key
                                                                      .toString());

                                                      if (result == true) {
                                                        appSnackBar(
                                                            message:
                                                                'update_success'
                                                                    .tr,
                                                            messageType:
                                                                MessageTypes
                                                                    .success,
                                                            isDismissible:
                                                                false);
                                                      } else if (result
                                                          is String) {
                                                        appSnackBar(
                                                          message: result,
                                                          messageType: MessageTypes
                                                              .connectivityOff,
                                                        );
                                                      } else {
                                                        appSnackBar(
                                                            message:
                                                                'update_Failed'
                                                                    .tr,
                                                            messageType:
                                                                MessageTypes
                                                                    .error,
                                                            isDismissible:
                                                                false);
                                                      }

                                                      loadingDataController
                                                          .update([
                                                        'card_loading_data'
                                                      ]);
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 30.h,
                                                    width: 30.w,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.r)),
                                                      color: AppColor.white,
                                                      border: Border.all(
                                                          color: AppColor
                                                              .silverGray),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/image/refresh-circle.svg",
                                                          package:
                                                              'yousentech_pos_basic_data_management',
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          fit: BoxFit.fill,
                                                          width: 19.r,
                                                          height: 19.r,
                                                        ),
                                                        Text(
                                                          "Update_All".tr,
                                                          style: TextStyle(
                                                              fontSize: 10.r,
                                                              color: AppColor
                                                                  .black
                                                                  .withOpacity(
                                                                      0.4)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.r,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    var e = loaddata.entries
                                                        .firstWhere((element) =>
                                                            element.key ==
                                                            Loaddata.products);

                                                    var result =
                                                        await displayDataDiffBasedOnModelType(
                                                            type: e.key
                                                                .toString());
                                                    if (result is List &&
                                                        result.isNotEmpty) {
                                                      showProductsDialog(
                                                          items: result);
                                                    } else if (result
                                                        is String) {
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
                                                              MessageTypes
                                                                  .success);
                                                    }

                                                    loadingDataController
                                                        .isUpdate.value = false;
                                                  },
                                                  child: Container(
                                                    height: 30.h,
                                                    width: 25.w,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.r)),
                                                      color: AppColor.white,
                                                      border: Border.all(
                                                          color: AppColor
                                                              .silverGray),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/image/list-left.svg",
                                                          package:
                                                              'yousentech_pos_basic_data_management',
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          fit: BoxFit.fill,
                                                          width: 19.r,
                                                          height: 19.r,
                                                        ),
                                                        Text(
                                                          "display".tr,
                                                          style: TextStyle(
                                                              fontSize: 10.r,
                                                              color: AppColor
                                                                  .black
                                                                  .withOpacity(
                                                                      0.4)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.r,
                                                ),
                                                Expanded(
                                                  child: GetBuilder<
                                                          LoadingDataController>(
                                                      id: "card_loading_data",
                                                      builder: (_) {
                                                        var localNumber = loadingDataController
                                                                .itemdata
                                                                .containsKey(Loaddata
                                                                    .products
                                                                    .name
                                                                    .toString())
                                                            ? loadingDataController
                                                                        .itemdata[
                                                                    Loaddata
                                                                        .products
                                                                        .name
                                                                        .toString()]
                                                                ['local']
                                                            : 0;
                                                        var remotNumber = loadingDataController
                                                                .itemdata
                                                                .containsKey(Loaddata
                                                                    .products
                                                                    .name
                                                                    .toString())
                                                            ? loadingDataController
                                                                        .itemdata[
                                                                    Loaddata
                                                                        .products
                                                                        .name
                                                                        .toString()]
                                                                ['remote']
                                                            : 0;
                                                        // var localNumber= 70;
                                                        // var remotNumber =50;
                                                        var per = (remotNumber >
                                                                localNumber)
                                                            ? (localNumber /
                                                                    (remotNumber ==
                                                                            0
                                                                        ? 1
                                                                        : remotNumber)) *
                                                                100
                                                            : (remotNumber /
                                                                    (localNumber ==
                                                                            0
                                                                        ? 1
                                                                        : localNumber)) *
                                                                100;
                                                        return InkWell(
                                                          onTap: () async {
                                                            loadingDataController
                                                                .isUpdate
                                                                .value = true;

                                                            var e = loaddata
                                                                .entries
                                                                .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .key ==
                                                                        Loaddata
                                                                            .products);
                                                            var result =
                                                                await synchronizeBasedOnModelType(
                                                                    type: e.key
                                                                        .toString());
                                                            await productController
                                                                .displayProductList(
                                                                    paging:
                                                                        true,
                                                                    type: "",
                                                                    pageselecteed:
                                                                        selectedpag);

                                                            if (result ==
                                                                true) {
                                                              appSnackBar(
                                                                  message:
                                                                      'synchronized'
                                                                          .tr,
                                                                  messageType:
                                                                      MessageTypes
                                                                          .success,
                                                                  isDismissible:
                                                                      false);
                                                            } else if (result
                                                                is String) {
                                                              appSnackBar(
                                                                message: result,
                                                                messageType:
                                                                    MessageTypes
                                                                        .connectivityOff,
                                                              );
                                                            } else if (result ==
                                                                false) {
                                                              appSnackBar(
                                                                  message:
                                                                      'synchronized_successfully'
                                                                          .tr,
                                                                  messageType:
                                                                      MessageTypes
                                                                          .success,
                                                                  isDismissible:
                                                                      false);
                                                            } else {
                                                              appSnackBar(
                                                                  message:
                                                                      'synchronization_problem'
                                                                          .tr,
                                                                  messageType:
                                                                      MessageTypes
                                                                          .success,
                                                                  isDismissible:
                                                                      false);
                                                            }
                                                            loadingDataController
                                                                .isUpdate
                                                                .value = false;
                                                            loadingDataController
                                                                .update([
                                                              'card_loading_data'
                                                            ]);
                                                            loadingDataController
                                                                .update([
                                                              'loading'
                                                            ]);
                                                          },
                                                          child: Container(
                                                            height: 30.h,
                                                            width: 35.w,
                                                            alignment: Alignment
                                                                .center,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.r),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5.r)),
                                                              color: AppColor
                                                                  .white,
                                                              border: Border.all(
                                                                  color: AppColor
                                                                      .silverGray),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Container(
                                                                  width: 17.r,
                                                                  height: 17.r,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: (per >
                                                                                100 ||
                                                                            per <
                                                                                100)
                                                                        ? AppColor
                                                                            .palePink
                                                                        : AppColor
                                                                            .lightGreen,
                                                                  ),
                                                                  child: Center(
                                                                    child: Icon(
                                                                      (per > 100 ||
                                                                              per <
                                                                                  100)
                                                                          ? Icons
                                                                              .sync_problem
                                                                          : Icons
                                                                              .check,
                                                                      color: (per > 100 ||
                                                                              per <
                                                                                  100)
                                                                          ? AppColor
                                                                              .crimsonRed
                                                                          : AppColor
                                                                              .emeraldGreen,
                                                                      size: Get
                                                                              .width *
                                                                          0.01,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10.r,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    color: (per >
                                                                                100 ||
                                                                            per <
                                                                                100)
                                                                        ? AppColor
                                                                            .palePink
                                                                        : AppColor
                                                                            .lightGreen,
                                                                    child:
                                                                        RichText(
                                                                      text:
                                                                          TextSpan(
                                                                        style: TextStyle(
                                                                            color: (per > 100 || per < 100)
                                                                                ? AppColor.crimsonRed
                                                                                : AppColor.emeraldGreen,
                                                                            fontFamily: 'Tajawal',package: 'yousentech_pos_basic_data_management'),
                                                                        children: <TextSpan>[
                                                                          TextSpan(
                                                                            text:
                                                                                '${'synchronization'.tr} : ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 10.r,
                                                                                fontFamily: 'Tajawal',package: 'yousentech_pos_basic_data_management'),
                                                                          ),
                                                                          // get the number
                                                                          TextSpan(
                                                                            text:
                                                                                '${per.toInt()} % ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 10.r,
                                                                                fontFamily: 'Tajawal',package: 'yousentech_pos_basic_data_management'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    /// test
                                    SizedBox(
                                      height: 10.r,
                                    ),
                                    GetBuilder<LoadingDataController>(
                                        id: "pagin",
                                        builder: (controller) {
                                          return searchBarController.text !=
                                                      "" &&
                                                  productController
                                                      .searchResults.isEmpty
                                              ? Expanded(
                                                  child: Center(
                                                      child: AppNoDataWidge(
                                                  message: "empty_filter".tr,
                                                )))
                                              : productController
                                                      .productList.isNotEmpty
                                                  ? Expanded(
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 20.r,
                                                            right: 20.r),
                                                        child: Column(
                                                          children: [
                                                            // Header
                                                            buildBasicDataColumnHeader(
                                                                data:
                                                                    productHeader,
                                                                color: AppColor
                                                                    .cyanTeal,
                                                                context:
                                                                    context),
                                                            SizedBox(
                                                              height: 2.r,
                                                            ),
                                                            // // body
                                                            // if (!productController
                                                            //     .isEmptylist.value) ...[
                                                            //   if (productController
                                                            //       .seachFilterPagingList
                                                            //       .isNotEmpty)
                                                            buildProductBodyTable(
                                                                productController:
                                                                    productController,
                                                                selectedpag:
                                                                    selectedpag,
                                                                startIndex: pagnationController
                                                                        .text
                                                                        .isEmpty
                                                                    ? null
                                                                    : int.parse(
                                                                        pagnationController
                                                                            .text)),
                                                            // ] else ...[
                                                            //   if (!productController
                                                            //           .isHaveCheck
                                                            //           .value &&
                                                            //       productController
                                                            //           .pagingList
                                                            //           .isNotEmpty)
                                                            //     buildProductBodyTable(
                                                            //         productController:
                                                            //             productController,
                                                            //         selectedpag:
                                                            //             selectedpag,
                                                            //         startIndex:
                                                            //             pagnationController
                                                            //                     .text
                                                            //                     .isEmpty
                                                            //                 ? null
                                                            //                 : int.parse(
                                                            //                     pagnationController
                                                            //                         .text))
                                                            // ],
                                                            // if (productController
                                                            //     .isEmptylist.value) ...[
                                                            //   Expanded(
                                                            //       child: Center(
                                                            //           child:
                                                            //               AppNoDataWidge(
                                                            //     message:
                                                            //         "empty_filter".tr,
                                                            //   )))
                                                            // ]
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Expanded(
                                                      child: Center(
                                                          child: AppNoDataWidge(
                                                      message:
                                                          "empty_filter".tr,
                                                    )));
                                        })

                                    /// test
                                  ],
                                ),
                              ),

                              // SizedBox(height: 10.r,),
                              GetBuilder<LoadingDataController>(
                                  id: "pagin",
                                  builder: (controller) {
                                    var dataResultLenght = productController
                                                    .isHaveCheck.value &&
                                                productController
                                                    .filtterResults.isEmpty ||
                                            (searchBarController.text != "" &&
                                                productController
                                                    .searchResults.isEmpty)
                                        ? 0
                                        : productController.filtterResults.isNotEmpty &&
                                                productController
                                                    .searchResults.isEmpty
                                            ? productController
                                                .filtterResults.length
                                            : productController
                                                    .searchResults.isNotEmpty
                                                ? productController
                                                    .searchResults.length
                                                : searchBarController.text != "" &&
                                                        productController
                                                            .searchResults
                                                            .isEmpty
                                                    ? 0
                                                    : loadingDataController.itemdata[
                                                        Loaddata.products.name
                                                            .toString()]['local'];
                                    pagesNumber = (dataResultLenght ~/
                                            productController.limit) +
                                        (dataResultLenght %
                                                    productController.limit !=
                                                0
                                            ? 1
                                            : 0);
                                    // print("pagesNumber $pagesNumber");
                                    // print(
                                    //     "pagnationController.text.isEmpty ${pagnationController.text.isEmpty}");
                                    int dataStart = pagnationController
                                            .text.isEmpty
                                        ? (productController.limit *
                                                (selectedpag + 1)) -
                                            (productController.limit - 1)
                                        : int.parse(pagnationController.text);
                                    pagnationController.text =
                                        dataStart.toString();
                                    // print("dataStart $dataStart");
                                    // print("pagesNumber $pagesNumber");
                                    var datadisplayLenght = (int.parse(
                                                    pagnationController.text) +
                                                productController.limit) <
                                            dataResultLenght
                                        ? ((int.parse(
                                                    pagnationController.text) +
                                                productController.limit) -
                                            1)
                                        : dataResultLenght;
                                    return dataResultLenght != 0
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: (Get.height * 0.2),
                                              height: 20.r,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColor.silverGray),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(5.r),
                                                child: Row(
                                                  // mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: dataStart > 1
                                                          ? () async {
                                                              if (dataStart <=
                                                                  productController
                                                                      .limit) {
                                                                await productController
                                                                    .displayProductList(
                                                                        paging:
                                                                            true,
                                                                        type:
                                                                            "prefix",
                                                                        countSkip:
                                                                            0);
                                                                selectedpag = 0;
                                                                pagnationController
                                                                    .text = "1";
                                                              } else {
                                                                await productController
                                                                    .displayProductList(
                                                                  paging: true,
                                                                  type:
                                                                      "prefix",
                                                                );
                                                                selectedpag--;
                                                                pagnationController
                                                                    .text = ((productController.limit *
                                                                            (selectedpag +
                                                                                1)) -
                                                                        (productController.limit -
                                                                            1))
                                                                    .toString();
                                                              }
                                                            }
                                                          : null,
                                                      child: SvgPicture.asset(
                                                        SharedPr.lang == "ar"
                                                            ? "assets/image/arrow_right.svg"
                                                            : "assets/image/arrow_left.svg",
                                                        package:
                                                            'yousentech_pos_basic_data_management',
                                                        color: dataStart <= 1
                                                            ? AppColor
                                                                .silverGray
                                                            : null,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    SizedBox(
                                                      height: 10.r,
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: <TextSpan>[
                                                            // Lenght data in DB
                                                            TextSpan(
                                                              text:
                                                                  "$dataResultLenght / ",
                                                              style: TextStyle(
                                                                  fontSize: 8.r,
                                                                  color: AppColor
                                                                      .lavenderGray,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      'Tajawal',package: 'yousentech_pos_basic_data_management'),
                                                            ),
                                                            // Lenght show in screen in
                                                            TextSpan(
                                                              text:
                                                                  "$datadisplayLenght -",
                                                              style: TextStyle(
                                                                  fontSize: 8.r,
                                                                  color: AppColor
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      'Tajawal',package: 'yousentech_pos_basic_data_management'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 10.r,
                                                        width: 40.r,
                                                        child: TextField(
                                                          readOnly:
                                                              Platform.isAndroid
                                                                  ? true
                                                                  : false,
                                                          style: TextStyle(
                                                            fontSize: 8.r,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            // fontWeight: FontWeight.bold
                                                          ),
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly, // Only digits allowed
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                            isDense:
                                                                true, // Reduces the padding inside the TextField
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                    vertical: 2
                                                                        .r), // Set padding to zero or adjust
                                                            border: InputBorder
                                                                .none, // Remove the border if not needed
                                                          ),
                                                          controller:
                                                              pagnationController,
                                                          onSubmitted:
                                                              (value) async {
                                                            int? countSkip;
                                                            if (value.isEmpty) {
                                                              pagnationController
                                                                      .text =
                                                                  (1).toString();
                                                              countSkip = 0;
                                                              selectedpag = 0;
                                                            } else if (value
                                                                .isNotEmpty) {
                                                              var pageselecteed = (int
                                                                          .parse(
                                                                              value) /
                                                                      productController
                                                                          .limit)
                                                                  .ceilToDouble();
                                                              selectedpag =
                                                                  pageselecteed
                                                                          .toInt() -
                                                                      1;
                                                              if (int.parse(
                                                                      value) >
                                                                  dataResultLenght) {
                                                                pagnationController
                                                                        .text =
                                                                    (1).toString();
                                                                countSkip = 0;
                                                                selectedpag = 0;
                                                              } else if (int.parse(
                                                                      value) <=
                                                                  1) {
                                                                pagnationController
                                                                        .text =
                                                                    (1).toString();
                                                                countSkip = 0;
                                                                selectedpag = 0;
                                                              } else {
                                                                countSkip =
                                                                    int.parse(
                                                                            value) -
                                                                        1;
                                                              }
                                                            }

                                                            productController
                                                                .update();
                                                            await productController
                                                                .displayProductList(
                                                                    paging:
                                                                        true,
                                                                    type: "",
                                                                    countSkip:
                                                                        countSkip,
                                                                    pageselecteed:
                                                                        selectedpag);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    //التالي
                                                    InkWell(
                                                      onTap: pagesNumber >
                                                              (selectedpag + 1)
                                                          ? () async {
                                                              int prefixData =
                                                                  int.parse(
                                                                      pagnationController
                                                                          .text);
                                                              skip = (prefixData +
                                                                  (productController
                                                                          .limit -
                                                                      1));
                                                              pagnationController
                                                                  .text = (skip +
                                                                      1)
                                                                  .toString();

                                                              await productController
                                                                  .displayProductList(
                                                                      paging:
                                                                          true,
                                                                      type:
                                                                          "suffix",
                                                                      // countSkip: pagnationController.text.isEmpty? null : (int.parse(pagnationController.text) )-1
                                                                      countSkip:
                                                                          skip);
                                                              selectedpag++;
                                                            }
                                                          : null,
                                                      child: SvgPicture.asset(
                                                        SharedPr.lang == "ar"
                                                            ? "assets/image/arrow_left.svg"
                                                            : "assets/image/arrow_right.svg",
                                                        package:
                                                            'yousentech_pos_basic_data_management',
                                                        color: pagesNumber >
                                                                (selectedpag +
                                                                    1)
                                                            ? null
                                                            : AppColor
                                                                .silverGray,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink();
                                  }),
                            ],
                          ),
                        )
                      // : Container();

                      /// test

                      : AddProductScreen(
                          objectToEdit: productController.object,
                        );
                }),
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
    );
  }
}
