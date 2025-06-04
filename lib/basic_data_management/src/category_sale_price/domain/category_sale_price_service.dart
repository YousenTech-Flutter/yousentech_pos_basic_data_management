import 'package:pos_shared_preferences/models/category_sale_price.dart';
import 'package:shared_widgets/shared_widgets/handle_exception_helper.dart';
import 'package:yousentech_pos_local_db/yousentech_pos_local_db.dart';

import 'category_sale_price_repository.dart';

class CategorySalePriceService extends CategorySalePriceRepository {
  GeneralLocalDB? _generalLocalDBInstance;
  static CategorySalePriceService? categorySalePriceDataServiceInstance;

  CategorySalePriceService._() {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<CategorySalePrice>(
        fromJsonFun: CategorySalePrice.fromJson);
  }

  static CategorySalePriceService getInstance() {
    categorySalePriceDataServiceInstance =
        categorySalePriceDataServiceInstance ?? CategorySalePriceService._();
    return categorySalePriceDataServiceInstance!;
  }

  @override
  Future createTable() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<CategorySalePrice>(
        fromJsonFun: CategorySalePrice.fromJson);
    return await _generalLocalDBInstance!
        .createTable(structure: LocalDatabaseStructure.categorySalePriceStructure);
  }

  @override
  Future index() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<CategorySalePrice>(
        fromJsonFun: CategorySalePrice.fromJson);
    return await _generalLocalDBInstance!.index();
  }

  @override
  Future dropTable() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<CategorySalePrice>(
        fromJsonFun: CategorySalePrice.fromJson);
    return await _generalLocalDBInstance!.dropTable();
  }

  @override
  Future deleteData() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<CategorySalePrice>(
        fromJsonFun: CategorySalePrice.fromJson);
    return await _generalLocalDBInstance!.deleteData();
  }

  @override
  Future show({required dynamic val}) async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<CategorySalePrice>(
        fromJsonFun: CategorySalePrice.fromJson);
    return await _generalLocalDBInstance!.show(val: val, whereArg: 'id');
  }

  @override
  Future<int> create({required obj, bool isRemotelyAdded = false}) async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<CategorySalePrice>(
        fromJsonFun: CategorySalePrice.fromJson);
    return await _generalLocalDBInstance!
        .create(obj: obj, isRemotelyAdded: isRemotelyAdded);
  }

  @override
  Future search(String query) async {
    try {
      _generalLocalDBInstance =
          GeneralLocalDB.getInstance<CategorySalePrice>(
              fromJsonFun: CategorySalePrice.fromJson);
      // TODO ::: NEDD TO FIX THE SEARCH QUERY
      return await _generalLocalDBInstance!
          .filter(whereArgs: ['%$query%'], where: 'name LIKE ?');
    } catch (e) {
      return await handleException(
          exception: e,
          navigation: false,
          methodName: "CategorySalePriceSearch");
    }
  }

  @override
  Future<int> update(
      {required int id, required obj, required String whereField}) async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<CategorySalePrice>(
        fromJsonFun: CategorySalePrice.fromJson);
    return await _generalLocalDBInstance!
        .update(id: id, obj: obj, whereField: 'id');
  }


}
