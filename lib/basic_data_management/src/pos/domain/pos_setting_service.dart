

import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_odoo_models.dart';
import 'package:shared_widgets/shared_widgets/handle_exception_helper.dart';
import 'package:shared_widgets/shared_widgets/odoo_connection_helper.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos/domain/pos_setting_repository.dart';

class PosSettingService extends PosSettingRepository {
  static PosSettingService? posCategoryDataServiceInstance;

  PosSettingService._();

  static PosSettingService getInstance() {
    posCategoryDataServiceInstance =
        posCategoryDataServiceInstance ?? PosSettingService._();
    return posCategoryDataServiceInstance!;
  }

  @override
  Future updatePOS({required Map obj, }) async {
    try {
      bool result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.posSetting,
        'method': 'write',
        'args': [
          SharedPr.currentPosObject!.id,
          obj,
        ],
        'kwargs': {},
      });
      return result;
    } catch (e) {
      return await handleException(
          exception: e,
          navigation: false,
          methodName: "updatePOS");
    }
  }

}