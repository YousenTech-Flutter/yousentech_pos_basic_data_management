
import 'package:pos_shared_preferences/models/product_unit/data/product_unit.dart';
import 'package:shared_widgets/shared_widgets/handle_exception_helper.dart';
import 'package:yousentech_pos_local_db/yousentech_pos_local_db.dart';
import 'product_unit_repository.dart';

class ProductUnitService extends ProductUnitRepository {
  GeneralLocalDB? _generalLocalDBInstance;
  static ProductUnitService? productUnitDataServiceInstance;

  ProductUnitService._() {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<ProductUnit>(
        fromJsonFun: ProductUnit.fromJson);
  }

  static ProductUnitService getInstance() {
    productUnitDataServiceInstance =
        productUnitDataServiceInstance ?? ProductUnitService._();
    return productUnitDataServiceInstance!;
  }

  @override
  Future createTable() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<ProductUnit>(
        fromJsonFun: ProductUnit.fromJson);
    return await _generalLocalDBInstance!
        .createTable(structure: LocalDatabaseStructure.productUnitStructure);
  }

  @override
  Future deleteData() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<ProductUnit>(
        fromJsonFun: ProductUnit.fromJson);
    return await _generalLocalDBInstance!.deleteData();
  }

  @override
  Future dropTable() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<ProductUnit>(
        fromJsonFun: ProductUnit.fromJson);
    return await _generalLocalDBInstance!.dropTable();
  }

  @override
  Future index() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<ProductUnit>(
        fromJsonFun: ProductUnit.fromJson);
    return await _generalLocalDBInstance!.index();
  }

  @override
  Future show({required dynamic val}) async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<ProductUnit>(
        fromJsonFun: ProductUnit.fromJson);
    return await _generalLocalDBInstance!.show(val: val, whereArg: 'id');
  }

  @override
  Future<int> create({required obj, bool isRemotelyAdded = false}) async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<ProductUnit>(
        fromJsonFun: ProductUnit.fromJson);
    return await _generalLocalDBInstance!
        .create(obj: obj, isRemotelyAdded: isRemotelyAdded);
  }

  @override
  Future search({required String query, String? param}) async {
    try {
      _generalLocalDBInstance = GeneralLocalDB.getInstance<ProductUnit>(
          fromJsonFun: ProductUnit.fromJson);
      return await _generalLocalDBInstance!.filter(
          whereArgs: ['%$query%'],
          where:
              '''REPLACE(REPLACE(${param ?? 'name'}, '"en_US":', ''), '"ar_001":', '') LIKE ?'''
          // '${param ?? 'name'} LIKE ?'
          );
    } catch (e) {
      return await handleException(
          exception: e, navigation: false, methodName: "ProductUnitSearch");
    }
  }

  @override
  Future<int> update(
      {required int id, required obj, required String whereField}) async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<ProductUnit>(
        fromJsonFun: ProductUnit.fromJson);
    return await _generalLocalDBInstance!
        .update(id: id, obj: obj, whereField: 'id');
  }

  // ============================================================ [ WORK WITH REMOTE ] ===========================================================

}
