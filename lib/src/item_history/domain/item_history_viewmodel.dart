import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/basic_item_history.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:yousentech_pos_loading_synchronizing_data/utils/define_type_function.dart';
import 'item_history_service.dart';

class ItemHistoryController extends GetxController {
  ItemHistoryService itemHistoryService = ItemHistoryService.getInstance();

  // ========================================== [ START DISPLAY ITEM FROM HISTORY ] =============================================

  Future<dynamic> getItemFromHistory(
      {required int itemId, required String type}) async {
    dynamic result = await itemHistoryService.show(itemId: itemId, type: type);
    if (result is BasicItemHistory) {
      result =
          ResponseResult(status: true, message: "Successful".tr, data: result);
    } else {
      result = ResponseResult(message: result, data: BasicItemHistory());
    }
    return result;
  }

  Future<dynamic> updateHistoryAndReturnProductId(
      {required int productTemplateId}) async {
    dynamic result = await itemHistoryService.updateHistoryAndReturnProductId(
        productTemplateId: productTemplateId);
    if (result is int) {
      result =
          ResponseResult(status: true, message: "Successful".tr, data: result);
    } else {
      result = ResponseResult(message: result);
    }
    return result;
  }

// ========================================== [ END DISPLAY ITEM FROM HISTORY ] =============================================

// ========================================== [ START UPDATE HISTORY ITEMS BELONG TO CURRENT POS IN FIRST LOGIN ] =============================================

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
// ========================================== [ END UPDATE HISTORY ITEMS BELONG TO CURRENT POS IN FIRST LOGIN ] =============================================
}
