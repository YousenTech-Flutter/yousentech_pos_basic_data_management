import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/customer_model.dart';
import 'package:shared_widgets/config/app_odoo_models.dart';
import 'package:shared_widgets/shared_widgets/handle_exception_helper.dart';
import 'package:shared_widgets/shared_widgets/odoo_connection_helper.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/domain/customer_service.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/config/app_enums.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_viewmodel.dart';

class CustomerController extends GetxController {
  final loading = false.obs;
  late CustomerService customerService = CustomerService.getInstance();
  var hideMainScreen = false.obs;
  RxBool isLoading = false.obs;
  RxList<Customer> customerList = <Customer>[].obs;
  RxList<Customer> customerpagingList = <Customer>[].obs;
  RxList<Customer> seachCustomerPagingList = <Customer>[].obs;
  RxList<Customer> searchResults = RxList<Customer>();
  Customer? object;

  LoadingDataController loadingDataController =  Get.find<LoadingDataController>();

  var page = 0.obs;
  final int limit = 16;
  var hasMore = false.obs;
  var hasLess = false.obs;
  //==================for Pagnation  item================
  int selectedPagnation = 0;
  int skip = 0;
  int pagnationpagesNumber = 0;
  //==================for Pagnation  item================
  @override
  Future<void> onInit() async {
    super.onInit();
    await customersData();
    
  }

  customersData() async {
    var result = await getAllCustomerLocal(paging: true , pageselecteed: 0 , type: "");
    if (result.status) {
      customerList.value = result.data;
    }
    update();
  }


//  # ===================================================== [ UPDATE CUSTOMER REMOTE AND LOCAL ] =====================================================
  // # Functionality:
  // # - Updates customer data both remotely and locally.
  // # - If the update is successful, it returns a success response.
  // # - If there is an error or failure, it returns an error message.
  // # Input:
  // # - id (int): The ID of the customer to be updated.
  // # - customer (Customer): The customer object with updated details.
  // # Raises:
  // # - None
  // # Returns:
  // # - ResponseResult: A response object containing the result of the update operation (status and message).

  Future<ResponseResult> updateCustomerRemotAndLocal(
      {required int id, required Customer customer}) async {
    dynamic result =
        await customerService.updateCustomerRemotAndLocal(customer: customer);
    if (result is bool && result) {
      return ResponseResult(
          status: true, message: "Successful".tr, data: result);
    } else {
      return ResponseResult(message: result);
    }
  }
//  # ===================================================== [ UPDATE CUSTOMER REMOTE AND LOCAL ] =====================================================



  

 // # ===================================================== [ CREATE CUSTOMER REMOTE AND LOCAL ] =====================================================
  // # Functionality:
  // # - Creates a new customer both remotely and locally.
  // # - If the customer creation is successful, it returns the newly created customer object.
  // # - If there is an error or failure, it returns an error message.
  // # Input:
  // # - customer (Customer): The customer object to be created.
  // # Raises:
  // # - None
  // # Returns:
  // # - ResponseResult: A response object containing the result of the customer creation operation (status and message).
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
 // # ===================================================== [ CREATE CUSTOMER REMOTE AND LOCAL ] =====================================================


  

// # ===================================================== [ CREATE CUSTOMER IN DATABASE ] =====================================================
  // # Functionality:
  // # - Creates a new customer in the local database.
  // # - If the customer is created successfully, the customer object is updated with the generated ID and added to the customer list.
  // # - If there is an error or failure during the operation, an exception message is returned.
  // # Input:
  // # - customer (Customer): The customer object to be created in the database.
  // # Raises:
  // # - Exception: If any error occurs during the database operation.
  // # Returns:
  // # - ResponseResult: A response object containing the status of the operation (success or failure) and a message.
  Future<ResponseResult> createCustomerDB({required Customer customer}) async {
    try {
      loading.value = true;
      int result = await customerService.createCustomerDB(customer: customer);
      if (result > 0) {
        customer.id = result;
        loading.value = false;
        customerList.add(customer);
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
// # ===================================================== [ CREATE CUSTOMER IN DATABASE ] =====================================================


  

// # ===================================================== [ GET CUSTOMER BY ID ] =====================================================
  // # Functionality:
  // # - Retrieves a customer from the database by the given ID.
  // # - If the customer is found, it returns the customer data.
  // # - If no customer is found, an empty list message is returned.
  // # - If there is an error or failure, the error message is returned.
  // # Input:
  // # - id (int): The ID of the customer to be retrieved from the database.
  // # Raises:
  // # - Exception: If an error occurs while retrieving the customer.
  // # Returns:
  // # - ResponseResult: A response object containing the status of the operation (success or failure) and a message.
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
// # ===================================================== [ GET CUSTOMER BY ID ] =====================================================



// # ===================================================== [ GET ALL CUSTOMERS LOCAL ] =====================================================
  // # Functionality:
  // # - Retrieves all customer data locally, with optional pagination support.
  // # - If pagination is enabled, it handles both prefix and suffix navigation and adjusts the pagination state accordingly.
  // # - Allows filtering of results based on search and updates the local customer list.
  // # Input:
  // # - paging (bool): Flag to indicate whether pagination is enabled (default: false).
  // # - type (String): Specifies the type of pagination ('current', 'prefix', or 'suffix').
  // # - pageselecteed (int): The selected page number to be loaded.
  // # - countSkip (int?): The number of records to skip based on pagination.
  // # Raises:
  // # - Exception: If an error occurs while retrieving customer data.
  // # Returns:
  // # - ResponseResult: A response object containing the status of the operation (success or failure) and a message with customer data.

  Future<ResponseResult> getAllCustomerLocal({bool paging = false,String type = "current",int pageselecteed = -1 , int  ? countSkip }) async {
    
    dynamic result;
        RxList<Customer> searchFiltterResult =searchResults.isNotEmpty
                ? searchResults
                : RxList<Customer>();
    var dataResultLenght = searchResults.isNotEmpty
            ? searchResults.length
            : loadingDataController.itemdata[Loaddata.customers.name.toString()] == null? 0 : 
                loadingDataController.itemdata[Loaddata.customers.name.toString()]['local'];
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
        result = searchFiltterResult.isNotEmpty
            ? searchFiltterResult.skip(countSkip ?? page.value * limit).take(limit).toList()
            : await customerService.getAllCustomersLocal(offset: countSkip ?? page.value * limit, limit: limit);
       
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
            if (result.length < limit  ) {
              hasMore.value = false;
            }
           
          } else if (pageselecteed != -1) {
            hasLess.value = true;
            hasMore.value = true;
            if (page.value == 0) {
              hasLess.value = false;
            } else if (page ==
                (dataResultLenght ~/
                        limit) +
                    (dataResultLenght %
                                limit !=
                            0
                        ? 1
                        : 0) -
                    1) {
              hasMore.value = false;
            }
          }

          CustomerController customerController = Get.find(tag: 'customerControllerMain');
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
// # ===================================================== [ GET ALL CUSTOMERS LOCAL ] =====================================================


  
//===================================================== [ COUNT CUSTOMERS REMOTELY ] =====================================================
  // # Functionality:
  // # - Retrieves the count of customers remotely by calling the customer service.
  // # - If the count is successfully retrieved, it returns the count.
  // # - If an error occurs, it returns a count of 0 and a success status.
  // # Input:
  // # - None
  // # Raises:
  // # - Exception: If there is an error during the customer count retrieval.
  // # Returns:
  // # - ResponseResult: A response object containing the status of the operation (success or failure) and the customer count data.

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
//===================================================== [ COUNT CUSTOMERS REMOTELY ] =====================================================


  

// ============================================ [ SEARCH CUSTOMER ] ===============================================
  // # Functionality:
  // # - Clears existing search results and searches for customers using the provided query.
  // # - If the search result is a list of customers, it adds the results to the search results.
  // # - Updates the UI to reflect the new search results.
  // # Input:
  // # - query: A string that contains the search term to find customers.
  // # Raises:
  // # - Exception: If there is an error during the customer search.
  // # Returns:
  // # - void: No value is returned; the results are updated in the UI.
  Future<void> search(String query) async {
    if (customerList.isNotEmpty) {
      searchResults.clear();
      var result = await customerService.search(query);
      if (result is List) {
        searchResults.addAll(result as List<Customer>);
      }
     
      update();
    }
  }
// ============================================ [  SEARCH CUSTOMER] ===============================================


    
// # ===================================================== [ GET REMOTE CUSTOMERS EXCLUDING IDS ] =====================================================
  // # Functionality:
  // # - Fetches customers from the remote Odoo database that are not in the provided list of IDs.
  // # - Filters customers with a rank greater than 0 and an active status.
  // # - Returns a list of customers if found; otherwise, returns null.
  // # - Catches exceptions and handles them with a helper method.
  // # Input:
  // # - ids: A list of integers representing the IDs to exclude from the remote customer search.
  // # Raises:
  // # - Exception: If an error occurs during the remote request, it is handled by the helper method.
  // # Returns:
  // # - List<Customer> or null: A list of customers not in the provided IDs, or null if no customers are found.

  Future getRemotCustomerIsNotIds({required List<int> ids}) async {
    try {
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

      return result.isEmpty
          ? null
          : (result as List)
              .map((e) => Customer.fromJson(e, fromLocal: false))
              .toList();
    } catch (e) {
      return await handleException(
          exception: e,
          navigation: false,
          methodName: "getRemotCustomerIsNotIds");
    }
  }
// # ===================================================== [ GET REMOTE CUSTOMERS EXCLUDING IDS ] =====================================================


  
// # ===================================================== [ LOAD CUSTOMERS EXCLUDING GIVEN IDS ] =====================================================
  // # Functionality:
  // # - Fetches customers from the remote Odoo database, either including all customers or excluding those whose IDs are provided.
  // # - Filters customers with a rank greater than 0 and an active status.
  // # - Retrieves specific fields like 'name', 'email', 'phone', 'customer_rank', and 'image_1920' for the customers.
  // # - Handles exceptions and calls a helper method in case of errors.
  // # Input:
  // # - customerIds: A list of integers representing the customer IDs to exclude from the remote customer search.
  // # Raises:
  // # - Exception: If an error occurs during the remote request, it is handled by the helper method.
  // # Returns:
  // # - List<Customer> or null: A list of customers (excluding the given IDs), or null if no customers are found.

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
      return  await handleException(
          exception: e, navigation: false, methodName: "loadPosCustomer");
    }
  }
// # ===================================================== [ LOAD CUSTOMERS EXCLUDING GIVEN IDS ] =====================================================


// ===================================================== [ UPDATE HIDE MENU ] =====================================================
  // # Functionality:
  // # - Updates the visibility of the main screen based on the provided boolean value.
  // # - Sets the `hideMainScreen` reactive variable to the given value.
  // # - Calls the `update` method to notify listeners of the change.
  // # Input:
  // # - value: A boolean that determines whether the main screen should be hidden or visible.
  // # Returns:
  // # - None: The function only updates the visibility state and notifies listeners.

  updateHideMenu(bool value) {
    hideMainScreen.value = value;
    update();
  }
// ===================================================== [ UPDATE HIDE MENU ] =====================================================



  
//  ===================================================== [ RESET PAGING LIST ] =====================================================
  // # Functionality:
  // # - Resets the current page index to 0.
  // # - Fetches the customer data locally, with pagination settings based on the `selectedpag` value.
  // # - Calls the `getAllCustomerLocal` method to load the customers with updated pagination.
  // # Input:
  // # - selectedpag: The selected page index to be used for pagination when fetching the customer list.
  // # Returns:
  // # - None: The function only updates the page value and fetches data.

    resetPagingList({required int selectedpag }) async {
    page.value = 0;
    await getAllCustomerLocal(paging: true, type: "", pageselecteed: selectedpag);
  }
//  ===================================================== [ RESET PAGING LIST ] =====================================================

}
