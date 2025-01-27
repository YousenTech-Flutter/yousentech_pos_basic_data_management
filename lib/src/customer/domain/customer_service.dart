import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import 'package:pos_shared_preferences/models/customer_model.dart';
import 'package:shared_widgets/config/app_odoo_models.dart';
import 'package:shared_widgets/shared_widgets/handle_exception_helper.dart';
import 'package:shared_widgets/shared_widgets/odoo_connection_helper.dart';
import 'package:shared_widgets/utils/mac_address_helper.dart';
import 'package:yousentech_pos_basic_data_management/src/customer/domain/customer_repository.dart';
import 'package:yousentech_pos_loading_synchronizing_data/yousentech_pos_loading_synchronizing_data.dart';
import 'package:yousentech_pos_local_db/yousentech_pos_local_db.dart';

import '../../item_history/domain/item_history_viewmodel.dart';

class CustomerService extends CustomerRepository {
  GeneralLocalDB? _generalLocalDBInstance;

  static CustomerService? customerDataServiceInstance;
  final ItemHistoryController _itemHistoryController = ItemHistoryController();
  LoadingSynchronizingDataService loadingSynchronizingDataService =
      LoadingSynchronizingDataService();

  CustomerService._() {
    _generalLocalDBInstance =
        GeneralLocalDB.getInstance<Customer>(fromJsonFun: Customer.fromJson);
  }

  static CustomerService getInstance() {
    customerDataServiceInstance =
        customerDataServiceInstance ?? CustomerService._();
    return customerDataServiceInstance!;
  }

  Future createTable() async {
    _generalLocalDBInstance =
        GeneralLocalDB.getInstance<Customer>(fromJsonFun: Customer.fromJson);
    await _generalLocalDBInstance!
        .createTable(structure: LocalDatabaseStructure.customerStructure);
  }

  @override
  Future deleteData() async {
    _generalLocalDBInstance =
        GeneralLocalDB.getInstance<Customer>(fromJsonFun: Customer.fromJson);
    return await _generalLocalDBInstance!.deleteData();
  }

  @override
  Future dropTable() async {
    _generalLocalDBInstance =
        GeneralLocalDB.getInstance<Customer>(fromJsonFun: Customer.fromJson);
    return await _generalLocalDBInstance!.dropTable();
  }

  @override
  Future update({required int id, required dataUpdated}) async {
    try {
      bool result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.customer,
        'method': 'write',
        'args': [
          id,
          dataUpdated.toJson(isRemotelyAdded: false),
        ],
        'kwargs': {},
      });

      return result;
    } on OdooException catch (e) {
      return handleException(
          exception: e, navigation: true, methodName: "updateCustomer");
    }
  }

  @override
  Future create({required dataCreate}) async {
    try {
      var partnerId = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.customer,
        'method': 'create',
        'args': [dataCreate.toJson(isRemotelyAdded: false)],
        'kwargs': {},
      });
      dataCreate.id = partnerId;
      return dataCreate;
    } catch (e) {
      return handleException(
          exception: e, navigation: true, methodName: "createCustomer");
    }
  }

  @override
  Future index() async {
    try {
      var partners = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.customer,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {},
          'domain': [
            ['customer_rank', '>', 0],
            ['active', '=', true],
          ],
          'fields': ['name', 'email', 'phone', 'customer_rank', 'image_1920'],
          'order': 'id'
        },
      });
      // if (kDebugMode) {
      //   print("partners :$partners");
      // }
      return partners.isEmpty || partners == null
          ? null
          : partners
              .map((e) => Customer.fromJson(e, fromLocal: false))
              .toList();
    } catch (e) {
      // if(kDebugMode){
      //   print("catch :$e");
      // }
      return handleException(
          exception: e, navigation: true, methodName: "getAllCustomer");
    }
  }

  @override
  Future count() async {
    try {
      var partners = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.customer,
        'method': 'search_count',
        'args': [],
        'kwargs': {
          'context': {},
          'domain': [
            ['customer_rank', '>', 0],
            ['active', '=', true],
          ],
        },
      });
      return partners;
    } catch (e) {
      return handleException(
          exception: e, navigation: false, methodName: "CustomerCount");
    }
  }

  @override
  Future show({required int id}) async {
    try {
      var partners = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.customer,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {},
          'domain': [
            ['id', '=', id]
          ],
          'fields': ['name', 'email', 'phone', 'image_1920', 'customer_rank'],
          'order': 'id'
        },
      });
      return partners.isEmpty || partners == null
          ? null
          : Customer.fromJson(partners.first);
    } catch (e) {
      return handleException(
          exception: e, navigation: true, methodName: "getCustomerById");
    }
  }

  @override
  Future search(String query) async {
    try {
      _generalLocalDBInstance =
          GeneralLocalDB.getInstance<Customer>(fromJsonFun: Customer.fromJson);
      return await _generalLocalDBInstance!.filter(
          whereArgs: ['%$query%', '%$query%', '%$query%'],
          where: 'name LIKE ? OR email LIKE ? OR phone LIKE ?');
    } catch (e) {
      return handleException(
          exception: e, navigation: false, methodName: "CustomerSearch");
    }
  }

  @override
  Future delete({required int odooId}) async {
    try {
      bool result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.customer,
        'method': 'unlink',
        'args': [odooId],
        'kwargs': {},
      });
      return result;
    } catch (e) {
      return handleException(
          exception: e, navigation: true, methodName: "deleteCustomer");
    }
  }

  Future updateCustomerRemotAndLocal({required Customer customer}) async {
    try {
      _generalLocalDBInstance =
          GeneralLocalDB.getInstance<Customer>(fromJsonFun: Customer.fromJson);
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (!connectivityResult.contains(ConnectivityResult.none) &&
          (customer.id != null)) {
        bool trustedDevice = await MacAddressHelper.isTrustedDevice();
        if (trustedDevice) {
          // print("ggggggggggg");
          dynamic result =
              await update(id: customer.id!, dataUpdated: customer);
          // print("wwwwwwwwwwww $result");
          if (result is bool) {
            if (result) {
              int affectedRows = await _generalLocalDBInstance!.update(
                  id: customer.id!,
                  obj: customer,
                  whereField: 'id',
                  isRemotelyAdded: true);
              // print("wwwwwwwwwwww222222");
              if (affectedRows > 0) {
                var res = await _itemHistoryController.getItemFromHistory(
                    type: OdooModels.customer, itemId: customer.id!);
                if (res.status) {
                  await loadingSynchronizingDataService.updateItemHistory(
                      typeName: OdooModels.customer, itemId: customer.id);
                }
                // await loadingSynchronizingDataService
                //     .updateItemHistory(itemHistory: [

                // ]);
                return true;
              } else {
                return "exception".tr;
              }
            }
            return "exception".tr;
          } else {
            // return "exception".tr;
            return result;
          }
        }
      } else {
        return "no_connection".tr;
      }
    } catch (e) {
      return e.toString();
    }
  }

  // ========================================== [ update Customer Remot ] =============================================

  Future createCustomerRemotAndLocal({required Customer customer}) async {
    try {
      _generalLocalDBInstance =
          GeneralLocalDB.getInstance<Customer>(fromJsonFun: Customer.fromJson);
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        bool trustedDevice = await MacAddressHelper.isTrustedDevice();
        if (trustedDevice) {
          dynamic result = await create(dataCreate: customer);
          if (result is Customer) {
            int affectedRows = await _generalLocalDBInstance!
                .create(obj: result, isRemotelyAdded: true);
            if (affectedRows > 0) {
              result.id = affectedRows;
              var res = await _itemHistoryController.getItemFromHistory(
                  type: OdooModels.customer, itemId: result.id!);
              // print(res);
              if (res.status) {
                //   // await loadingSynchronizingDataService
                //   //     .updateItemHistory(itemHistory: [res.data]);
                //
                await loadingSynchronizingDataService.updateItemHistory(
                    typeName: OdooModels.customer, itemId: result.id);
              }
              return result;
            } else {
              return handleException(
                  exception: affectedRows,
                  navigation: false,
                  methodName: "createCustomerRemotAndLocal");
              // return false;
            }
          } else {
            return result;
          }
        }
      } else {
        return "no_connection".tr;
      }
    } catch (e) {
      return handleException(
          exception: e,
          navigation: false,
          methodName: "createCustomerRemotAndLocal");
    }
  }

  Future<int> createCustomerDB({required Customer customer}) async {
    try {
      _generalLocalDBInstance =
          GeneralLocalDB.getInstance<Customer>(fromJsonFun: Customer.fromJson);
      // await _generalLocalDBInstance!
      //     .createTable(structure: LocalDatabaseStructure.customerStructure);
      int affectedRows = await _generalLocalDBInstance!
          .create(obj: customer, isRemotelyAdded: true);
      if (affectedRows > 0) {
        // ItemHistory itemHistory = ItemHistory(
        //   customerId: affectedRows,
        //   isAdded: true,
        //   typeName: OdooModels.customer,
        // );
        // await ItemHistoryService.getInstance()
        //     .createItemHistoryDB(itemHistory: itemHistory);
      }

      return affectedRows;
    } catch (e) {
      return 0;
    }
  }

  // ========================================== [ get All  Customers ] =============================================

  // ========================================== [ get All  Customers Local ] =============================================
  Future getAllCustomersLocal({int? offset, int? limit}) async {
    try {
      _generalLocalDBInstance =
          GeneralLocalDB.getInstance<Customer>(fromJsonFun: Customer.fromJson);
      var customers =
          await _generalLocalDBInstance!.index(offset: offset, limit: limit);
      return customers;
    } catch (e) {
      return handleException(
          exception: e, navigation: false, methodName: "getAllCustomersLocal");
    }
  }

  // ========================================== [ get All  Customers Local ] =============================================

  Future<List<Customer>> fetchCustomers(
      String search, int page, int pageSize) async {
    try {
      _generalLocalDBInstance =
          GeneralLocalDB.getInstance<Customer>(fromJsonFun: Customer.fromJson);
      List<Customer> matchedCustomer = (await _generalLocalDBInstance!.filter(
          whereArgs: ['%$search%', '%$search%', '%$search%'],
          where: 'name LIKE ? OR email LIKE ? OR phone LIKE ?',
          limit: pageSize,
          page: page)) as List<Customer>;

      return matchedCustomer;
    } catch (e) {
      return [];
    }
  }
}
