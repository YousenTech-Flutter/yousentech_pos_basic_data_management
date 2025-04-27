import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/pos_categories_data/pos_category.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_odoo_models.dart';
import 'package:shared_widgets/shared_widgets/handle_exception_helper.dart';
import 'package:shared_widgets/shared_widgets/odoo_connection_helper.dart';
import 'package:shared_widgets/utils/mac_address_helper.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/domain/product_viewmodel.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_service.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_viewmodel.dart';
import '../../item_history/domain/item_history_viewmodel.dart';
import 'pos_category_service.dart';

class PosCategoryController extends GetxController {
  late PosCategoryService posCategoryService = PosCategoryService.getInstance();
  final ItemHistoryController _itemHistoryController = ItemHistoryController();
  LoadingSynchronizingDataService loadingSynchronizingDataService =
      LoadingSynchronizingDataService(type: PosCategory);
  LoadingDataController loadingDataController =  Get.find<LoadingDataController>();
  var isLoading = false.obs;
  var hideMainScreen = false.obs;
  RxList<PosCategory> posCategoryList = <PosCategory>[].obs;
  RxList<PosCategory> searchResults = RxList<PosCategory>();
  PosCategory? object;

  @override
  Future<void> onInit() async {
    super.onInit();
    await categoriesData();
  }

  categoriesData() async {
    displayPosCategoryList().then((value) {
      posCategoryList.value = value.data;
      update();
    });
  }

// # ===================================================== [ DISPLAY POS CATEGORY LIST ] =====================================================
  // # Functionality:
  // # - Retrieves a list of POS categories.
  // # - If the result is a valid list, it wraps it in a `ResponseResult` with a success status and the data.
  // # - If the result is not a valid list, it wraps the result in a `ResponseResult` with an error message.
  // # Input:
  // # - None
  // # Raises:
  // # - None
  // # Returns:
  // # - A `ResponseResult` object containing the list of POS categories or an error message.
  Future<dynamic> displayPosCategoryList() async {
    isLoading.value = true;
    dynamic result = await posCategoryService.index();
    if (result is List) {
      result =
          ResponseResult(status: true, message: "Successful".tr, data: result);
    } else {
      result = ResponseResult(message: result);
    }
    isLoading.value = false;
    return result;
  }
// # ===================================================== [ DISPLAY POS CATEGORY LIST ] =====================================================



  

// # ===================================================== [ DISPLAY POS CATEGORY ] =====================================================
  // # Functionality:
  // # - Retrieves a specific POS category based on the given `id` using the `posCategoryService`.
  // # - If the result is a valid list, it wraps it in a `ResponseResult` with a success status and the data.
  // # - If the result is not a valid list, it wraps the result in a `ResponseResult` with an error message.
  // # Input:
  // # - `id`: The ID of the POS category to be retrieved.
  // # Raises:
  // # - None
  // # Returns:
  // # - A `ResponseResult` object containing the POS category data or an error message.
  Future<dynamic> displayPosCategory({required int id}) async {
    isLoading.value = true;
    dynamic result = await posCategoryService.show(val: id);
    if (result is List) {
      result =
          ResponseResult(status: true, message: "Successful".tr, data: result);
    } else {
      result = ResponseResult(message: result);
    }
    isLoading.value = false;
    return result;
  }
// # ===================================================== [ DISPLAY POS CATEGORY ] =====================================================





//   # ===================================================== [ CREATE POS CATEGORY ] =====================================================
  // # Functionality:
  // # - Checks the connectivity of the device.
  // # - If there is a network connection, checks if the device is trusted.
  // # - If the device is trusted, creates a POS category remotely.
  // # - After successfully adding the POS category remotely, connects the category to the POS.
  // # - Creates the POS category locally and updates the data.
  // # - If no network connection is available, returns an error message.
  // # Input:
  // # - `posCategory`: The POS category object to be created.
  // # - `isFromHistory`: Optional flag to specify if the operation is triggered from history (default is `false`).
  // # Raises:
  // # - None
  // # Returns:
  // # - A `ResponseResult` containing the POS category data or an error message.

  Future<dynamic> createPosCategory(
      {required PosCategory posCategory, bool isFromHistory = false}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      bool trustedDevice = await MacAddressHelper.isTrustedDevice();
      if (trustedDevice) {
        // Remotely Added
        var remoteResult = await posCategoryService.createPosCategoryRemotely(
            obj: posCategory.specificJsonToUpdate());
        if (remoteResult is int) {
          posCategory.id = remoteResult;
          List<int> ids = posCategoryList.map((e) => e.id!).toList();
          ids.add(posCategory.id!);
          var connectCategoryWithPos =
              await posCategoryService.connectCategoryWithPOS(ids: ids);

          if (connectCategoryWithPos is bool) {
            await posCategoryService.create(
                obj: posCategory, isRemotelyAdded: true);

            loadingDataController.posCategoryIdsList.add(posCategory.id!);
            await loadingDataController.getitems();
            await loadingSynchronizingDataService.updateItemHistory(
                typeName: OdooModels.posCategory, itemId: posCategory.id);
          }
          return ResponseResult(
              status: true, message: "Successful".tr, data: posCategory);
        } else {
          return ResponseResult(message: remoteResult);
        }
      }
    } else {
      return ResponseResult(message: "no_connection".tr);
    }
  }
//   # ===================================================== [ CREATE POS CATEGORY ] =====================================================





  
 // # ===================================================== [ UPDATE POS CATEGORY ] =====================================================
  // # Functionality:
  // # - Checks the connectivity of the device and ensures the POS category has a valid ID.
  // # - If the device is connected and the POS category is valid, checks if the device is trusted.
  // # - If the device is trusted, remotely updates the POS category.
  // # - If the remote update is successful, updates the POS category locally.
  // # - Clears the product list if the `ProductController` is registered and reloads the products.
  // # - Updates the item history with the new POS category data.
  // # - Returns a `ResponseResult` indicating success or failure.
  // # Input:
  // # - `posCategory`: The POS category object that needs to be updated.
  // # Raises:
  // # - None
  // # Returns:
  // # - A `ResponseResult` containing the updated POS category data or an error message.
  Future<dynamic> updatePosCategory({required PosCategory posCategory}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!connectivityResult.contains(ConnectivityResult.none) &&
        posCategory.id != null) {
      bool trustedDevice = await MacAddressHelper.isTrustedDevice();
      if (trustedDevice) {
        // Remotely Edit
        var remoteResult = await posCategoryService.updatePosCategoryRemotely(
            id: posCategory.id!, obj: posCategory.specificJsonToUpdate());
        if (remoteResult is! bool || remoteResult != true) {
          return ResponseResult(message: "error");
        } else {
          dynamic result = await posCategoryService.update(
              id: posCategory.id!, obj: posCategory, whereField: 'id');
          if (result is int) {
            // to reload the categories with new name
            bool productControllerRegistered =
                Get.isRegistered<ProductController>(
                    tag: 'productControllerMain');
            if (productControllerRegistered) {
              ProductController productController =
                  Get.find(tag: 'productControllerMain');
              productController.productList.clear();
              productController.onInit();
            }

            var res = await _itemHistoryController.getItemFromHistory(
                itemId: posCategory.id!, type: OdooModels.posCategory);
            await loadingSynchronizingDataService.updateItemHistory(
                typeName: OdooModels.posCategory, itemId: posCategory.id);
            result = ResponseResult(
                status: true, message: "Successful".tr, data: posCategory);
            hideMainScreen.value = true;
          } else {
            result = ResponseResult(message: "no_connection".tr);
          }
          return result;
        }
      }
    } else {
      return ResponseResult(message: "no_connection".tr);
    }
  }
  // # ===================================================== [ UPDATE POS CATEGORY ] =====================================================




  


 // # ===================================================== [ SEARCH POS CATEGORY ] =====================================================
  // # Functionality:
  // # - Clears the search results if there are existing items in the list.
  // # - Executes a search for POS categories using the provided query.
  // # - If search results are found, it adds them to the `searchResults` list.
  // # - Calls `update()` to notify the UI to refresh with the new search results.
  // # Input:
  // # - `query`: The search query string to find matching POS categories.
  // # Raises:
  // # - None
  // # Returns:
  // # - None

  Future<void> search(String query) async {
    if (posCategoryList.isNotEmpty) {
      searchResults.clear();
      var result = await posCategoryService.search(query);
      if (result is List) {
        searchResults.addAll(result as List<PosCategory>);
      }
      update();
    }
  }
 // # ===================================================== [ SEARCH POS CATEGORY ] =====================================================


  
// # ===================================================== [ UPDATE HIDE MENU ] =====================================================
  // # Functionality:
  // # - Sets the value of `hideMainScreen` to the provided boolean `value`.
  // # - Calls `update()` to notify the UI to refresh with the new state.
  // # Input:
  // # - `value`: A boolean value that determines whether the main screen should be hidden.
  // # Raises:
  // # - None
  // # Returns:
  // # - None

  updateHideMenu(bool value) {
    hideMainScreen.value = value;
    update();
  }
// # ===================================================== [ UPDATE HIDE MENU ] =====================================================



  
  
  
//   # ===================================================== [ LOAD POS CATEGORY BASED ON USER ] =====================================================
  // # Functionality:
  // # - This function loads POS categories for the user based on the current POS object.
  // # - Calls an external service (`OdooProjectOwnerConnectionHelper.odooClient.callKw`) to retrieve translated category names for the POS.
  // # - If the data is available, it maps the response into a list of `PosCategory` objects.
  // # - In case of an error, it handles the exception gracefully and returns an appropriate response.
  // # Input:
  // # - None (relies on `SharedPr.currentPosObject` for the POS ID).
  // # Raises:
  // # - Exception handling via the `handleException` function in case of failures.
  // # Returns:
  // # - A list of `PosCategory` objects if data is retrieved successfully, `null` otherwise.

  Future loadPosCategoryBasedOnUser() async {
    try {
      var result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.posCategoryTransit,
        'method': 'get_translated_category_names',
        'args': [SharedPr.currentPosObject!.id!],
        'kwargs': {
        },
      });
      return result.isEmpty
          ? null
          : (result as List)
              .map((e) => PosCategory.fromJson(e, fromPosCategoryModel: false))
              .toList();
    } catch (e) {
      return await handleException(
          exception: e,
          navigation: false,
          methodName: "loadPosCategoryBasedOnUser");
    }
  }
//   # ===================================================== [ LOAD POS CATEGORY BASED ON USER ] =====================================================




//   # ===================================================== [ LOAD POS CATEGORY BASED ON IDS ] =====================================================
  // # Functionality:
  // # - This function loads POS categories based on the provided list of IDs (`posCategoriesIds`).
  // # - If the list is empty, it returns `null`.
  // # -  fetch POS categories by their IDs from the remote server.
  // # - The fetched data is mapped into a list of `PosCategory` objects.
  // # - In case of an error, it handles the exception.
  // # Input:
  // # - List of integers `posCategoriesIds`: The list of POS category IDs to be loaded.
  // # Raises:
  // # - Exception handling via the `handleException` function in case of failures.
  // # Returns:
  // # - A list of `PosCategory` objects if data is retrieved successfully, `null` otherwise.

  Future loadPosCategoryIsNotDB({required List<int> posCategoriesIds}) async {
    try {
      if (posCategoriesIds.isEmpty) {
        return null;
      } else {
        var result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
          'model': OdooModels.posCategory,
          'method': 'search_read',
          'args': [],
          'kwargs': {
            'domain': [['id', 'in', posCategoriesIds]],
          },
        });
        return result.isEmpty
            ? null
            : (result as List)
                .map((e) => PosCategory.fromJson(e, fromPosCategoryModel: true))
                .toList();
      }
    } catch (e) {
      return await handleException(
          exception: e,
          navigation: false,
          methodName: "loadPosCategoryIsNotDB");
    }
  }
//   # ===================================================== [ LOAD POS CATEGORY BASED ON IDS ] =====================================================





//   # ===================================================== [ COUNT REMOTE POS CATEGORY ] =====================================================
  // # Functionality:
  // # - This function counts the number of unique POS categories from remote settings.
  // # - It calls an external service to fetch POS category IDs from `posSetting` models based on the provided list of IDs (`posSetting`).
  // # - It extracts the `pos_category_ids` field from the results, removes duplicates (using a set), and returns the count of unique POS categories.
  // # - In case of an error, it handles the exception via the `handleException` function.
  // # Input:
  // # - List of integers `posSetting`: A list of POS setting IDs whose POS categories are to be counted.
  // # Raises:
  // # - Exception handling via the `handleException` function in case of failures.
  // # Returns:
  // # - An integer representing the count of unique POS categories.

  Future countRemotPosCategory({required List<int> posSetting}) async {
    try {
      var result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.posSetting,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['id', 'in', posSetting],
          ],
          'fields': ['pos_category_ids'],
        },
      });
      if (result.isNotEmpty) {
        List<int> posCategory = [];
        for (Map<String, dynamic> item in result) {
          posCategory.addAll(item["pos_category_ids"].cast<int>());
        }
        Set<int> setCategory = posCategory.toSet();
        List<int> diffList = setCategory.toList();
        return diffList.length;
      }

      return 0;
    } catch (e) {
      return await handleException(
          exception: e,
          navigation: false,
          methodName: "getRemotPosCategoryIsNotIds");
    }
  }
//   # ===================================================== [ COUNT REMOTE POS CATEGORY ] =====================================================



  
 //   # ===================================================== [ BUILD CATEGORY TREE ] =====================================================
  // # Functionality:
  // # - This function builds a tree-like structure from a flat list of categories.
  // # - Each category can have a parent ID (`parentId`), and if it doesn't have a parent, it is considered a root category.
  // # - The function first creates a map of categories, where each category is identified by its ID.
  // # - Then, it iterates through the list of categories:
  // #   - If a category has no parent (i.e., `parentId` is `null` or `0`), it is added to the `rootCategories` list.
  // #   - If a category has a parent, it is added as a child to the corresponding parent category.
  // # - The function returns a list of root categories, each of which may have children nested in them.
  // # Input:
  // # - A list of `PosCategory` objects, each having an `id`, `parentId`, and optionally a list of `children`.
  // # Returns:
  // # - A list of root `PosCategory` objects, each having a nested structure of `children` representing the category tree.

  List<PosCategory> buildCategoryTree(List<PosCategory> categories) {
    Map<int, PosCategory> map = {};
    List<PosCategory> rootCategories = [];

    for (var category in categories) {
      map[category.id!] = category;

      // it will be root
      if (category.parentId == null || category.parentId == 0) {
        rootCategories.add(category);
      } else {
        // it will be child
        PosCategory? parent = map[category.parentId];
        if (parent != null) {
          parent.children ??= [];
          parent.children!.add(category);
        }
      }
    }

    return rootCategories; // Return root categories
  }

}
