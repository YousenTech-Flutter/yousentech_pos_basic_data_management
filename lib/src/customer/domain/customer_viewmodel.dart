import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/customer_model.dart';
import 'package:shared_widgets/config/app_odoo_models.dart';
import 'package:shared_widgets/shared_widgets/handle_exception_helper.dart';
import 'package:shared_widgets/shared_widgets/odoo_connection_helper.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:yousentech_pos_basic_data_management/src/customer/domain/customer_service.dart';
import 'package:yousentech_pos_loading_synchronizing_data/config/app_enums.dart';
import 'package:yousentech_pos_loading_synchronizing_data/utils/fetch_date.dart';

class CustomerController extends GetxController {
  final loading = false.obs;
  late CustomerService customerService = CustomerService.getInstance();
  var hideMainScreen = false.obs;
  RxBool isLoading = false.obs;
  RxList<Customer> customerList = <Customer>[].obs;
  RxList<Customer> customerpagingList = <Customer>[].obs;
  RxList<Customer> seachCustomerPagingList = <Customer>[].obs;
  RxList<Customer> searchResults = RxList<Customer>();
  // TextEditingController searchCustomerController = TextEditingController();
  Customer? object;

  var page = 0.obs;
  final int limit = 16;
  var hasMore = false.obs;
  var hasLess = false.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    await customersData();
  }

  customersData() async {
    var result = await getAllCustomerLocal(paging: true);
    if (result.status) {
      customerList.value = result.data;
    }
    update();
  }

  // ========================================== [ update Customer Remot ] =============================================
  Future<ResponseResult> updateCustomerRemotAndLocal(
      {required int id, required Customer customer}) async {
    dynamic result =
        await customerService.updateCustomerRemotAndLocal(customer: customer);
    if (result is bool && result) {
      // final customerIndex =
      //     customerList.indexWhere((customer) => customer.id == id);
      // if (customerIndex != -1) {
      //   customerList[customerIndex] = customer;
      // }
      // update(['update_customer']);
      return ResponseResult(
          status: true, message: "Successful".tr, data: result);
    } else {
      return ResponseResult(message: result);
    }
  }

  // ========================================== [ update Customer Remot ] =============================================

  // ========================================== [ create Customer Remot ] =============================================
  Future<ResponseResult> createCustomerRemotAndLocal(
      {required Customer customer}) async {
    var result =
        await customerService.createCustomerRemotAndLocal(customer: customer);
    if (result is Customer) {
      return ResponseResult(
          status: true, message: "Successful".tr, data: result);
    } else {
      return ResponseResult(message: result);
    }
  }

  // ========================================== [ create Customer Remot] =============================================

  // ========================================== [ create Customer Remot ] =============================================
  Future<ResponseResult> createCustomerDB({required Customer customer}) async {
    try {
      loading.value = true;
      int result = await customerService.createCustomerDB(customer: customer);
      if (result > 0) {
        customer.id = result;
        loading.value = false;
        customerList.add(customer);
        // update(['update_customer']);
        return ResponseResult(
            status: true, message: "Successful".tr, data: customer);
      } else {
        loading.value = false;
        return ResponseResult(message: "exception".tr);
      }
    } catch (e) {
      loading.value = false;
      return ResponseResult(message: e.toString());
    }
  }

  // ========================================== [ create Customer Remot] =============================================

  // // ========================================== [ get All  Customers ] =============================================
  // Future<ResponseResult> getAllCustomersFromRemotAndSaveLocal() async {
  //   loading.value = true;

  //   var result = await customerService.getAllCustomersFromRemotAndSaveLocal();

  //   if (result.status) {
  //     loading.value = false;
  //     return ResponseResult(
  //         status: true, message: result.message, data: result.data);
  //   } else {
  //     loading.value = false;
  //     return ResponseResult(message: result.message);
  //   }
  // }

  // ========================================== [ get All  Customers ] =============================================

  // ========================================== [ get Customer by id ] =============================================
  Future<ResponseResult> getCustomer({required int id}) async {
    loading.value = true;

    dynamic result = await customerService.show(id: id);
    if (result is Customer) {
      loading.value = false;
      return ResponseResult(
          status: true, message: "Successful".tr, data: result);
    } else if (result is List) {
      loading.value = false;
      return ResponseResult(message: "empty_list".tr);
    } else {
      loading.value = false;
      return ResponseResult(message: result);
    }
  }

  // ========================================== [ get   Customer by id  ] =============================================

  // Future<ResponseResult> filteredCustomerByName({required String name}) async {
  //   var result = await customerService.filteredCustomerByName(name: name);
  //   if (result.status) {
  //     return ResponseResult(
  //         status: true, message: result.message, data: result.data);
  //   } else {
  //     return ResponseResult(message: result.message);
  //   }
  // }

  Future<ResponseResult> getAllCustomerLocal(
      {bool paging = false,
      String type = "current",
      int pageselecteed = -1,
      int? countSkip}) async {
    dynamic result;
    RxList<Customer> searchFiltterResult =
        searchResults.isNotEmpty ? searchResults : RxList<Customer>();
    var dataResultLenght = searchResults.isNotEmpty
        ? searchResults.length
        : loadingDataController.itemdata[Loaddata.customers.name.toString()]
            ['local'];
    if (paging) {
      if (!isLoading.value) {
        isLoading.value = true;

        if (type == "suffix" && hasMore.value) {
          page.value++;
        } else if (type == "prefix" && hasLess.value) {
          page.value--;
        } else if (pageselecteed != -1) {
          page.value = pageselecteed;
        }
        // result = await customerService.getAllCustomersLocal(offset: page.value * limit, limit: limit);
        result = searchFiltterResult.isNotEmpty
            ? searchFiltterResult
                .skip(countSkip ?? page.value * limit)
                .take(limit)
                .toList()
            : await customerService.getAllCustomersLocal(
                offset: countSkip ?? page.value * limit, limit: limit);

        if (result is List) {
          if ((type == "suffix" && hasMore.value)) {
            if (result.length < limit) {
              hasMore.value = false;
            }
            hasLess.value = true;
          } else if (type == "prefix" && hasLess.value) {
            if (page.value == 0) {
              hasLess.value = false;
            }
            hasMore.value = true;
          } else if (type == "current") {
            if (result.length < limit) {
              hasMore.value = false;
            }
            // if (result.length < limit || result.length == limit ) {
            //   hasMore.value = false;
            //   hasLess.value = false;
            // }
          } else if (pageselecteed != -1) {
            hasLess.value = true;
            hasMore.value = true;
            if (page.value == 0) {
              hasLess.value = false;
            } else if (page ==
                (dataResultLenght ~/ limit) +
                    (dataResultLenght % limit != 0 ? 1 : 0) -
                    1) {
              // print("hello");
              hasMore.value = false;
            }
          }

          CustomerController customerController =
              Get.find(tag: 'customerControllerMain');
          customerController.customerList.addAll((result) as List<Customer>);

          if (searchFiltterResult.isNotEmpty) {
            seachCustomerPagingList.clear();
            seachCustomerPagingList.addAll(result);
            customerController.update();
          } else {
            customerpagingList.clear();
            customerpagingList.addAll(result);
            customerController.update();
          }

          result = ResponseResult(
              status: true, message: "Successful".tr, data: result);
        } else {
          result = ResponseResult(message: result);
        }
        isLoading.value = false;
      }
    } else {
      isLoading.value = true;
      var result = await customerService.getAllCustomersLocal();
      if (result is List) {
        result = ResponseResult(
            status: true, message: "Successful".tr, data: result);
      } else {
        result = ResponseResult(message: result.message);
      }
      isLoading.value = false;
    }
    return result;
  }

  // Future<ResponseResult> getAllCustomerWhenCustomerRankLocal(
  //     {int rank = 0}) async {
  //   var result =
  //       await customerService.getAllCustomerWhenCustomerRankLocal(rank: rank);
  //   if (result.status) {
  //     return ResponseResult(
  //         status: true, message: result.message, data: result.data);
  //   } else {
  //     return ResponseResult(message: result.message);
  //   }
  // }

  // Future<ResponseResult> getAllCustomerWhenOdooIdLocal(
  //     {String odooId = ''}) async {
  //   var result =
  //       await customerService.getAllCustomerWhenOdooIdLocal(odooId: odooId);

  //   if (result.status) {
  //     return ResponseResult(
  //         status: true, message: result.message, data: result.data);
  //   } else {
  //     return ResponseResult(message: result.message);
  //   }
  // }

  // ========================================== [ count  All  Customers  in remot] =============================================
  Future<ResponseResult> countCustomersRemot() async {
    loading.value = true;
    var result = await customerService.count();
    if (result is int) {
      return ResponseResult(
          status: true, message: "Successful".tr, data: result);
    } else {
      loading.value = false;
      return ResponseResult(status: true, data: 0);
    }
  }

  // ========================================== [ count  All  Customers  in remot ] =============================================

  // // ========================================== [ count  All  Customers  in remot] =============================================
  // Future<ResponseResult> refreshCustomerDataRemoteServer() async {
  //   var result = await customerService.refreshCustomerDataRemoteServer();
  //   if (result is bool) {
  //     ResponseResult data = await getAllCustomerLocal();
  //     if (data.status) {
  //       loading.value = false;
  //       customerList.clear();
  //       customerList.addAll(data.data);
  //       // update(['update_customer']);
  //     }
  //     return ResponseResult(status: true, message: "Successful".tr);
  //   } else {
  //     return ResponseResult(message: result);
  //   }
  //   // var result = await getAllCustomerWhenOdooIdLocal();
  //   // try {
  //   //   if (result.status) {
  //   //     for (var element in result.data) {
  //   //       await createCustomerRemotAndLocal(customer: element);
  //   //     }
  //   //     return ResponseResult(
  //   //         status: true, message: "Successful".tr, data: result);
  //   //   } else {
  //   //     return ResponseResult();
  //   //   }
  //   // } catch (e) {
  //   //   return ResponseResult(message: e.toString());
  //   // }
  // }

  // // ========================================== [ count  All  Customers  in remot ] =============================================

  // Future<ResponseResult> updateLocalCustomer(
  //     {required int id, required Customer customer}) async {
  //   var result =
  //       await customerService.updateLocalCustomer(id: id, customer: customer);
  //   if (result.status) {
  //     final customerIndex =
  //         customerList.indexWhere((customer) => customer.id == id);
  //     if (customerIndex != -1) {
  //       customerList[customerIndex] = customer;
  //     }
  //     // customerList.removeWhere((item) => item.id == id);
  //     // // customerList.insert(id, customer);
  //     // customerList.add(customer);
  //     // update(['update_customer']);
  //     return ResponseResult(
  //         status: true, message: result.message, data: result.data);
  //   } else {
  //     return ResponseResult(message: result.message);
  //   }
  // }

  // Future<ResponseResult> deleteLocalCustomer({required int id}) async {
  //   var result = await customerService.deleteLocalCustomer(id: id);
  //   if (result.status) {
  //     customerList.removeWhere((item) => item.id == id);
  //     // update(['update_customer']);
  //     return ResponseResult(
  //         status: true, message: result.message, data: result.data);
  //   } else {
  //     return ResponseResult(message: result);
  //   }
  // }

  // Future<ResponseResult> deleteCustomerRemotAndLocal(
  //     {required Customer customer}) async {
  //   var result =
  //       await customerService.deleteCustomerRemotAndLocal(customer: customer);
  //   if (result) {
  //     return ResponseResult(
  //       status: true,
  //       message: "Successful".tr,
  //     );
  //   } else {
  //     return ResponseResult(message: 'exception'.tr);
  //   }
  // }

// ============================================ [ SEARCH CUSTOMER ] ===============================================
  Future<void> search(String query) async {
    if (customerList.isNotEmpty) {
      searchResults.clear();
      var result = await customerService.search(query);
      if (result is List) {
        searchResults.addAll(result as List<Customer>);
      }
      // new
      // for (Customer customer in customerList) {
      //   if (customer.name!.toLowerCase().contains(query.toLowerCase())) {
      //     searchResults.add(customer);
      //   }
      // }
      update();
    }
  }

// ============================================ [  SEARCH CUSTOMER] ===============================================

  Future getRemotCustomerIsNotIds({required List<int> ids}) async {
    try {
      // if (kDebugMode) {
      //   print("getRemotPosCategoryIsNotIds ids+++++++ : $ids");
      // }
      var result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.customer,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['id', 'not in', ids],
            ['customer_rank', '>', 0],
            ['active', '=', true],
          ],
        },
      });
      // print("getRemotCustomerIsNotIds ${result.length}");
      // print("getRemotCustomerIsNotIds $result");

      return result.isEmpty
          ? null
          : (result as List)
              .map((e) => Customer.fromJson(e, fromLocal: false))
              .toList();
    } catch (e) {
      return handleException(
          exception: e,
          navigation: false,
          methodName: "getRemotCustomerIsNotIds");
    }
  }

  Future loadCustomer({required List<int> customerIds}) async {
    try {
      var result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.customer,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {},
          'domain': customerIds.isEmpty
              ? [
                  ['customer_rank', '>', 0],
                  ['active', '=', true],
                ]
              : [
                  ['id', 'not in', customerIds],
                  ['customer_rank', '>', 0],
                  ['active', '=', true],
                ],
          'fields': ['name', 'email', 'phone', 'customer_rank', 'image_1920'],
          'order': 'id'
        }
      });
      return result.isEmpty
          ? null
          : (result as List)
              .map((e) => Customer.fromJson(e, fromLocal: false))
              .toList();
    } catch (e) {
      return handleException(
          exception: e, navigation: false, methodName: "loadPosCustomer");
    }
  }

  updateHideMenu(bool value) {
    hideMainScreen.value = value;
    update();

    // update(['update_customer']);
  }

  resetPagingList({required int selectedpag}) async {
    page.value = 0;
    await getAllCustomerLocal(
        paging: true, type: "", pageselecteed: selectedpag);
  }
}
