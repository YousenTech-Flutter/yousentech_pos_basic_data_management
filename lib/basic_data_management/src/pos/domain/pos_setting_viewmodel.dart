import 'package:get/get.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos/domain/pos_setting_service.dart';

class PosSettingController extends GetxController {
  late PosSettingService posSettingService = PosSettingService.getInstance();
  var isLoading = false.obs;
  Future<ResponseResult> updatePOS({required Map obj}) async {
    isLoading.value = true;
    dynamic result = await posSettingService.updatePOS(obj: obj);
    if (result is bool) {
      result =
          ResponseResult(status: true, message: "Successful".tr, data: result);
    } else {
      result = ResponseResult(message: result);
    }
    isLoading.value = false;
    return result;
  }
}
