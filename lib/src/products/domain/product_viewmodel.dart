// ignore_for_file: unrelated_type_equality_checks

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/pos_categories_data/pos_category.dart';
import 'package:pos_shared_preferences/models/product_data/product.dart';
import 'package:pos_shared_preferences/models/product_data/product_more_details.dart';
import 'package:pos_shared_preferences/models/product_unit/data/product_unit.dart';
import 'package:shared_widgets/config/app_odoo_models.dart';
import 'package:shared_widgets/utils/mac_address_helper.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:yousentech_pos_basic_data_management/src/product_unit/domain/product_unit_service.dart';
import 'package:yousentech_pos_basic_data_management/src/products/domain/product_service.dart';
import 'package:yousentech_pos_loading_synchronizing_data/config/app_enums.dart';
import 'package:yousentech_pos_loading_synchronizing_data/utils/fetch_date.dart';
import 'package:yousentech_pos_loading_synchronizing_data/yousentech_pos_loading_synchronizing_data.dart';
import '../../item_history/domain/item_history_viewmodel.dart';
import '../../pos_categories/domain/pos_category_service.dart';

class ProductController extends GetxController {
  ProductService productService = ProductService.getInstance();
  final ItemHistoryController _itemHistoryController = ItemHistoryController();

  LoadingSynchronizingDataService loadingSynchronizingDataService =
      LoadingSynchronizingDataService(type: Product);

  var isLoading = false.obs;
  var hideMainScreen = false.obs;
  RxList<Product> productList = <Product>[].obs;
  RxList<Product> pagingList = <Product>[].obs;
  RxList<Product> seachFilterPagingList = <Product>[].obs;
  List<PosCategory> categoriesList = [];
  // List<PosCategory> parantesCatog = [];
  List categoriesCheckFiltter = [];
  List<ProductUnit> unitsList = [];
  RxList<Product> searchResults = RxList<Product>();
  RxList<Product> filtterResults = RxList<Product>();
  // //===============================filter by touch screen Catogre=================================
  // RxList<Product> filtterProductByCatogre = RxList<Product>();
  // RxList<PosCategory> findChildrenItems= RxList<PosCategory>();
  // RxList<PosCategory> selectParantes= RxList<PosCategory>();
  // String selectedCategoryName= "";
  // final ScrollController productPagingController = ScrollController();
  // RxInt  pageProduct = 1.obs;
  // //===============================filter by touch screen Catogre=================================
  RxBool isHaveCheck = false.obs;
  RxBool isEmptylist = false.obs;
  Product? object;

  var page = 0.obs;
  final int limit = 16;
  var hasMore = true.obs;
  var hasLess = false.obs;
  TextEditingController searchProductController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    // print("onInit ==============start");
    // print("productsData ==============start");

    await productsData();

    await categoriesData();
    // productPagingController.addListener(() async{
    // if ( productPagingController.position.pixels == productPagingController.position.maxScrollExtent) {
    //       await selectedCategory(posCategory: parantesCatog.first, isCounting: true);
    // }
    // });
    // print("productsData ==============end");
    // print("categoriesData ==============start");

    // print("categoriesData ==============end");
    // print("_unitsData ==============start");

    await _unitsData();
    // print("onInit ==============end");
    //
    // print("onInit ==============end");
  }

  productsData() async {
    var result = await displayProductList(paging: true);
    productList.value = result.data;
    pagingList.value = result.data;
    update();
  }

  categoriesData() async {
    PosCategoryService.posCategoryDataServiceInstance = null;
    PosCategoryService posCategoryService = PosCategoryService.getInstance();
    dynamic result = await posCategoryService.index();
    categoriesList = result;
    // parantesCatog = categoriesList.where((item) => item.parentId == null).toList();
    categoriesCheckFiltter = List.generate(categoriesList.length,
        (index) => {"id": categoriesList[index].id, "is_check": false});
    // if (parantesCatog.isNotEmpty) {
    //   clearCategorySelected();
    //   await selectedCategory(posCategory: parantesCatog.first);
    // }

    update();
  }

  _unitsData() async {
    // print("_unitsData ==============start");
    ProductUnitService.productUnitDataServiceInstance = null;
    ProductUnitService productUnitService = ProductUnitService.getInstance();
    dynamic result = await productUnitService.index();
    // print("result ${result}");
    unitsList = result;
    update();
  }

  disposeCategoriesCheckFiltter() {
    categoriesCheckFiltter = List.generate(categoriesList.length,
        (index) => {"id": categoriesList[index].id, "is_check": false});
    update();
  }

  // ========================================== [ START DISPLAY PRODUCT LIST ] =============================================
  Future<dynamic> displayProductList(
      {bool paging = false,
      String type = "current",
      int pageselecteed = -1,
      int? countSkip}) async {
    // if (kDebugMode) {
    //   print('filtterResults LENGTH 11 : ${filtterResults.length}');
    //   print('searchResults LENGTH 22:=== ${searchResults.length}');
    // }
    RxList<Product> searchFiltterResult =
        filtterResults.isNotEmpty && searchResults.isEmpty
            ? filtterResults
            : searchResults.isNotEmpty
                ? searchResults
                : RxList<Product>();
    var dataResultLenght = filtterResults.isNotEmpty && searchResults.isEmpty
        ? filtterResults.length
        : searchResults.isNotEmpty
            ? searchResults.length
            // ignore: unnecessary_null_comparison
            : loadingDataController
                        .itemdata[Loaddata.products.name.toString()] !=
                    null
                ? loadingDataController
                    .itemdata[Loaddata.products.name.toString()]['local']
                : 1;
    // if (kDebugMode) {
    //   print('dataResultLenght LENGTH : $dataResultLenght');
    //   print('searchFiltterResult LENGTH :=== ${searchFiltterResult.length}');
    // }
    dynamic result;
    if (paging) {
      if (!isLoading.value) {
        isLoading.value = true;
        if (type == "suffix" && hasMore.value) {
          page.value++;
        } else if (type == "prefix" && hasLess.value) {
          page.value--;
        } else if (pageselecteed != -1) {
          page.value = pageselecteed;
        }
        // result = await productService.index(offset: page.value * limit, limit: limit);
        result = searchFiltterResult.isNotEmpty
            ? searchFiltterResult
                .skip(countSkip ?? page.value * limit)
                .take(limit)
                .toList()
            : await productService.index(
                offset: countSkip ?? page.value * limit, limit: limit);
        if (result is List) {
          if ((type == "suffix" && hasMore.value)) {
            if (result.length < limit) {
              hasMore.value = false;
            }
            hasLess.value = true;
          } else if (type == "prefix" && hasLess.value) {
            if (page == 0) {
              hasLess.value = false;
            }
            hasMore.value = true;
          } else if (type == "current") {
            if (result.length < limit) {
              hasMore.value = false;
            }
          } else if (pageselecteed != -1) {
            hasLess.value = true;
            hasMore.value = true;
            if (page == 0) {
              hasLess.value = false;
            } else if (page ==
                (dataResultLenght ~/ limit) +
                    (dataResultLenght % limit != 0 ? 1 : 0) -
                    1) {
              // print("hello");
              hasMore.value = false;
            }
          }

          ProductController productController =
              Get.find(tag: 'productControllerMain');
          productController.productList.addAll(result as List<Product>);
          if (searchFiltterResult.isNotEmpty) {
            seachFilterPagingList.clear();
            seachFilterPagingList.addAll(result);

            productController.update();
          } else {
            pagingList.clear();
            pagingList.addAll(result);
            productController.update();
          }
          result = ResponseResult(
              status: true, message: "Successful".tr, data: result);
        } else {
          result = ResponseResult(message: result);
        }
        isLoading.value = false;
      }
    } else {
      isLoading.value = true;
      result = await productService.index();
      if (result is List) {
        result = ResponseResult(
            status: true, message: "Successful".tr, data: result);
      } else {
        result = ResponseResult(message: result);
      }
      isLoading.value = false;
    }

    return result;
  }

  // ========================================== [ END DISPLAY PRODUCT LIST ] =============================================

  // ========================================== [ START DISPLAY PRODUCT ] =============================================
  Future<dynamic> displayProduct({required int id}) async {
    // isLoading.value = true;
    dynamic result = await productService.show(val: id);
    if (result is List) {
      result =
          ResponseResult(status: true, message: "Successful".tr, data: result);
    } else {
      result = ResponseResult(message: result);
    }
    // isLoading.value = false;
    return result;
  }

  // ========================================== [ END DISPLAY PRODUCT ] =============================================

  // ========================================== [ START GET PRODUCT INFO ] =============================================
  Future<dynamic> getMoreProductInfo({required int id}) async {
    // isLoading.value = true;
    dynamic result =
        await productService.getMoreProductInfo(productTemplateId: id);
    if (result is ProductMoreDetails) {
      result =
          ResponseResult(status: true, message: "Successful".tr, data: result);
    } else {
      result = ResponseResult(message: result);
    }
    // isLoading.value = false;
    return result;
  }

  // ========================================== [ END GET PRODUCT INFO ] =============================================

  // ========================================== [ START CREATE PRODUCT ] =============================================
  Future<dynamic> createProduct(
      {required Product product, bool isFromHistory = false}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      bool trustedDevice = await MacAddressHelper.isTrustedDevice();
      if (trustedDevice) {
        // Remotely Added
        var remoteResult = await productService.createProductRemotely(
            obj: product.remoteInsertWithSpecificMap());

        if (remoteResult is int) {
          product.id = product.productTmplId = remoteResult;
          // var res = await _itemHistoryController.getItemFromHistory(
          //     itemId: product.productId!, type: OdooModels.productTemplate);
          // await loadingSynchronizingDataService.updateItemHistory(itemHistory: [res.data]);
          var res = await _itemHistoryController
              .updateHistoryAndReturnProductId(productTemplateId: product.id!);
          product.productId = res.data;
          await productService.create(obj: product, isRemotelyAdded: true);
          return ResponseResult(
              status: true, data: product, message: "Successful".tr);
        } else {
          return ResponseResult(message: remoteResult);
        }
      }
    } else {
      return ResponseResult(message: "no_connection".tr);
    }
  }

// ========================================== [ END CREATE PRODUCT ] =============================================

// ========================================== [ START UPDATE PRODUCT ] =============================================
  Future<dynamic> updateProduct({required Product product}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!connectivityResult.contains(ConnectivityResult.none) &&
        product.id != null) {
      bool trustedDevice = await MacAddressHelper.isTrustedDevice();
      if (trustedDevice) {
        var remoteResult = await productService.updateProductRemotely(
            id: product.id!, obj: product.remoteInsertWithSpecificMap());
        if (remoteResult is! bool || remoteResult != true) {
          return ResponseResult(message: remoteResult.toString());
        } else {
          await productService.update(
              id: product.id!, obj: product, whereField: 'id');
          // await loadingSynchronizingDataService.updateItemHistory(itemHistory: [
          //   (await _itemHistoryController.getItemFromHistory(
          //           itemId: product.productId!,
          //           type: OdooModels.productTemplate))
          //       .data
          // ]);
          await loadingSynchronizingDataService.updateItemHistory(
              typeName: OdooModels.productTemplate, itemId: product.productId);
          return ResponseResult(
              status: true, data: product, message: "Successful".tr);
        }
        //
      }
    } else {
      return ResponseResult(message: "no_connection".tr);
    }
  }

// ========================================== [ END UPDATE PRODUCT ] =============================================

// ============================================ [ SEARCH PRODUCT ] ===============================================
  Future<void> search(String query) async {
    if (productList.isNotEmpty) {
      searchResults.clear();
      if (filtterResults.isNotEmpty) {
        var results = filtterResults.where((product) {
          final productName = product.getProductNameBasedOnLang.toLowerCase();
          final barcode = product.barcode.toString().toLowerCase();
          final defaultCode = product.defaultCode.toString().toLowerCase();
          return productName.contains(query.toLowerCase()) ||
              barcode.contains(query.toLowerCase()) ||
              defaultCode.contains(query.toLowerCase());
        }).toList();
        searchResults.addAll(results);

        update();
      } else {
        var result = await productService.search(query);
        if (result is List) {
          searchResults.addAll(result as List<Product>);
        }

        update();
      }
    }
  }

  Future<void> searchByCateg({
    required var query,
    int? page,
    int? limit,
  }) async {
    // if (query is int) {
    //   if(page == 0){
    //     filtterProductByCatogre.clear();
    //   }

    //   var result = await productService.searchByCateg(query: [query] , limit:limit, page:page );
    //   if (result is List) {
    //     print(" searchByCateg result ${result.length}");
    //     pageProduct++ ;
    //     filtterProductByCatogre.addAll(result as List<Product>);
    //   }
    // }
    // else
    if (productList.isNotEmpty) {
      searchResults.clear();
      filtterResults.clear();
      if (query is List) {
        List ids = query
            .where((catego) => catego['is_check'])
            .map((catego) => catego['id'] as int)
            .toList();
        if (ids.isNotEmpty) {
          isHaveCheck.value = true;
        } else {
          isHaveCheck.value = false;
        }
        var result = await productService.searchByCateg(query: ids);
        if (result is List) {
          filtterResults.addAll(result as List<Product>);
        }
      }
    }
    update();
  }

// ============================================ [ SEARCH PRODUCT ] ===============================================

  updateHideMenu(bool value) {
    hideMainScreen.value = value;
    // if (kDebugMode) {
    //   print('hideMainScreen.value : ${hideMainScreen.value}');
    // }
    update();
  }

  resetPagingList({required int selectedpag}) async {
    page.value = 0;
    await displayProductList(
        paging: true, type: "", pageselecteed: selectedpag);
  }

  // clearCategorySelected()async{
  //   findChildrenItems.clear();
  //   selectParantes.clear();
  //   pageProduct.value =0;
  //   if(parantesCatog.isNotEmpty){
  //     await selectedCategory(posCategory: parantesCatog.first);
  //   }

  //   update();
  // }

  // selectedCategory({required PosCategory posCategory , bool isCounting = false})async{
  //   isLoading.value = true;
  //   findChildrenItems.clear();

  //   selectParantes.addIf(!selectParantes.contains(posCategory),posCategory );
  //   if(!isCounting){
  //     pageProduct.value = 0;
  //   }

  //   selectedCategoryName = posCategory.getPosCategoryNameBasedOnLang;
  //   print("posCategory  id ${posCategory.id}");
  //   var item = categoriesList.where((x) => x.parentId == posCategory.id);
  //   findChildrenItems.addAll(item);
  //   await searchByCateg(query:posCategory.id , page:pageProduct.value,limit:40);
  //   isLoading.value = false;
  //   update();
  // }
  // backToselectedCategory({required int index})async{
  //   findChildrenItems.clear();
  //   int id = selectParantes[index].id!;
  //   pageProduct.value = 0;
  //   selectParantes.value = selectParantes.sublist(0,index+1);
  //   selectedCategoryName = selectParantes[index].getPosCategoryNameBasedOnLang;
  //   var item = categoriesList.where((x) => x.parentId == id);
  //   await searchByCateg(query:id, page:pageProduct.value,limit:40);
  //   findChildrenItems.addAll(item);
  //   update();
  // }
}
