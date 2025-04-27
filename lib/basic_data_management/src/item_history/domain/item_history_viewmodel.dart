import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/basic_item_history.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/utils/define_type_function.dart';
import 'item_history_service.dart';

class ItemHistoryController extends GetxController {
  ItemHistoryService itemHistoryService = ItemHistoryService.getInstance();

 // ===================================================== [ GET ITEM FROM HISTORY ] =====================================================
  // # Functionality:
  // # - Retrieves item history based on the provided `itemId` and `type`.
  // # - If the result is an instance of `BasicItemHistory`, it wraps it in a `ResponseResult` with a success status.
  // # - If the result is not a `BasicItemHistory`, it wraps the result in a `ResponseResult` with an error message and an empty `BasicItemHistory` object as data.
  // # Input:
  // # - `itemId`: The ID of the item whose history is to be fetched.
  // # - `type`: The type of history to fetch.
  // # Raises:
  // # - None
  // # Returns:
  // # - A `ResponseResult` object with the item history data or an error message.
  Future<dynamic> getItemFromHistory(
      {required int itemId, required String type}) async {
    dynamic result = await itemHistoryService.show(itemId: itemId, type: type);
    if (result is BasicItemHistory) {
      result =
          ResponseResult(status: true, message: "Successful".tr, data: result);
    } else {
      result = ResponseResult(message: result,data: BasicItemHistory());
    }
    return result;
  }
 // ===================================================== [ GET ITEM FROM HISTORY ] =====================================================




  
// ===================================================== [ UPDATE HISTORY AND RETURN PRODUCT ID ] =====================================================
  // # Functionality:
  // # - Updates the item history based on the provided `productTemplateId` and returns the associated product ID.
  // # - If the result is an integer, it wraps it in a `ResponseResult` with a success status.
  // # - If the result is not an integer, it wraps the result in a `ResponseResult` with an error message.
  // # Input:
  // # - `productTemplateId`: The ID of the product template for which the history is to be updated.
  // # Raises:
  // # - None
  // # Returns:
  // # - A `ResponseResult` object with the product ID or an error message.

  Future<dynamic> updateHistoryAndReturnProductId({required int productTemplateId}) async {
    dynamic result = await itemHistoryService.updateHistoryAndReturnProductId(productTemplateId: productTemplateId);
    if (result is int) {
      result = ResponseResult(status: true, message: "Successful".tr, data: result);
    } else {
      result = ResponseResult(message: result);
    }
    return result;
  }
// ===================================================== [ UPDATE HISTORY AND RETURN PRODUCT ID ] =====================================================



  
// ===================================================== [ UPDATE HISTORY RECORD ON FIRST LOGIN ] =====================================================
  // # Functionality:
  // # - Updates the history record based on the provided type during the first login.
  // # - Uses the `typeName` derived from the model type `T` for the update operation.
  // # - If the result is a successful boolean response, it wraps it in a `ResponseResult` with a success status.
  // # - If the result is not a success, it wraps the result in a `ResponseResult` with an error message.
  // # Input:
  // # - `T`: A generic type that is used to retrieve the model's type name for the update operation.
  // # Raises:
  // # - None
  // # Returns:
  // # - A `ResponseResult` object with the result of the update operation or an error message.

  Future<dynamic> updateHistoryRecordOnFirstLogin<T>() async {
    String typeName = getOdooModels<T>();
    dynamic result = await itemHistoryService.update(type: typeName);
    if (result is bool && result == true) {
      result =
          ResponseResult(status: true, message: "Successful".tr, data: result);
    } else {
      result = ResponseResult(message: result);
    }
    return result;
  }
// ===================================================== [ UPDATE HISTORY RECORD ON FIRST LOGIN ] =====================================================
}
