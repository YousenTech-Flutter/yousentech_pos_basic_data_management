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
    update();
  }

// # ===================================================== [ DISPLAY ACCOUNT TAX LIST ] =====================================================
  // # Functionality:
  // # - Retrieves a list of account taxes .
  // # - If the result is a list, wraps it in a `ResponseResult` with a success status.
  // # - If the result is not a list, wraps the result in a `ResponseResult` with an error message.
  // # - Sets the `isLoading` flag to false once the operation is complete.
  // # Input:
  // # - None
  // # Raises:
  // # - None
  // # Returns:
  // # - A `ResponseResult` object with the list of account taxes or an error message.

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
// # ===================================================== [ DISPLAY ACCOUNT TAX LIST ] =====================================================






  
  
  
  
  // # ===================================================== [ SEARCH ACCOUNT TAX ] =====================================================
  // # Functionality:
  // # - Clears the existing search results and performs a search based on the provided query.
  // # - Fetches the search results.
  // # - If results are found, it updates the `searchResults` list with the new data and triggers a UI update.
  // # Input:
  // # - query: The search query to filter account taxes.
  // # Raises:
  // # - None
  // # Returns:
  // # - None

  Future<void> search(String query) async {
    if (accountTaxList.isNotEmpty) {
      searchResults.clear();
      var result = await _accountTaxService.search(query);
      if (result is List) {
        searchResults.addAll(result as List<AccountTax>);
      }
      update();
    }
  }
// # ===================================================== [ SEARCH ACCOUNT TAX ] =====================================================



  
// ===================================================== [ UPDATE HIDE MENU ] =====================================================
  // # Functionality:
  // # - Updates the visibility of the main screen based on the provided value.
  // # - Toggles the `hideMainScreen` value and updates the UI accordingly.
  // # Input:
  // # - value: A boolean indicating whether to hide (true) or show (false) the main screen.
  // # Returns:
  // # - None

  updateHideMenu(bool value) {
    hideMainScreen.value = value;
    update();
  }
// ===================================================== [ UPDATE HIDE MENU ] =====================================================
}
