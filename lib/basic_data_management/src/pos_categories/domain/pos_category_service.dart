
import 'package:pos_shared_preferences/models/pos_categories_data/pos_category.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_odoo_models.dart';
import 'package:shared_widgets/shared_widgets/handle_exception_helper.dart';
import 'package:shared_widgets/shared_widgets/odoo_connection_helper.dart';
import 'package:yousentech_pos_local_db/yousentech_pos_local_db.dart';
import 'pos_category_repository.dart';

class PosCategoryService extends PosCategoryRepository {
  GeneralLocalDB? _generalLocalDBInstance;
  static PosCategoryService? posCategoryDataServiceInstance;

  PosCategoryService._() {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<PosCategory>(
        fromJsonFun: PosCategory.fromJson);
  }

  static PosCategoryService getInstance() {
    posCategoryDataServiceInstance =
        posCategoryDataServiceInstance ?? PosCategoryService._();
    return posCategoryDataServiceInstance!;
  }

  @override
  Future createTable() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<PosCategory>(
        fromJsonFun: PosCategory.fromJson);
    return await _generalLocalDBInstance!
        .createTable(structure: LocalDatabaseStructure.posCategoryStructure);
  }

  @override
  Future index() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<PosCategory>(
        fromJsonFun: PosCategory.fromJson);
    return await _generalLocalDBInstance!.index();
  }

  @override
  Future dropTable() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<PosCategory>(
        fromJsonFun: PosCategory.fromJson);
    return await _generalLocalDBInstance!.dropTable();
  }

  @override
  Future deleteData() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<PosCategory>(
        fromJsonFun: PosCategory.fromJson);
    return await _generalLocalDBInstance!.deleteData();
  }

  @override
  Future show({required dynamic val}) async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<PosCategory>(
        fromJsonFun: PosCategory.fromJson);
    return await _generalLocalDBInstance!.show(val: val, whereArg: 'id');
  }

  @override
  Future<int> create({required obj, bool isRemotelyAdded = false}) async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<PosCategory>(
        fromJsonFun: PosCategory.fromJson);
    return await _generalLocalDBInstance!
        .create(obj: obj, isRemotelyAdded: isRemotelyAdded);
  }

  @override
  Future search(String query) async {
    // REPLACE(REPLACE(product_name, '"en_US":', ''), '"ar_001":', '') LIKE ?
    try {
      _generalLocalDBInstance = GeneralLocalDB.getInstance<PosCategory>(
          fromJsonFun: PosCategory.fromJson);
      return await _generalLocalDBInstance!.filter(
          whereArgs: ['%$query%'],
          where:
              '''REPLACE(REPLACE(name, '"en_US":', ''), '"ar_001":', '') LIKE ?''');
    } catch (e) {
      return await handleException(
          exception: e, navigation: false, methodName: "PosCategorySearch");
    }
  }

  Future createPosCategoryRemotely({required obj}) async {
    try {
      int result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.posCategory,
        'method': 'create',
        'args': [obj is Map<String, dynamic> ? obj : obj.toJson()],
        'kwargs': {},
      });
      return result;
    } catch (e) {
      return await handleException(
          exception: e,
          navigation: false,
          methodName: "createPosCategoryRemotely");
    }
  }

  Future connectCategoryWithPOS({required ids}) async {
    try {
      bool result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.posSetting,
        'method': 'write',
        'args': [
          SharedPr.currentPosObject!.id!,
          {
            'pos_category_ids': ids,
          },
        ],
        'kwargs': {},
      });
      return result;
    } catch (e) {
      return await  handleException(
          exception: e,
          navigation: false,
          methodName: "connectCategoryWithPOS");
    }
  }

  @override
  Future<int> update(
      {required int id, required obj, required String whereField}) async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<PosCategory>(
        fromJsonFun: PosCategory.fromJson);
    return await _generalLocalDBInstance!
        .update(id: id, obj: obj, whereField: 'id');
  }

  Future updatePosCategoryRemotely({required int id, required obj}) async {
    try {
      bool result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.posCategory,
        'method': 'write',
        'args': [id, obj],
        'kwargs': {
          'context': {
            'lang': SharedPr.lang == 'ar'
                ? '${SharedPr.lang}_001'
                : '${SharedPr.lang}_US'
          }
        },
      });

      return result;
    } catch (e) {
      return await handleException(
          exception: e,
          navigation: false,
          methodName: "updatePosCategoryRemotely");
    }
  }
}
