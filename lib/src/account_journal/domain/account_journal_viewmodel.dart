import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/account_journal/data/account_journal.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'account_journal_service.dart';

class AccountJournalController extends GetxController {
  final AccountJournalService _accountTaxService =
      AccountJournalService.getInstance();

  var isLoading = false.obs;
  var hideMainScreen = false.obs;
  List<AccountJournal> accountJournalList = [];
  RxList<AccountJournal> searchResults = RxList<AccountJournal>();
  AccountJournal? object;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _unitsData();
  }

  _unitsData() async {
    var result = await displayAccountJournalList();
    accountJournalList = result.data;
    // if (kDebugMode) {
    //   print('accountTaxList.length : ${accountTaxList.length}');
    // }
    update();
  }

  // ========================================== [ START DISPLAY PRODUCT UNIT LIST ] =============================================
  Future<dynamic> displayAccountJournalList() async {
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
  //     {required AccountJournal productUnit, bool isFromHistory = false}) async {
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
//   Future<dynamic> updateAccountTax({required AccountJournal productUnit}) async {
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
    if (accountJournalList.isNotEmpty) {
      // if (kDebugMode) {
      //   print("AccountJournal list is not empty");
      // }
      searchResults.clear();
      var result = await _accountTaxService.search(query);
      if (result is List) {
        // if (kDebugMode) {
        //   print(
        //       '_accountTaxService LENGTH : ${result.map((e) => e.toJson()).toList()}');
        // }
        searchResults.addAll(result as List<AccountJournal>);
      }
      // for (AccountJournal productUnit in accountTaxList) {
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
