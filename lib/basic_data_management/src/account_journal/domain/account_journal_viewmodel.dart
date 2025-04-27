import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/account_journal/data/account_journal.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'account_journal_service.dart';

class AccountJournalController extends GetxController {
  final AccountJournalService _accountTaxService = AccountJournalService.getInstance();

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
    update();
  }

// # ===================================================== [ DISPLAY ACCOUNT JOURNAL LIST ] =====================================================
  // # Functionality:
  // # - Fetches the list of account journals.
  // # - Updates the UI loading state while fetching the data.
  // # - Returns a successful result with the data if the fetch is successful, otherwise returns an error result.
  // # Input:
  // # - None
  // # Returns:
  // # - ResponseResult: Contains the status, message, and data (list of account journals) or an error message.

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
// # ===================================================== [ DISPLAY ACCOUNT JOURNAL LIST ] =====================================================


// ============================================ [ SEARCH PRODUCT UNIT ] ===============================================
  // # Functionality:
  // # - Searches the account journals list based on the provided query.
  // # - Clears the previous search results before adding the new filtered results.
  // # - Updates the UI after the search is complete with the filtered account journals.
  // # Input:
  // # - query: A string representing the search query to filter the account journals.
  // # Returns:
  // # - None

  Future<void> search(String query) async {
    if (accountJournalList.isNotEmpty) {
      searchResults.clear();
      var result = await _accountTaxService.search(query);
      if (result is List) {
        searchResults.addAll(result as List<AccountJournal>);
      }
      update();
    }
  }
// ============================================ [ SEARCH PRODUCT UNIT ] ===============================================



  
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
