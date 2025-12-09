// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors_in_immutables
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_enums.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/domain/customer_service.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/domain/customer_viewmodel.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/presentation/views/create_edit_customer.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/utils/build_customer_body_table.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/widgets/show_diff_customer_dialog.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/product_screen.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/build_basic_data_table.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/define_type_function.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/config/app_enums.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_viewmodel.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  TextEditingController searchController = TextEditingController();
  LoadingDataController loadingDataController =
      Get.find<LoadingDataController>();
  late final CustomerController customerController;
  @override
  void initState() {
    super.initState();
    CustomerService.customerDataServiceInstance = null;
    CustomerService.getInstance();
    customerController = Get.put(
      CustomerController(),
      tag: 'customerControllerMain',
    );
    customerController.selectedPagnation = 0;
  }

  @override
  void dispose() {
    searchController.text = '';
    searchController.clear();
    customerController.searchResults.clear();
    Get.delete<CustomerController>(tag: 'customerControllerMain');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: loadingDataController.isUpdate.value,
      child: Stack(
        children: [
          GetBuilder<CustomerController>(
            tag: 'customerControllerMain',
            builder: (controller) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.setHeight(16),
                  horizontal: context.setWidth(20.5),
                ),
                child: Container(
                  height: !Platform.isAndroid ?  double.infinity : null,
                  decoration: ShapeDecoration(
                    color:
                        SharedPr.isDarkMode!
                            ? Colors.black.withValues(alpha: 0.17)
                            : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color:
                            SharedPr.isDarkMode!
                                ? Colors.white.withValues(alpha: 0.50)
                                : Color(0x0C000000),
                      ),
                      borderRadius: BorderRadius.circular(
                        context.setMinSize(16),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: context.setHeight(11),
                      horizontal: context.setWidth(23),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            spacing: context.setHeight(12),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color:
                                          SharedPr.isDarkMode!
                                              ? const Color(0xFF3F3F3F)
                                              : const Color(0xFFDADADA),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'customer_list'.tr,
                                  style: TextStyle(
                                    color:
                                        SharedPr.isDarkMode!
                                            ? Colors.white
                                            : const Color(0xFF0C0C0C),
                                    fontSize: context.setSp(25),
                                    fontFamily: 'Tajawal',
                                    fontWeight: FontWeight.w700,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    spacing: context.setWidth(11),
                                    children: [
                                      ButtonClick(
                                        data: 'add_customer'.tr,
                                        onTap: () {
                                          createEditeCustomer(context: context);
                                        },
                                        color: const Color(0xFF16A6B7),
                                      ),
                                      ButtonClick(
                                        data: 'synchronization'.tr,
                                        onTap: () async {
                                          loadingDataController.isUpdate.value =
                                              true;
                        
                                          var result =
                                              await synchronizeBasedOnModelType(
                                                type: Loaddata.customers.toString(),
                                              );
                        
                                          if (result == true) {
                                            appSnackBar(
                                              message: 'synchronized'.tr,
                                              messageType: MessageTypes.success,
                                              isDismissible: false,
                                            );
                                          } else if (result is String) {
                                            appSnackBar(
                                              message: result,
                                              messageType:
                                                  MessageTypes.connectivityOff,
                                            );
                                          } else if (result == null) {
                                            appSnackBar(
                                              message: 'synchronization_problem'.tr,
                                              isDismissible: false,
                                            );
                                          } else {
                                            appSnackBar(
                                              message:
                                                  'synchronized_successfully'.tr,
                                              messageType: MessageTypes.success,
                                              isDismissible: false,
                                            );
                                          }
                        
                                          loadingDataController.update([
                                            'card_loading_data',
                                          ]);
                                          loadingDataController.update(['loading']);
                        
                                          loadingDataController.isUpdate.value =
                                              false;
                                        },
                                        color: const Color(0xFFF2AC57),
                                        isSync: true,
                                      ),
                                      ButtonClick(
                                        data: "Update_All".tr,
                                        onTap: () async {
                                          var result = await loadingDataController
                                              .updateAll(
                                                name: Loaddata.customers.toString(),
                                              );
                                          if (result == true) {
                                            appSnackBar(
                                              message: 'update_success'.tr,
                                              messageType: MessageTypes.success,
                                              isDismissible: false,
                                            );
                                          } else if (result is String) {
                                            appSnackBar(
                                              message: result,
                                              messageType:
                                                  MessageTypes.connectivityOff,
                                            );
                                          } else {
                                            appSnackBar(
                                              message: 'update_Failed'.tr,
                                              messageType: MessageTypes.error,
                                              isDismissible: false,
                                            );
                                          }
                                          loadingDataController.update([
                                            'card_loading_data',
                                          ]);
                                        },
                                        textColor:
                                            SharedPr.isDarkMode!
                                                ? Colors.white
                                                : const Color(0xFF0C0C0C),
                                        color:
                                            SharedPr.isDarkMode!
                                                ? const Color(0xFF292929)
                                                : const Color(0xFFD5D5D5),
                                      ),
                                      ButtonClick(
                                        data: 'display'.tr,
                                        onTap: () async {
                                          var result =
                                              await displayDataDiffBasedOnModelType(
                                                type: Loaddata.customers.toString(),
                                              );
                                          if (result is List && result.isNotEmpty) {
                                            showDiffCustomersDialog(
                                              items: result,
                                              context: context,
                                            );
                                          } else if (result is String) {
                                            appSnackBar(
                                              message: result,
                                              messageType:
                                                  MessageTypes.connectivityOff,
                                            );
                                          } else {
                                            appSnackBar(
                                              message: "empty_filter".tr,
                                              messageType: MessageTypes.success,
                                            );
                                          }
                                        },
                                        textColor:
                                            SharedPr.isDarkMode!
                                                ? Colors.white
                                                : const Color(0xFF0C0C0C),
                                        color:
                                            SharedPr.isDarkMode!
                                                ? const Color(0xFF292929)
                                                : const Color(0xFFD5D5D5),
                                      ),
                                    ],
                                  ),
                                  GetBuilder<LoadingDataController>(
                                    id: "card_loading_data",
                                    builder: (_) {
                                      int remote =
                                          loadingDataController.itemdata[Loaddata
                                              .customers
                                              .name
                                              .toString()]["remote"];
                                      int local =
                                          loadingDataController.itemdata[Loaddata
                                              .customers
                                              .name
                                              .toString()]["local"];
                                      String syncData =
                                          (remote == 0
                                              ? "0"
                                              : local > remote
                                              ? (remote /
                                                      (local == 0 ? 1 : local) *
                                                      100)
                                                  .toStringAsFixed(0)
                                              : ((local / remote) * 100)
                                                  .toStringAsFixed(0));
                                      return Row(
                                        spacing: context.setWidth(13.27),
                                        children: [
                                          SizedBox(
                                            width: context.setWidth(200),
                                            height: context.setHeight(7),
                                            child: LinearProgressIndicator(
                                              value: double.parse(syncData) / 100,
                                              minHeight: 8,
                                              borderRadius: BorderRadius.circular(
                                                9999,
                                              ),
                                              backgroundColor:
                                                  SharedPr.isDarkMode!
                                                      ? const Color(0x26F7F7F7)
                                                      : const Color(0x268B8B8B),
                                              color:
                                                  SharedPr.isDarkMode!
                                                      ? const Color(0xFF18BBCD)
                                                      : const Color(0xFF16A6B7),
                                            ),
                                          ),
                                          Text(
                                            '${'synchronization'.tr} $syncData %',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color:
                                                  SharedPr.isDarkMode!
                                                      ? Colors.white
                                                      : const Color(0xFF0C0C0C),
                                              fontSize:context.setSp(15) ,
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.w500,
                                              height: 1.50,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: context.setWidth(16),
                                children: [
                                  Expanded(
                                    child: ContainerTextField(
                                      controller: searchController,
                                      labelText: "${'search_customers'.tr} .....",
                                      hintText: "${'search_customers'.tr} .....",
                                      keyboardType: TextInputType.text,
                                      width: context.screenWidth,
                                      height: context.setHeight(35),
                                      fontSize: context.setSp(14),
                                      contentPadding: EdgeInsets.fromLTRB(
                                        context.setWidth(9.36),
                                        context.setHeight(10.29),
                                        context.setWidth(7.86),
                                        context.setHeight(4.71),
                                      ),
                                      showLable: false,
                                      borderColor:
                                          !SharedPr.isDarkMode!
                                              ? Color(0xFFC2C3CB)
                                              : null,
                                      fillColor:
                                          !SharedPr.isDarkMode!
                                              ? Colors.white.withValues(alpha: 0.43)
                                              : const Color(0xFF2B2B2B),
                                      hintcolor:
                                          !SharedPr.isDarkMode!
                                              ? Color(0xFFC2C3CB)
                                              : const Color(0xFF9CA3AF),
                                      color:
                                          !SharedPr.isDarkMode!
                                              ? Color(0xFFC2C3CB)
                                              : const Color(0xFFC2C3CB),
                                      isAddOrEdit: true,
                                      borderRadius: context.setMinSize(10),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: context.setWidth(9.96),
                                          vertical: context.setHeight(5.95),
                                        ),
                                        child: SvgPicture.asset(
                                          AppImages.search,
                                          package: 'shared_widgets',
                                        ),
                                      ),
                                      onChanged: (text) async {
                                        customerController.selectedPagnation = 0 ;
                                        if (searchController.text == '') {
                                          customerController.searchResults.clear();
                                          await customerController.getAllCustomerLocal(
                                            paging: true,
                                            type: "",
                                            pageselecteed: 0);
                                          customerController.update();
                        
                        
                                        } else {
                                          await customerController.search(searchController.text);
                                        }
                                        customerController.pagnationpagesNumber = 0;
                                        
                                      },
                                    ),
                                  ),
                                  
                                  
                                  // InkWell(
                                  //   onTap: () {},
                                  //   child: Container(
                                  //     width: context.setWidth(52),
                                  //     height: context.setHeight(44.3),
                                  //     decoration: ShapeDecoration(
                                  //       color:
                                  //           SharedPr.isDarkMode!
                                  //               ? const Color(0xFF292929)
                                  //               : const Color(0xFFF8F9FB),
                                  //       shape: RoundedRectangleBorder(
                                  //         side:
                                  //             SharedPr.isDarkMode!
                                  //                 ? BorderSide.none
                                  //                 : BorderSide(
                                  //                   width: 1,
                                  //                   color: const Color(0xFFF1F3F9),
                                  //                 ),
                                  //         borderRadius: BorderRadius.circular(
                                  //           context.setMinSize(10),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     child: Center(
                                  //       child: SvgPicture.asset(
                                  //         'assets/image/filter.svg',
                                  //         width: context.setWidth(20),
                                  //         height: context.setHeight(20),
                                  //         color:
                                  //             SharedPr.isDarkMode!
                                  //                 ? null
                                  //                 : const Color(0xFF686868),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              buildBasicDataColumnHeader(
                                context: context,
                                data: [
                                  {"name": "number", "flex": 1},
                                  {"name": "customer_image", "flex": 1},
                                  {"name": "name", "flex": 2},
                                  {"name": "email", "flex": 2},
                                  {"name": "phone", "flex": 1},
                                  {"name": "actions", "flex": 1},
                                ],
                              ),
                              buildCustomerBodyTable(
                                context: context,
                                data:
                                customerController.selectedPagnation == 1 ? customerController.searchResults.isNotEmpty
                                        ? customerController.seachCustomerPagingList
                                        : customerController.customerpagingList:
                                searchController.text != '' ? customerController.searchResults :
                                    customerController.searchResults.isNotEmpty
                                        ? customerController.seachCustomerPagingList
                                        : customerController.customerpagingList,
                              ),
                              // if(!Platform.isAndroid)...[
                              //   SizedBox(height: context.setHeight(12),)
                              // ]
                              // ,
                        
                            ],
                          ),
                        ),
                        GetBuilder<LoadingDataController>(
                          id: "pagin",
                          builder: (loadingDataController) {
                            return PagnationWidget(
                              pagesNumber: customerController.pagnationpagesNumber,
                              totalItems:
                              searchController.text != '' ? customerController.searchResults.length :
                              customerController.searchResults.isNotEmpty ? 
                              customerController.seachCustomerPagingList.length :
                                  loadingDataController.itemdata[Loaddata
                                      .customers
                                      .name
                                      .toString()]["local"],
                              itemsPerPage:Platform.isWindows ? 18 : 10,
                              onPageChanged: (page) async{
                                customerController.selectedPagnation = 1 ;
                                customerController.pagnationpagesNumber = page;
                                await customerController.getAllCustomerLocal(
                                      paging: true,
                                      type: "",
                                      pageselecteed: page);
                              },
                            );
                          },
                        ),
                      
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Obx(() {
            if (loadingDataController.isUpdate.value ||
                loadingDataController.isRefresh.value) {
              return const LoadingWidget();
            } else {
              return const SizedBox.shrink(); // Return an empty widget when not loading
            }
          }),
        ],
      ),
    );
  }
}

class PagnationWidget extends StatefulWidget {
  final int totalItems;
  // إجمالي المنتجات
  final int itemsPerPage;
  // كم عنصر في الصفحة
  final Function(int) onPageChanged;
  int pagesNumber;
  PagnationWidget({
    super.key,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
    required this.pagesNumber,
  });

  @override
  State<PagnationWidget> createState() => _PagnationWidgetState();
}

class _PagnationWidgetState extends State<PagnationWidget> {
  // int currentPage = 0;
  int get totalPages => (widget.totalItems / widget.itemsPerPage).ceil();
  void _goToPage(int page) {
    if (page >= 0 && page <= totalPages) {
      setState(()  {
        widget.pagesNumber = page;
        });
      widget.onPageChanged(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    int startPage = max(0, widget.pagesNumber - 2);
    int endPage = min(totalPages, startPage + 4);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: 
      
      Row(
        spacing: context.setWidth(20),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(totalPages > 0)...[
          InkWell(
            onTap: widget.pagesNumber > 0 ? () => _goToPage(widget.pagesNumber - 1) : null,
            child: Container(
              width: context.setWidth(39),
              height: context.setHeight(35),
              decoration: ShapeDecoration(
                color:
                    SharedPr.isDarkMode!
                        ? const Color(0xFF292929)
                        : const Color(0xFFD5D5D5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.setMinSize(6.63)),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppImages.rightArrow,
                                                            package: 'shared_widgets',
                  width: context.setWidth(30),
                  height: context.setHeight(30),
                  color: SharedPr.isDarkMode! ? null : const Color(0xFF2B2B2B),
                ),
              ),
            ),
          ),
          // الصفحات
          for (int i = startPage; i <= endPage-1; i++)
            InkWell(
              onTap: () {
                _goToPage(i);
              },
              child: Container(
                width: context.setWidth(39),
                height: context.setHeight(35),
                decoration: ShapeDecoration(
                  color:
                      i == widget.pagesNumber
                          ? const Color(0xFF16A6B7)
                          : SharedPr.isDarkMode!
                          ? const Color(0xFF292929)
                          : const Color(0xFFD5D5D5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      context.setMinSize(6.63),
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    "${i+1}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                      i == widget.pagesNumber ? const Color(0xFFE0E0E0) :
                      SharedPr.isDarkMode!
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF292929),
                      fontSize: context.setSp(15),
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
            ),
          InkWell(
            onTap:
                (widget.pagesNumber+1) < totalPages
                    ? () => _goToPage(widget.pagesNumber + 1)
                    : null,
            child: Container(
              width: context.setWidth(39),
              height: context.setHeight(35),
              decoration: ShapeDecoration(
                color:
                    SharedPr.isDarkMode!
                        ? const Color(0xFF292929)
                        : const Color(0xFFD5D5D5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.setMinSize(6.63)),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppImages.leftArrow,
                                                            package: 'shared_widgets',
                  width: context.setWidth(30),
                  height: context.setHeight(30),
                  color: SharedPr.isDarkMode! ? null : const Color(0xFF2B2B2B),
                ),
              ),
            ),
          ),
          ]
        ],
      ),
    );
  }
}
