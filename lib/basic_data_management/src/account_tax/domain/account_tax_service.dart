import 'package:pos_shared_preferences/models/account_tax/data/account_tax.dart';
import 'package:shared_widgets/shared_widgets/handle_exception_helper.dart';
import 'package:yousentech_pos_local_db/yousentech_pos_local_db.dart';
import 'account_tax_repository.dart';

class AccountTaxService extends AccountTaxRepository {
  GeneralLocalDB? _generalLocalDBInstance;
  static AccountTaxService? accountTaxDataServiceInstance;

  AccountTaxService._() {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<AccountTax>(
        fromJsonFun: AccountTax.fromJson);
  }

  static AccountTaxService getInstance() {
    accountTaxDataServiceInstance =
        accountTaxDataServiceInstance ?? AccountTaxService._();
    return accountTaxDataServiceInstance!;
  }

  @override
  Future createTable() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<AccountTax>(
        fromJsonFun: AccountTax.fromJson);
    return await _generalLocalDBInstance!
        .createTable(structure: LocalDatabaseStructure.accountTaxStructure);
  }

  @override
  Future deleteData() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<AccountTax>(
        fromJsonFun: AccountTax.fromJson);
    return await _generalLocalDBInstance!.deleteData();
  }

  @override
  Future dropTable() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<AccountTax>(
        fromJsonFun: AccountTax.fromJson);
    return await _generalLocalDBInstance!.dropTable();
  }

  @override
  Future index() async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<AccountTax>(
        fromJsonFun: AccountTax.fromJson);
    return await _generalLocalDBInstance!.index();
  }

  @override
  Future show({required dynamic val}) async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<AccountTax>(
        fromJsonFun: AccountTax.fromJson);
    return await _generalLocalDBInstance!.show(val: val, whereArg: 'id');
  }

  @override
  Future<int> create({required obj, bool isRemotelyAdded = false}) async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<AccountTax>(
        fromJsonFun: AccountTax.fromJson);
    return await _generalLocalDBInstance!
        .create(obj: obj, isRemotelyAdded: isRemotelyAdded);
  }

  @override
  Future search(String query) async {
    try {
      _generalLocalDBInstance = GeneralLocalDB.getInstance<AccountTax>(
          fromJsonFun: AccountTax.fromJson);
      return await _generalLocalDBInstance!.filter(
          whereArgs: ['%$query%'],
          where:
              '''REPLACE(REPLACE(name, '"en_US":', ''), '"ar_001":', '') LIKE ?'''
          );
    } catch (e) {
      return await handleException(
          exception: e, navigation: false, methodName: "AccountTaxSearch");
    }
  }

  @override
  Future<int> update(
      {required int id, required obj, required String whereField}) async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<AccountTax>(
        fromJsonFun: AccountTax.fromJson);
    return await _generalLocalDBInstance!
        .update(id: id, obj: obj, whereField: 'id');
  }
}
