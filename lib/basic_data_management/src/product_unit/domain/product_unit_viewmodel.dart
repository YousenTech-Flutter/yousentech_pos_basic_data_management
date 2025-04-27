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
    update();
  }

// # ===================================================== [ DISPLAY PRODUCT UNIT LIST ] =====================================================
  // # Functionality:
  // # - This function fetches a list of product units.
  // # - The `isLoading` flag is set to true at the beginning to indicate that data is being loaded.
  // # - If the result is a valid list, it wraps the result in a `ResponseResult` with a success status and message.
  // # - If the result is not a valid list, it wraps the result in a `ResponseResult` with the error message.
  // # - After the data is loaded, the `isLoading` flag is set to false.
  // # Input:
  // # - No specific input, as it fetches data from the service.
  // # Returns:
  // # - A `ResponseResult` containing the product unit list and a success or error message.
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
// # ===================================================== [ DISPLAY PRODUCT UNIT LIST ] =====================================================




  
// # ===================================================== [ DISPLAY PRODUCT ] =====================================================
  // # Functionality:
  // # - This function fetches a single product based on its ID.
  // # - The `isLoading` flag is set to true at the beginning to indicate that data is being loaded.
  // # - If the result is a valid list, it wraps the result in a `ResponseResult` with a success status and message.
  // # - If the result is not a valid list, it wraps the result in a `ResponseResult` with the error message.
  // # - After the data is loaded, the `isLoading` flag is set to false.
  // # Input:
  // # - `id`: The unique identifier for the product.
  // # Returns:
  // # - A `ResponseResult` containing the product data or an error message.
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
// # ===================================================== [ DISPLAY PRODUCT ] =====================================================



  
  
// # ===================================================== [ SEARCH PRODUCT UNIT ] =====================================================
  // # Functionality:
  // # - This function allows searching for product units based on the provided query string.
  // # - It first checks if the `productUnitList` is not empty.
  // # - The `searchResults` list is cleared to ensure fresh search results.
  // # - If the search result is a valid list, the results are added to the `searchResults` list.
  // # - After updating the search results, the `update()` method is called to update the state.
  // # Input:
  // # - `query`: The query string used for searching product units.
  // # Returns:
  // # - This function doesn't return anything. It updates the search results in the state.
  Future<void> search(String query) async {
    if (productUnitList.isNotEmpty) {

      searchResults.clear();
      var result = await productUnitService.search(query: query);
      if (result is List) {
        
        searchResults.addAll(result as List<ProductUnit>);
      }
      update();
    }
  }
// # ===================================================== [ SEARCH PRODUCT UNIT ] =====================================================



  
//   # ===================================================== [ UPDATE HIDE MENU ] =====================================================
  // # Functionality:
  // # - This function is used to update the visibility of the main screen.
  // # - The visibility is controlled by the `hideMainScreen` variable, which is updated to the value passed as an argument (`value`).
  // # - After updating the `hideMainScreen` variable, the `update()` method is called to trigger a UI update, ensuring the changes are reflected in the UI.
  // # Input:
  // # - `value`: A boolean value that determines whether to hide the main screen (`true` for hiding, `false` for showing).
  // # Returns:
  // # - This function does not return anything. It only updates the state of the visibility and triggers a UI update.

  updateHideMenu(bool value) {
    hideMainScreen.value = value;
    update();
  }
//   # ===================================================== [ UPDATE HIDE MENU ] =====================================================

}
