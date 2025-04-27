
import 'package:pos_shared_preferences/models/basic_item_history.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_odoo_models.dart';
import 'package:shared_widgets/shared_widgets/handle_exception_helper.dart';
import 'package:shared_widgets/shared_widgets/odoo_connection_helper.dart';

import 'item_history_repository.dart';

class ItemHistoryService extends ItemHistoryRepository {
  static ItemHistoryService? _instance;

  ItemHistoryService._();

  static ItemHistoryService getInstance() {
    _instance ??= ItemHistoryService._();
    return _instance!;
  }

  Map<String, String> historyTypeListWithIdKey = {
    OdooModels.productTemplate: 'product_id',
    OdooModels.posCategory: 'category_id',
    OdooModels.customer: 'customer_id',
  };

  // ============================================================ [ GET HISTORY ITEM BASED ON TYPE ] ===========================================================

  @override
  Future show({required int itemId, required String type}) async {
    try {
      var result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.itemsHistoryMain,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['type_name', '=', type],
            ['pos_id', '=', SharedPr.currentPosObject!.id!],
            [historyTypeListWithIdKey[type], '=', itemId]
          ],
        },
      });
      return result.isEmpty
          ? BasicItemHistory()
          : BasicItemHistory.fromJson(result.first);
    } catch (e) {
      return await handleException(
          exception: e, navigation: false, methodName: "getItemsFromHistory");
    }
  }


  @override
  Future updateHistoryAndReturnProductId({required int productTemplateId}) async {
    try {
      int result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.itemsHistory,
        'method': 'update_history_and_return_product_id',
        'args': [productTemplateId, SharedPr.currentPosObject!.id!],
        'kwargs': {
        },
      });
      return result;
    } catch (e) {
      return await handleException(
          exception: e, navigation: false, methodName: "getItemsFromHistory");
    }
  }

  // ============================================================ [ GET HISTORY ITEM BASED ON TYPE ] ===========================================================

  // ========================================== [ UPDATE HISTORY ITEMS BELONG TO CURRENT POS IN FIRST LOGIN ] ==========================================
  @override
  Future update({required String type}) async {
    try {
      bool result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.itemsHistory,
        'method': 'update_history_record_on_first_login',
        'args': [SharedPr.currentPosObject!.id!,type],
        'kwargs': {
        },
      });

      return result;
    } catch (e) {
      return await handleException(
          exception: e,
          navigation: false,
          methodName: "updateHistoryRecordOnFirstLogin");
    }
  }
// ========================================== [ UPDATE HISTORY ITEMS BELONG TO CURRENT POS IN FIRST LOGIN ] ==========================================
}
