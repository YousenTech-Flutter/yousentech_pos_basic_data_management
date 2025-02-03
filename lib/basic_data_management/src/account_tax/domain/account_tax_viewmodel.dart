import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/account_tax/data/account_tax.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'account_tax_service.dart';

class AccountTaxController extends GetxController {
  final AccountTaxService _accountTaxService = AccountTaxService.getInstance();

  var isLoading = false.obs;
  var hideMainScreen = false.obs;
  List<AccountTax> accountTaxList = [];
  RxList<AccountTax> searchResults = RxList<AccountTax>();
  AccountTax? object;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _unitsData();
  }

  _unitsData() async {
    var result = await displayAccountTaxList();
    accountTaxList = result.data;
    // if (kDebugMode) {
    //   print('accountTaxList.length : ${accountTaxList.length}');
    // }
    update();
  }

  // ========================================== [ START DISPLAY PRODUCT UNIT LIST ] =============================================
  Future<dynamic> displayAccountTaxList() async {
    isLoading.value = true;
    dynamic result = await _accountTaxService.index();

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

  // ========================================== [ START CREATE PRODUCT UNIT ] =============================================
  // Future<dynamic> createAccountTax(
  //     {required AccountTax productUnit, bool isFromHistory = false}) async {
  //   isLoading.value = true;
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //
  //   if (!connectivityResult.contains(ConnectivityResult.none)) {
  //     // Remotely Added
  //     var remoteResult = await productUnitService.createAccountTaxRemotely(
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
//   Future<dynamic> updateAccountTax({required AccountTax productUnit}) async {
//     isLoading.value = true;
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (!connectivityResult.contains(ConnectivityResult.none) &&
//         productUnit.id != null) {
//       var remoteResult = await productUnitService.updateAccountTaxRemotely(
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
    if (accountTaxList.isNotEmpty) {
      // if (kDebugMode) {
      //   print("AccountTax list is not empty");
      // }
      searchResults.clear();
      var result = await _accountTaxService.search(query);
      if (result is List) {
        // if (kDebugMode) {
        //   print(
        //       '_accountTaxService LENGTH : ${result.map((e) => e.toJson()).toList()}');
        // }
        searchResults.addAll(result as List<AccountTax>);
      }
      // for (AccountTax productUnit in accountTaxList) {
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
