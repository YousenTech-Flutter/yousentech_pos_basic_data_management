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
import 'package:yousentech_pos_loading_synchronizing_data/utils/fetch_date.dart';
import 'package:yousentech_pos_loading_synchronizing_data/yousentech_pos_loading_synchronizing_data.dart';

import '../../item_history/domain/item_history_viewmodel.dart';
import 'pos_category_service.dart';

class PosCategoryController extends GetxController {
  late PosCategoryService posCategoryService = PosCategoryService.getInstance();
  final ItemHistoryController _itemHistoryController = ItemHistoryController();
  LoadingSynchronizingDataService loadingSynchronizingDataService =
      LoadingSynchronizingDataService(type: PosCategory);

  var isLoading = false.obs;
  var hideMainScreen = false.obs;
  // List<PosCategory> posCategoryList = [];
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
      // posCategoryList = value.data;
      posCategoryList.value = value.data;
      // if (kDebugMode) {
      //   print(posCategoryList.length);
      // }
      // Update the controller
      update();
    });
  }

  // ========================================== [ START DISPLAY PRODUCT CATEGORY LIST ] =============================================
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

  // ========================================== [ END DISPLAY PRODUCT CATEGORY LIST ] =============================================

  // ========================================== [ START DISPLAY PRODUCT CATEGORY ] =============================================
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

  // ========================================== [ END DISPLAY PRODUCT CATEGORY ] =============================================

  // ========================================== [ START CREATE PRODUCT CATEGORY ] =============================================
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

            // var res = await _itemHistoryController.getItemFromHistory(
            //     itemId: posCategory.id!, type: OdooModels.posCategory);
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

// ========================================== [ END CREATE PRODUCT CATEGORY ] =============================================

// ========================================== [ START UPDATE PRODUCT CATEGORY ] =============================================
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
            // await ProductController().onInit();

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
    // if (connectivityResult.contains(ConnectivityResult.none) &&
    //     posCategory.odooId != null) {
    //   dynamic result = await posCategoryService.update(
    //       id: posCategory.id!, obj: posCategory, whereField: 'id');
    //   if (result is int) {
    //     ItemHistory itemHistory = ItemHistory(
    //       posCategoryId: posCategory.id!,
    //       isAdded: false,
    //       typeName: OdooModels.posCategory,
    //     );
    //     await ItemHistoryService.getInstance()
    //         .createItemHistoryDB(itemHistory: itemHistory);
    //     result = ResponseResult(
    //         status: true, message: "Successful".tr, data: posCategory);
    //     hideMainScreen.value = true;
    //   } else {
    //     result = ResponseResult(message: result);
    //   }
    //   isLoading.value = false;
    //   return result;
    // } else {
    //   dynamic result = await posCategoryService.update(
    //       id: posCategory.id!, obj: posCategory, whereField: 'id');
    //   if (result is int) {
    //     result = ResponseResult(
    //         status: true, message: "Successful".tr, data: posCategory);
    //     hideMainScreen.value = true;
    //   } else {
    //     result = ResponseResult(message: result);
    //   }
    //   isLoading.value = false;
    //   return result;
    // }
    // dynamic result = await posCategoryService.update(
    //     id: posCategory.id!, obj: posCategory, whereField: 'id');
    // if (result is int) {
    //   result = ResponseResult(
    //       status: true, message: "Successful".tr, data: posCategory);
    //   hideMainScreen.value = true;
    // } else {
    //   result = ResponseResult(message: result);
    // }
    // isLoading.value = false;
    // return result;
  }

// ========================================== [ END UPDATE PRODUCT CATEGORY ] =============================================

// ========================================== [ START DELETE PRODUCT CATEGORY ] =============================================
  // Future<dynamic> deletePosCategory({required PosCategory posCategory}) async {
  //   isLoading.value = true;
  //   dynamic result;
  //   // Check if there is an internet connection
  //   if (posCategory.odooId != null) {
  //     var connectivityResult = await (Connectivity().checkConnectivity());
  //     if (!connectivityResult.contains(ConnectivityResult.none)) {
  //       // Remotely Remove
  //       result = await posCategoryService.deletePosCategoryRemotely(
  //           id: posCategory.odooId!);
  //       if (result is! bool && result != true) {
  //         result = ResponseResult(message: result);
  //       }
  //     }
  //   }

  //   // Locally Remove
  //   result =
  //       await posCategoryService.delete(id: posCategory.id!, whereField: 'id');
  //   if (result != 0) {
  //     result = ResponseResult(
  //         status: true, message: "Successful".tr, data: posCategory);
  //   } else {
  //     result = ResponseResult(message: result);
  //   }
  //   isLoading.value = false;
  //   update();
  //   return result;
  // }

// ========================================== [ END DELETE PRODUCT CATEGORY ] =============================================

// ============================================ [ SEARCH PRODUCT CATEGORY ] ===============================================
  Future<void> search(String query) async {
    if (posCategoryList.isNotEmpty) {
      searchResults.clear();
      var result = await posCategoryService.search(query);
      if (result is List) {
        // if (kDebugMode) {
        //   print(
        //       'posCategoryService LENGTH : ${result.map((e) => e.toJson()).toList()}');
        // }
        searchResults.addAll(result as List<PosCategory>);
      }
      // for (PosCategory posCategory in posCategoryList) {
      //   if (posCategory.name!.toLowerCase().contains(query.toLowerCase())) {
      //     searchResults.add(posCategory);
      //   }
      // }
      update();
    }
  }

// ============================================ [ SEARCH PRODUCT CATEGORY ] ===============================================

  updateHideMenu(bool value) {
    hideMainScreen.value = value;
    // if (kDebugMode) {
    //   print('hideMainScreen.value : ${hideMainScreen.value}');
    // }
    update();
  }

  // Future getRemotPosCategoryIsNotIds(
  //     {required List<int> ids, required List<int> posSetting}) async {
  //   try {
  //     // if (kDebugMode) {
  //     //   print("getRemotPosCategoryIsNotIds ids+++++++ : $ids");
  //     //   print("posSetting ids+++++++ : $posSetting");
  //     // }
  //     var result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
  //       'model': OdooModels.posSetting,
  //       'method': 'search_read',
  //       'args': [],
  //       'kwargs': {
  //         'domain': [
  //           ['id', 'in', posSetting],
  //         ],
  //         'fields': ['pos_category_ids'],
  //       },
  //     });
  //     // if (kDebugMode) {
  //     //   print("result : $result");
  //     // }
  //     if (result.isNotEmpty) {
  //       List<int> posCategory = [];
  //       for (Map<String, dynamic> item in result) {
  //         // print("pos_category_ids ${item["pos_category_ids"]}");
  //         posCategory.addAll(item["pos_category_ids"].cast<int>());
  //       }
  //       // print("pos_category_ids ${posCategory}");
  //       Set<int> setCategory = posCategory.toSet();
  //       Set<int> setPos = ids.toSet();
  //       Set<int> difference = setCategory.difference(setPos);
  //       // Convert the difference back to a list
  //       List<int> diffList = difference.toList();
  //       // print("diffList $diffList");
  //       return await loadPosCategoryIsNotDB(posCategoriesIds: diffList);
  //       // return await loadPosCategoryBasedOnUser();
  //     }

  //     return null;
  //   } catch (e) {
  //     return handleException(
  //         exception: e,
  //         navigation: false,
  //         methodName: "getRemotPosCategoryIsNotIds");
  //   }
  // }

  Future loadPosCategoryBasedOnUser() async {
    try {
      // if (kDebugMode) {
      //   print(SharedPr.currentPosObject!.id!);
      // }
      var result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.posCategoryTransit,
        'method': 'get_translated_category_names',
        'args': [SharedPr.currentPosObject!.id!],
        'kwargs': {
          // 'context': {},
          // 'domain': [
          //   ['id', 'in', posCategoriesIds]
          // ],
          // 'fields': [],
        },
      });
      // print(result);
      return result.isEmpty
          ? null
          : (result as List)
              .map((e) => PosCategory.fromJson(e, fromPosCategoryModel: false))
              .toList();
    } catch (e) {
      return handleException(
          exception: e,
          navigation: false,
          methodName: "loadPosCategoryBasedOnUser");
    }
  }

  Future loadPosCategoryIsNotDB({required List<int> posCategoriesIds}) async {
    try {
      if (posCategoriesIds.isEmpty) {
        return null;
      } else {
        var result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
          'model': OdooModels.posCategory,
          'method': 'search_read',
          // 'args': [SharedPr.currentPosObject!.id!],
          'args': [],
          'kwargs': {
            'domain': [
              ['id', 'in', posCategoriesIds]
            ],
            // 'context': {'lang': SharedPr.lang == 'ar' ? 'ar_001' : 'en_US'}
          },
        });
        return result.isEmpty
            ? null
            : (result as List)
                .map((e) => PosCategory.fromJson(e, fromPosCategoryModel: true))
                .toList();
      }
    } catch (e) {
      return handleException(
          exception: e,
          navigation: false,
          methodName: "loadPosCategoryIsNotDB");
    }
  }

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
      return handleException(
          exception: e,
          navigation: false,
          methodName: "getRemotPosCategoryIsNotIds");
    }
  }

  // ===========================================================================================
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

    // OUTPUT SIMULATION
    // ===========================================================
    // [
    //   PosCategory(id: 1, name: 'Electronics', parentId: null, children: [
    //     PosCategory(id: 2, name: 'Laptops', parentId: 1),
    //     PosCategory(id: 3, name: 'Phones', parentId: 1),
    //   ]),
    //   PosCategory(id: 4, name: 'Clothing', parentId: null, children: [
    //     PosCategory(id: 5, name: 'Men', parentId: 4),
    //     PosCategory(id: 6, name: 'Women', parentId: 4),
    //   ]),
    // ]
    // =================================================================
    return rootCategories; // Return root categories
  }
  // ===========================================================================================
}
