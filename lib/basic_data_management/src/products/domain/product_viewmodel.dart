// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/account_tax/data/account_tax.dart';
import 'package:pos_shared_preferences/models/pos_categories_data/pos_category.dart';
import 'package:pos_shared_preferences/models/product_data/product.dart';
import 'package:pos_shared_preferences/models/product_data/product_more_details.dart';
import 'package:pos_shared_preferences/models/product_unit/data/product_unit.dart';
import 'package:shared_widgets/config/app_enums.dart';
import 'package:shared_widgets/config/app_odoo_models.dart';
import 'package:shared_widgets/utils/mac_address_helper.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/account_tax/domain/account_tax_service.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/product_unit/domain/product_unit_service.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/domain/product_service.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/config/app_enums.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_service.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_viewmodel.dart';
import '../../item_history/domain/item_history_viewmodel.dart';
import '../../pos_categories/domain/pos_category_service.dart';

class ProductController extends GetxController {
  
  ProductService productService = ProductService.getInstance();
  final ItemHistoryController _itemHistoryController = ItemHistoryController();
  
  LoadingSynchronizingDataService loadingSynchronizingDataService =
      LoadingSynchronizingDataService(type: Product);
  LoadingDataController loadingDataController =  Get.find<LoadingDataController>();
  var isLoading = false.obs;
  var hideMainScreen = false.obs;
  RxList<Product> productList = <Product>[].obs;
  RxList<Product> pagingList = <Product>[].obs;
  RxList<Product> seachFilterPagingList = <Product>[].obs;
  List<PosCategory> categoriesList = [];
  List<AccountTax> taxesList = [];
  List categoriesCheckFiltter = [];
  List<ProductUnit> unitsList = [];
  List<AccountTax> taxList = [];
  RxList<Product> searchResults = RxList<Product>();
  RxList<Product> filtterResults = RxList<Product>();
  RxBool isHaveCheck = false.obs;
  RxBool isEmptylist = false.obs;
  Product? object;

  var page = 0.obs;
  int limit = Platform.isWindows ? 18 : 10;
  var hasMore = true.obs;
  var hasLess = false.obs;
  TextEditingController searchProductController = TextEditingController();
  //==================for Pagnation  item================
  int selectedPagnation = 0;
  int skip = 0;
  int pagnationpagesNumber = 0;
  //==================for Pagnation  item================
  final Rx<PagesViewMode> productsViewMode = PagesViewMode.list.obs;
  RxBool showProductOptionsInfo = false.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    await productsData();

    await categoriesData();

    await getAccountTaxData();
    await _unitsData();
  }

// # ===================================================== [ PRODUCTS DATA ] =====================================================
  // # Functionality:
  // # - The function fetches a list of products with pagination.
  // # - It calls the `displayProductList()` method with the `paging: true` argument, indicating that the data should be fetched with pagination.
  // # - Once the data is fetched, it assigns the results to both `productList` and `pagingList` variables.
  // # - After assigning the data, it calls the `update()` method to notify the UI and trigger a re-render.
  // # Input:
  // # - None, but it internally calls the `displayProductList()` method to get the product list.
  // # Returns:
  // # - This function does not return anything. It updates the `productList` and `pagingList` with the fetched data and triggers a UI update.

  productsData() async {
    var result = await displayProductList(paging: true , pageselecteed: 0 , type: "");
    productList.value = result.data;
    pagingList.value = result.data;
    update();
  }
// # ===================================================== [ PRODUCTS DATA ] =====================================================

// # ===================================================== [ CATEGORIES DATA ] =====================================================
  // # Functionality:
  // # - The function fetches a list of categories.
  // # - It starts by resetting the `PosCategoryService` instance.
  // # - A new instance of `PosCategoryService` is created and used to call the `index()` method to fetch the categories.
  // # - The fetched categories are stored in `categoriesList`, and a corresponding list `categoriesCheckFiltter` is created to hold check status for each category.
  // # - Finally, the `update()` method is called to notify the UI and trigger a re-render to reflect the changes.
  // # Input:
  // # - None, but it interacts with the `PosCategoryService` to fetch the category list.
  // # Returns:
  // # - This function does not return anything. It updates the `categoriesList` and `categoriesCheckFiltter` variables and triggers a UI update.

  categoriesData() async {
    PosCategoryService.posCategoryDataServiceInstance = null;
    PosCategoryService posCategoryService = PosCategoryService.getInstance();
    dynamic result = await posCategoryService.index();
    categoriesList = result;
    categoriesCheckFiltter = List.generate(categoriesList.length,
        (index) => {"id": categoriesList[index].id, "is_check": false});

    update();
  }
// # ===================================================== [ CATEGORIES DATA ] =====================================================

// # ===================================================== [ UNITS DATA ] =====================================================
  // # Functionality:
  // # - The function fetches a list of product units.
  // # - It starts by resetting the `ProductUnitService` instance.
  // # - A new instance of `ProductUnitService` is created and used to call the `index()` method to fetch the product units.
  // # - The fetched units are stored in `unitsList`.
  // # - Finally, the `update()` method is called to notify the UI and trigger a re-render to reflect the changes.
  // # Input:
  // # - None, but it interacts with the `ProductUnitService` to fetch the product unit list.
  // # Returns:
  // # - This function does not return anything. It updates the `unitsList` variable and triggers a UI update.

  _unitsData() async {
    ProductUnitService.productUnitDataServiceInstance = null;
    ProductUnitService productUnitService = ProductUnitService.getInstance();
    dynamic result = await productUnitService.index();
    unitsList = result;
    update();
  }
// # ===================================================== [ UNITS DATA ] =====================================================

// # ===================================================== [ DISPOSE CATEGORIES CHECK FILTER ] =====================================================
  // # Functionality:
  // # - This function resets the `categoriesCheckFiltter` list, which holds the state of checkboxes for each category.
  // # - It uses `List.generate()` to generate a new list with the same length as `categoriesList`, where each entry is a map with:
  // #     - "id": the category ID from `categoriesList`.
  // #     - "is_check": a boolean value initialized to `false`, indicating that no category is selected by default.
  // # - Finally, the `update()` method is called to notify the UI and trigger a re-render to reflect the changes.
  // # Input:
  // # - None, but it relies on `categoriesList` to generate `categoriesCheckFiltter`.
  // # Returns:
  // # - This function does not return anything. It updates the `categoriesCheckFiltter` variable and triggers a UI update.

  disposeCategoriesCheckFiltter() {
    categoriesCheckFiltter = List.generate(categoriesList.length,
        (index) => {"id": categoriesList[index].id, "is_check": false});
    update();
  }
// # ===================================================== [ DISPOSE CATEGORIES CHECK FILTER ] =====================================================

// # ===================================================== [ DISPLAY PRODUCT LIST WITH PAGINATION ] =====================================================
  // # Functionality:
  // # - This function fetches and displays a list of products. It supports pagination (prefix, suffix, and current) and filtering by search results.
  // # - It determines the data to be displayed based on:
  // #   1. If pagination is enabled (paging = true), it handles requests for previous, next, and current pages.
  // #   2. If search results are available, it displays them; otherwise, it fetches products from the service.
  // #   3. If no results are found, it returns an appropriate message.
  // # Input:
  // # - `paging`: A boolean flag to indicate whether pagination is enabled (default: false).
  // # - `type`: A string to define the pagination type ("current", "prefix", or "suffix", default: "current").
  // # - `pageselecteed`: The selected page index for pagination (default: -1).
  // # - `countSkip`: The number of records to skip (used for custom pagination offset).
  // # Output:
  // # - The result of the product data fetch, either a list of products or an error message.

  Future<dynamic> displayProductList({bool paging = false,
      String type = "current",
      int pageselecteed = -1,
      int? countSkip,
      bool skipOffset = false
      }) async {
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
            : loadingDataController
                        .itemdata[Loaddata.products.name.toString()] !=
                    null
                ? loadingDataController
                    .itemdata[Loaddata.products.name.toString()]['local']
                : 1;
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
        if(skipOffset){
          result = searchFiltterResult.isNotEmpty
            ? searchFiltterResult
                .take((page.value==0?1 :page.value) * limit)
                .toList()
            : await productService.index(offset: 0, limit: (page.value==0?1 :page.value) * limit);
        }
        else{
          result = searchFiltterResult.isNotEmpty
            ? searchFiltterResult
                .skip(countSkip ?? page.value * limit)
                .take(limit)
                .toList()
            : await productService.index(
                offset: countSkip ?? page.value * limit, limit: limit);
        }
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
    print("result=======${hasMore.value}");
    return result;
  }
// # ===================================================== [ DISPLAY PRODUCT LIST WITH PAGINATION ] =====================================================

// # ===================================================== [ DISPLAY PRODUCT DETAILS BY ID ] =====================================================
  // # Functionality:
  // # - This function fetches the details of a specific product based on the provided product ID.
  // # - It uses the `productService.show` method to retrieve the data for the product.
  // # - If the result is a list (success), it wraps the data in a `ResponseResult` with a success status.
  // # - If the result is an error or invalid, it wraps the result in a `ResponseResult` with a failure message.
  // # Input:
  // # - `id`: The ID of the product for which details are requested.
  // # Output:
  // # - The result, wrapped in a `ResponseResult` object, indicating success or failure.

  Future<dynamic> displayProduct({required int id}) async {
    dynamic result = await productService.show(val: id);
    if (result is List) {
      result =
          ResponseResult(status: true, message: "Successful".tr, data: result);
    } else {
      result = ResponseResult(message: result);
    }
    return result;
  }
// # ===================================================== [ DISPLAY PRODUCT DETAILS BY ID ] =====================================================

//   # ===================================================== [ FETCH ADDITIONAL PRODUCT DETAILS ] =====================================================
  // # Functionality:
  // # - This function retrieves additional product information based on the provided product template ID.
  // # - If the result is a valid `ProductMoreDetails` object, the data is wrapped in a `ResponseResult` with a success status.
  // # - If the result is invalid or an error, the function wraps the error in a `ResponseResult` with a failure message.
  // # Input:
  // # - `id`: The product template ID for which additional information is requested.
  // # Output:
  // # - The result, wrapped in a `ResponseResult` object, indicating success or failure.

  Future<dynamic> getMoreProductInfo({required int id}) async {
    dynamic result =
        await productService.getMoreProductInfo(productTemplateId: id);
    if (result is ProductMoreDetails) {
      result =
          ResponseResult(status: true, message: "Successful".tr, data: result);
    } else {
      result = ResponseResult(message: result);
    }
    return result;
  }
//   # ===================================================== [ FETCH ADDITIONAL PRODUCT DETAILS ] =====================================================

// # ===================================================== [ CREATE PRODUCT ] =====================================================
  // # Functionality:
  // # - This function is responsible for creating a new product both locally and remotely, based on a given `Product` object.
  // # - It first checks the network connection to ensure it's available. If not, it returns a "no connection" message.
  // # - If the device is trusted (as checked by `MacAddressHelper.isTrustedDevice`), it proceeds to add the product remotely via `createProductRemotely`.
  // # - If the remote creation is successful (returns an ID), it updates the product details and item history.
  // # - It then creates the product locally and returns a `ResponseResult` with a success message and the product data.
  // # - If there are issues during any step, the function handles them and returns appropriate error messages.
  // # Input:
  // # - `product`: The `Product` object that needs to be created.
  // # - `isFromHistory`: A flag to determine if the creation is coming from history (default is `false`).
  // # Output:
  // # - A `ResponseResult` object indicating whether the product creation was successful or failed, with the respective data and message.

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
// # ===================================================== [ CREATE PRODUCT ] =====================================================

//   # ===================================================== [ UPDATE PRODUCT ] =====================================================
  // # Functionality:
  // # - This function is responsible for updating an existing product both remotely and locally, based on a given `Product` object.
  // # - It first checks if there is an internet connection. If no connection exists, it returns a "no connection" message.
  // # - If the device is trusted (as determined by `MacAddressHelper.isTrustedDevice`), it attempts to update the product remotely using `updateProductRemotely`.
  // # - If the remote update is successful, it updates the product locally using `productService.update`, and it also updates the product's item history.
  // # - It returns a `ResponseResult` with a success message and the updated product or an error message if the update fails.
  // # Input:
  // # - `product`: The `Product` object that needs to be updated.
  // # Output:
  // # - A `ResponseResult` object indicating whether the product update was successful or not, with the corresponding data and message.

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
//   # ===================================================== [ UPDATE PRODUCT ] =====================================================

//   # ===================================================== [ SEARCH PRODUCTS ] =====================================================
  // # Functionality:
  // # - This function is used to perform a search operation for products.
  // # - It first checks if `productList` is not empty to ensure that there are products to search through.
  // # - It clears any existing search results stored in `searchResults` before starting a new search.
  // # - If `filtterResults` contains data, it filters through `filtterResults` based on the `query` provided. It checks if the `productName`, `barcode`, or `defaultCode` contains the search query (case-insensitive).
  // # - If `filtterResults` is empty, it proceeds to perform a remote search using the `productService.search` method.
  // # - The results from the filtering or the remote search are added to `searchResults`.
  // # - The `update()` method is called to notify listeners about the updated state of `searchResults`.
  // # Input:
  // # - `query`: The search query string.
  // # Output:
  // # - Updates `searchResults` with the filtered or searched product data.

  // Future<void> search(String query) async {
  //   if (productList.isNotEmpty) {
  //     searchResults.clear();
  //     if (filtterResults.isNotEmpty) {
  //       var results = filtterResults.where((product) {
  //         final productName = product.getProductNameBasedOnLang.toLowerCase();
  //         final barcode = product.barcode.toString().toLowerCase();
  //         final defaultCode = product.defaultCode.toString().toLowerCase();
  //         return productName.contains(query.toLowerCase()) ||
  //             barcode.contains(query.toLowerCase()) ||
  //             defaultCode.contains(query.toLowerCase());
  //       }).toList();
  //       searchResults.addAll(results);

  //       update();
  //     } else {
  //       var result = await productService.search(query);
  //       if (result is List) {
  //         searchResults.addAll(result as List<Product>);
  //       }

  //       update();
  //     }
  //   }
  // }

    Future<void> search(String query) async {
    if (productList.isNotEmpty) {
      if (selectedPagnation == 1) {
        if (searchResults.isEmpty & filtterResults.isEmpty) {
          var results = pagingList.where((product) {
            final productName = product.getProductNameBasedOnLang.toLowerCase();
            final barcode = product.barcode.toString().toLowerCase();
            final defaultCode = product.defaultCode.toString().toLowerCase();
            return productName.contains(query.toLowerCase()) ||
                barcode.contains(query.toLowerCase()) ||
                defaultCode.contains(query.toLowerCase());
          }).toList();
          searchResults.clear();
          searchResults.addAll(results);
        } else {
          var results = seachFilterPagingList.where((product) {
            final productName = product.getProductNameBasedOnLang.toLowerCase();
            final barcode = product.barcode.toString().toLowerCase();
            final defaultCode = product.defaultCode.toString().toLowerCase();
            return productName.contains(query.toLowerCase()) ||
                barcode.contains(query.toLowerCase()) ||
                defaultCode.contains(query.toLowerCase());
          }).toList();
          searchResults.clear();
          searchResults.addAll(results);
        }
      }
      if (filtterResults.isNotEmpty) {
        var results = filtterResults.where((product) {
          final productName = product.getProductNameBasedOnLang.toLowerCase();
          final barcode = product.barcode.toString().toLowerCase();
          final defaultCode = product.defaultCode.toString().toLowerCase();
          return productName.contains(query.toLowerCase()) ||
              barcode.contains(query.toLowerCase()) ||
              defaultCode.contains(query.toLowerCase());
        }).toList();
        searchResults.clear();
        searchResults.addAll(results);

        update();
      } else {
        var result = await productService.search(query , pageSize: limit);
        if (result is List) {
          searchResults.clear();
          searchResults.addAll(result as List<Product>);
        }

        update();
      }
    }
    selectedPagnation = 0;
  }
//   # ===================================================== [ SEARCH PRODUCTS ] =====================================================

// # ===================================================== [ SEARCH PRODUCTS BY CATEGORY ] =====================================================
  // # Functionality:
  // # - This function is used to search products by category.
  // # - It checks if `productList` is not empty before starting the search operation.
  // # - It clears any existing search results (`searchResults`) and filtered results (`filtterResults`).
  // # - If `query` is a `List` (categories data), it processes the categories to identify those that are checked (`is_check` is true).
  // # - It extracts the category IDs of the checked categories and performs a search for products belonging to these categories by calling `productService.searchByCateg`.
  // # - If there are matching results, it adds them to `filtterResults`.
  // # - The `update()` method is called to notify listeners about the updated state of search results.
  // # Input:
  // # - `query`: The list of category data to filter by, each with an `id` and a `is_check` flag.
  // # - `page`: (optional) The page number for pagination.
  // # - `limit`: (optional) The limit for the number of results per page.
  // # Output:
  // # - Updates `filtterResults` with the products that match the selected categories.

  Future<void> searchByCateg({
    required var query,
    int? page,
    int? limit,
  }) async {
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
// # ===================================================== [ SEARCH PRODUCTS BY CATEGORY ] =====================================================

// # ===================================================== [ TOGGLE MAIN SCREEN VISIBILITY ] =====================================================
  // # Functionality:
  // # - This method is used to update the visibility of the main screen by toggling the `hideMainScreen` state.
  // # - It takes a boolean parameter `value`, which indicates whether the main screen should be hidden or not.
  // # - It updates the `hideMainScreen` observable value accordingly.
  // # - After updating the visibility state, the method calls `update()` to notify any listeners about the change.
  // # Input:
  // # - `value`: A boolean flag indicating whether the main screen should be hidden (`true`) or shown (`false`).
  // # Output:
  // # - Updates the visibility of the main screen and triggers the update to notify UI listeners.

  updateHideMenu(bool value) {
    hideMainScreen.value = value;
    update();
  }
// # ===================================================== [ TOGGLE MAIN SCREEN VISIBILITY ] =====================================================

//   # ===================================================== [ RESET PAGING LIST ] =====================================================
  // # Functionality:
  // # - This method resets the current page to the first page (`page.value = 0`) and loads the products list again based on the selected page (`selectedpag`).
  // # - It calls `displayProductList()` with `paging` set to `true`, `type` as an empty string, and the selected page passed as `pageselecteed`.
  // # - This is useful when you need to reset the list to the first page and refresh the product data after some change or filter.
  // # Input:
  // # - `selectedpag`: The page number to be selected after resetting.
  // # Output:
  // # - Resets the page to `0` and reloads the product list based on the selected page.

  resetPagingList({required int selectedpag , bool skipOffset = false}) async {
    page.value = 0;
    await displayProductList(
        paging: true, type: "", pageselecteed: selectedpag , skipOffset: skipOffset);
  }

// # ===================================================== [ ACCOUNT TAX DATA ] =====================================================
  // # Functionality:
  // # - This function fetches a list of account taxes from the server.
  // # - It starts by resetting the singleton instance of `AccountTaxService` to ensure a fresh service state.
  // # - A new instance of `AccountTaxService` is then created using its `getInstance()` method.
  // # - The `index()` method of the service is called to retrieve the list of taxes.
  // # - The result is assigned to the `taxesList` variable.
  // # - Finally, `update()` is called to notify the UI and trigger a re-render to reflect the updated data.
  // # Returns:
  // # - This function does not return a value. It updates the `taxesList` and refreshes the UI via `update()`.

  getAccountTaxData() async {
    AccountTaxService.accountTaxDataServiceInstance = null;
    AccountTaxService accountTaxDataService = AccountTaxService.getInstance();
    dynamic result = await accountTaxDataService.index();
    taxesList = result;
    update();
  }
// # ===================================================== [ ACCOUNT TAX DATA ] =====================================================
 


void toggleProductsViewMode() {
  productsViewMode.value = 
      productsViewMode.value == PagesViewMode.list 
          ? PagesViewMode.grid 
          : PagesViewMode.list;
}

  void toggleProductViewOptionsInfo()  {
    showProductOptionsInfo.value =  !showProductOptionsInfo.value;
  }

}
