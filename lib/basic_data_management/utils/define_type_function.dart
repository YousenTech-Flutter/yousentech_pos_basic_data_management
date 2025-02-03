import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/account_journal/data/account_journal.dart';
import 'package:pos_shared_preferences/models/account_tax/data/account_tax.dart';
import 'package:pos_shared_preferences/models/customer_model.dart';
import 'package:pos_shared_preferences/models/pos_categories_data/pos_category.dart';
import 'package:pos_shared_preferences/models/product_data/product.dart';
import 'package:pos_shared_preferences/models/product_unit/data/product_unit.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_viewmodel.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/utils/define_type_function.dart';


LoadingDataController loadingDataController = Get.find<LoadingDataController>();
Future synchronizeBasedOnModelType({required String type}) async {
  Type typex = getModelClass(type);
  var result;

  if (typex == Product) {
    result = await loadingDataController.synchronizeDB<Product>();
  } else if (typex == Customer) {
    result = await loadingDataController.synchronizeDB<Customer>();
  } else if (typex == ProductUnit) {
    result = await loadingDataController.synchronizeDB<ProductUnit>();
  } else if (typex == PosCategory) {
    result = await loadingDataController.synchronizeDB<PosCategory>();
  } else if (typex == AccountTax) {
    result = await loadingDataController.synchronizeDB<AccountTax>();
  } else if (typex == AccountJournal) {
    result = await loadingDataController.synchronizeDB<AccountJournal>();
  }

  await loadingDataController.getitems();

  return result;
}

Future displayDataDiffBasedOnModelType({required String type}) async {
  loadingDataController.isUpdate.value = true;
  Type typex = getModelClass(type);
  var result;
  if (typex == Product) {
    result =
        await loadingDataController.displayAll<Product>(returnDiffData: true);
  } else if (typex == Customer) {
    result =
        await loadingDataController.displayAll<Customer>(returnDiffData: true);
  } else if (typex == PosCategory) {
    result = await loadingDataController.displayAll<PosCategory>(
        returnDiffData: true);
  }
  loadingDataController.isUpdate.value = false;
  return result;
}
