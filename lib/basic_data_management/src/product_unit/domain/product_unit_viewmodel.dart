import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/product_unit/data/product_unit.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'product_unit_service.dart';

class ProductUnitController extends GetxController {
  ProductUnitService productUnitService = ProductUnitService.getInstance();

  var isLoading = false.obs;
  var hideMainScreen = false.obs;
  List<ProductUnit> productUnitList = [];
  RxList<ProductUnit> searchResults = RxList<ProductUnit>();
  ProductUnit? object;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _unitsData();
  }

  _unitsData() async {
    var result = await displayProductUnitList();
    productUnitList = result.data;
    // if (kDebugMode) {
    //   print('productUnitList.length : ${productUnitList.length}');
    // }
    update();
  }

  // ========================================== [ START DISPLAY PRODUCT UNIT LIST ] =============================================
  Future<dynamic> displayProductUnitList() async {
    isLoading.value = true;
    dynamic result = await productUnitService.index();

    if (result is List) {
      result =
          ResponseResult(status: true, message: "Successful".tr, data: result);
    } else {
      result = ResponseResult(message: result);
    }
    isLoading.value = false;
    return result;
  }
  // ========================================== [ END DISPLAY PRODUCT UNIT LIST ] =============================================

  // ========================================== [ START DISPLAY PRODUCT UNIT ] =============================================
  Future<dynamic> displayProduct({required int id}) async {
    isLoading.value = true;
    dynamic result = await productUnitService.show(val: id);
    if (result is List) {
      result =
          ResponseResult(status: true, message: "Successful".tr, data: result);
    } else {
      result = ResponseResult(message: result);
    }
    isLoading.value = false;
    return result;
  }
  // ========================================== [ END DISPLAY PRODUCT UNIT ] =============================================

  // ========================================== [ START CREATE PRODUCT UNIT ] =============================================
  // Future<dynamic> createProductUnit(
  //     {required ProductUnit productUnit, bool isFromHistory = false}) async {
  //   isLoading.value = true;
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //
  //   if (!connectivityResult.contains(ConnectivityResult.none)) {
  //     // Remotely Added
  //     var remoteResult = await productUnitService.createProductUnitRemotely(
  //         obj: productUnit.toJson());
  //
  //     if (remoteResult is int) {
  //       productUnit.id = remoteResult;
  //       await productUnitService.create(
  //           obj: productUnit, isRemotelyAdded: true);
  //       isLoading.value = false;
  //       return ResponseResult(
  //           status: true, data: productUnit, message: "Successful".tr);
  //
  //       //
  //     } else {
  //       isLoading.value = false;
  //       return ResponseResult(message: remoteResult);
  //     }
  //   }
  //   isLoading.value = false;
  //   return ResponseResult(message: "no_connection".tr);
  // }

// ========================================== [ END CREATE PRODUCT UNIT ] =============================================

// ========================================== [ START UPDATE PRODUCT UNIT ] =============================================
//   Future<dynamic> updateProductUnit({required ProductUnit productUnit}) async {
//     isLoading.value = true;
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (!connectivityResult.contains(ConnectivityResult.none) &&
//         productUnit.id != null) {
//       var remoteResult = await productUnitService.updateProductUnitRemotely(
//           id: productUnit.id!, obj: productUnit.toJson());
//       if (remoteResult is! bool || remoteResult != true) {
//         isLoading.value = false;
//         return ResponseResult(message: "error");
//       }
//       //
//       else {
//         await productUnitService.update(
//             id: productUnit.id!, obj: productUnit, whereField: 'id');
//         isLoading.value = false;
//         return ResponseResult(status: true, data: productUnit);
//       }
//       //
//     }
//     isLoading.value = false;
//     return ResponseResult(message: "no_connection".tr);
//   }
// ========================================== [ END UPDATE PRODUCT UNIT ] =============================================

// ============================================ [ SEARCH PRODUCT UNIT ] ===============================================
  Future<void> search(String query) async {
    if (productUnitList.isNotEmpty) {
      // if (kDebugMode) {
      //   print("ProductUnit list is not empty");
      // }
      searchResults.clear();
      var result = await productUnitService.search(query: query);
      if (result is List) {
        // if (kDebugMode) {
        //   print(
        //       'productUnitService LENGTH : ${result.map((e) => e.toJson()).toList()}');
        // }
        searchResults.addAll(result as List<ProductUnit>);
      }
      // for (ProductUnit productUnit in productUnitList) {
      //   if (productUnit.name!.toLowerCase().contains(query.toLowerCase())) {
      //     searchResults.add(productUnit);
      //   }
      // }
      update();
    }
  }

// ============================================ [ SEARCH PRODUCT UNIT ] ===============================================

  updateHideMenu(bool value) {
    hideMainScreen.value = value;
    // if (kDebugMode) {
    //   print('hideMainScreen.value : ${hideMainScreen.value}');
    // }
    update();
  }
}
