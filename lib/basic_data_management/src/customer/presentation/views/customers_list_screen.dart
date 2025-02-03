import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_enum.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_no_data.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/mac_address_helper.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/config/app_list.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/domain/customer_service.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/domain/customer_viewmodel.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/presentation/views/create_customer.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/presentation/widgets/show_customer.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/utils/build_body_table.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/widget/tital.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/build_basic_data_table.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/define_type_function.dart';
import 'package:yousentech_pos_loading_synchronizing_data/yousentech_pos_loading_synchronizing_data.dart';

class CustomersListScreen extends StatefulWidget {
  const CustomersListScreen({super.key});

  @override
  State<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  late final CustomerController customerController;
  TextEditingController searchBarController = TextEditingController();
  TextEditingController pagnationController = TextEditingController();
  int selectedpag = 0;
  int skip = 0;
  int pagesNumber = 0;
  Future getsCountLocalAndRemote() async {
    // print("=======================start");
    await loadingDataController.getitems();
    loaddata.entries.firstWhere((element) => element.key == Loaddata.customers);

    // print(loadingDataController.itemdata.containsKey(Loaddata.customers.name));
    // print("=======================end");
  }

  @override
  void dispose() {
    searchBarController.dispose();
    customerController.searchResults.clear();
    pagnationController.clear();
    Get.delete<CustomerController>(tag: 'customerControllerMain');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    CustomerService.customerDataServiceInstance = null;
    CustomerService.getInstance();
    customerController =
        Get.put(CustomerController(), tag: 'customerControllerMain');

    // selectedpag = customerController.page.value;
    selectedpag = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getsCountLocalAndRemote();
    });
  }

  @override
  void didUpdateWidget(covariant CustomersListScreen oldWidget) async {
    await customerController.customersData();
    super.didUpdateWidget(oldWidget);
  }

  // Future getPagingList() async {
  //   await customerController.getAllCustomerLocal(
  //     paging: true,
  //     type: "current",
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: loadingDataController.isUpdate.value,
      child: Container(
        color: AppColor.dashbordcolor,
        child: Stack(
          children: [
            GetBuilder<CustomerController>(
                // id: "update_customer",
                tag: 'customerControllerMain',
                builder: (controller) {
                  if (customerController.hideMainScreen.value) {
                    searchBarController.text = '';
                    selectedpag = 0;
                  }
                  return !customerController.hideMainScreen.value
                      ? SizedBox(
                          width: Get.width - 60,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TitalWidget(title: 'customer_list'.tr),
                                      // Container(
                                      //   margin: EdgeInsets.only(
                                      //       top: 10.r, left: 20.r, right: 20.r),
                                      //   height: 50.h,
                                      //   width: 50.w,
                                      //   decoration: BoxDecoration(
                                      //       color: AppColor.white,
                                      //       borderRadius: BorderRadius.all(
                                      //           Radius.circular(5.r))),
                                      //   child: Row(
                                      //     children: [
                                      //       Container(
                                      //         height: 50.h,
                                      //         width: 4.w,
                                      //         decoration: BoxDecoration(
                                      //             color: AppColor.cyanTeal,
                                      //             borderRadius:
                                      //                 BorderRadiusDirectional
                                      //                     .only(
                                      //                         topStart: Radius
                                      //                             .circular(
                                      //                                 5.r),
                                      //                         bottomStart: Radius
                                      //                             .circular(
                                      //                                 5.r))),
                                      //       ),
                                      //       SizedBox(
                                      //         width: 10.r,
                                      //       ),
                                      //       Align(
                                      //         alignment: Alignment.center,
                                      //         child: Text(
                                      //           'customer_list'.tr,
                                      //           style: TextStyle(
                                      //               fontSize: 4.sp,
                                      //               color: AppColor.slateGray,
                                      //               fontWeight: FontWeight.bold,
                                      //               fontFamily: 'Tajawal'),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),

                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 10.r, left: 20.r, right: 20.r),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      bool trustedDevice =
                                                          await MacAddressHelper
                                                              .isTrustedDevice();
                                                      if (trustedDevice) {
                                                        customerController
                                                            .updateHideMenu(
                                                                true);
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 30.h,
                                                      width: 15.w,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.r)),
                                                        color: AppColor.white,
                                                        border: Border.all(
                                                            color: AppColor
                                                                .silverGray),
                                                      ),
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                          "assets/image/user_add.svg",
                                                          package:
                                                              'yousentech_pos_basic_data_management',
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          fit: BoxFit.fill,
                                                          width: 19.r,
                                                          height: 19.r,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10.r,
                                                  ),
                                                  Expanded(
                                                    child: ContainerTextField(
                                                      controller:
                                                          searchBarController,
                                                      height: 30.h,
                                                      labelText: '',
                                                      // hintText: " ${'search'.tr}",
                                                      hintText:
                                                          " ${'search'.tr}  ${"name".tr} , ${"email".tr} , ${"phone".tr}",
                                                      fontSize: 10.r,
                                                      fillColor: AppColor.white,
                                                      borderColor:
                                                          AppColor.silverGray,
                                                      hintcolor: AppColor.black
                                                          .withOpacity(0.5),
                                                      isAddOrEdit: true,
                                                      borderRadius: 5.r,
                                                      prefixIcon: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5.r,
                                                                vertical: 5.r),
                                                        child: SvgPicture.asset(
                                                          "assets/image/search_quick.svg",
                                                          package:
                                                              'yousentech_pos_basic_data_management',
                                                          width: 19.r,
                                                          height: 19.r,
                                                        ),
                                                      ),
                                                      suffixIcon:
                                                          searchBarController
                                                                  .text
                                                                  .isNotEmpty
                                                              ? InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    searchBarController
                                                                        .text = '';
                                                                    customerController
                                                                        .searchResults
                                                                        .clear();
                                                                    customerController
                                                                        .update();
                                                                    selectedpag =
                                                                        0;
                                                                    pagnationController
                                                                            .text =
                                                                        (1).toString();
                                                                    await customerController.resetPagingList(
                                                                        selectedpag:
                                                                            selectedpag);
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            5.r,
                                                                        vertical:
                                                                            10.r),
                                                                    child: FaIcon(
                                                                        FontAwesomeIcons
                                                                            .circleXmark,
                                                                        color: AppColor
                                                                            .red,
                                                                        size: 10
                                                                            .r),
                                                                  ),
                                                                )
                                                              : null,
                                                      onChanged: (text) async {
                                                        if (searchBarController
                                                                .text ==
                                                            '') {
                                                          customerController
                                                              .searchResults
                                                              .clear();
                                                          customerController
                                                              .update();
                                                          selectedpag = 0;
                                                          pagnationController
                                                                  .text =
                                                              (1).toString();
                                                          await customerController
                                                              .resetPagingList(
                                                                  selectedpag:
                                                                      selectedpag);
                                                        } else {
                                                          // selectedpag =0;
                                                          // await customerController.resetPagingList(selectedpag: selectedpag);
                                                          await customerController
                                                              .search(
                                                                  searchBarController
                                                                      .text);
                                                          selectedpag = 0;
                                                          pagnationController
                                                                  .text =
                                                              (1).toString();
                                                          await customerController
                                                              .resetPagingList(
                                                                  selectedpag:
                                                                      selectedpag);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.r,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10.r,
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      var e = loaddata.entries
                                                          .firstWhere((element) =>
                                                              element.key ==
                                                              Loaddata
                                                                  .customers);
                                                      var result =
                                                          await loadingDataController
                                                              .updateAll(
                                                                  name: e.key
                                                                      .toString());

                                                      if (result == true) {
                                                        appSnackBar(
                                                            message:
                                                                'update_success'
                                                                    .tr,
                                                            messageType:
                                                                MessageTypes
                                                                    .success,
                                                            isDismissible:
                                                                false);
                                                      } else if (result
                                                          is String) {
                                                        appSnackBar(
                                                          message: result,
                                                          messageType: MessageTypes
                                                              .connectivityOff,
                                                        );
                                                      } else {
                                                        appSnackBar(
                                                            message:
                                                                'update_Failed'
                                                                    .tr,
                                                            messageType:
                                                                MessageTypes
                                                                    .error,
                                                            isDismissible:
                                                                false);
                                                      }
                                                      loadingDataController
                                                          .update([
                                                        'card_loading_data'
                                                      ]);
                                                    },
                                                    child: Container(
                                                      height: 30.h,
                                                      width: 25.w,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.r)),
                                                        color: AppColor.white,
                                                        border: Border.all(
                                                            color: AppColor
                                                                .silverGray),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/image/refresh-circle.svg",
                                                            package:
                                                                'yousentech_pos_basic_data_management',
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            fit: BoxFit.fill,
                                                            width: 19.r,
                                                            height: 19.r,
                                                          ),
                                                          Text(
                                                            "Update_All".tr,
                                                            style: TextStyle(
                                                                fontSize: 10.r,
                                                                color: AppColor
                                                                    .black
                                                                    .withOpacity(
                                                                        0.4)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10.r,
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      var e = loaddata.entries
                                                          .firstWhere((element) =>
                                                              element.key ==
                                                              Loaddata
                                                                  .customers);
                                                      var result =
                                                          await displayDataDiffBasedOnModelType(
                                                              type: e.key
                                                                  .toString());
                                                      if (result is List &&
                                                          result.isNotEmpty) {
                                                        showCustomersDialog(
                                                            items: result);
                                                      } else if (result
                                                          is String) {
                                                        appSnackBar(
                                                          message: result,
                                                          messageType: MessageTypes
                                                              .connectivityOff,
                                                        );
                                                      } else {
                                                        appSnackBar(
                                                            message:
                                                                "empty_filter"
                                                                    .tr,
                                                            messageType:
                                                                MessageTypes
                                                                    .success);
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 30.h,
                                                      width: 25.w,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.r)),
                                                        color: AppColor.white,
                                                        border: Border.all(
                                                            color: AppColor
                                                                .silverGray),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/image/list-left.svg",
                                                            package:
                                                                'yousentech_pos_basic_data_management',
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            fit: BoxFit.fill,
                                                            width: 19.r,
                                                            height: 19.r,
                                                          ),
                                                          Text(
                                                            "display".tr,
                                                            style: TextStyle(
                                                                fontSize: 10.r,
                                                                color: AppColor
                                                                    .black
                                                                    .withOpacity(
                                                                        0.4)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10.r,
                                                  ),
                                                  Expanded(
                                                    child: GetBuilder<
                                                            LoadingDataController>(
                                                        id: "card_loading_data",
                                                        builder: (_) {
                                                          var localNumber = loadingDataController
                                                                  .itemdata
                                                                  .containsKey(Loaddata
                                                                      .customers
                                                                      .name
                                                                      .toString())
                                                              ? loadingDataController
                                                                      .itemdata[
                                                                  Loaddata
                                                                      .customers
                                                                      .name
                                                                      .toString()]['local']
                                                              : 0;
                                                          var remotNumber = loadingDataController
                                                                  .itemdata
                                                                  .containsKey(Loaddata
                                                                      .customers
                                                                      .name
                                                                      .toString())
                                                              ? loadingDataController
                                                                      .itemdata[
                                                                  Loaddata
                                                                      .customers
                                                                      .name
                                                                      .toString()]['remote']
                                                              : 0;

                                                          // var localNumber= 70;
                                                          // var remotNumber =50;
                                                          var per = (remotNumber >
                                                                  localNumber)
                                                              ? (localNumber /
                                                                      (remotNumber ==
                                                                              0
                                                                          ? 1
                                                                          : remotNumber)) *
                                                                  100
                                                              : (remotNumber /
                                                                      (localNumber ==
                                                                              0
                                                                          ? 1
                                                                          : localNumber)) *
                                                                  100;
                                                          return InkWell(
                                                            onTap: () async {
                                                              loadingDataController
                                                                  .isUpdate
                                                                  .value = true;
                                                              var e = loaddata
                                                                  .entries
                                                                  .firstWhere((element) =>
                                                                      element
                                                                          .key ==
                                                                      Loaddata
                                                                          .customers);

                                                              var result =
                                                                  await synchronizeBasedOnModelType(
                                                                      type: e
                                                                          .key
                                                                          .toString());
                                                              await customerController
                                                                  .getAllCustomerLocal(
                                                                      paging:
                                                                          true,
                                                                      type: "",
                                                                      pageselecteed:
                                                                          selectedpag);
                                                              loadingDataController
                                                                      .isUpdate
                                                                      .value =
                                                                  false;

                                                              if (result ==
                                                                  true) {
                                                                appSnackBar(
                                                                    message:
                                                                        'synchronized'
                                                                            .tr,
                                                                    messageType:
                                                                        MessageTypes
                                                                            .success,
                                                                    isDismissible:
                                                                        false);
                                                              } else if (result
                                                                  is String) {
                                                                appSnackBar(
                                                                  message:
                                                                      result,
                                                                  messageType:
                                                                      MessageTypes
                                                                          .connectivityOff,
                                                                );
                                                              } else if (result ==
                                                                  null) {
                                                                appSnackBar(
                                                                    message:
                                                                        'synchronization_problem'
                                                                            .tr,
                                                                    messageType:
                                                                        MessageTypes
                                                                            .success,
                                                                    isDismissible:
                                                                        false);
                                                              } else {
                                                                appSnackBar(
                                                                    message:
                                                                        'synchronized_successfully'
                                                                            .tr,
                                                                    messageType:
                                                                        MessageTypes
                                                                            .success,
                                                                    isDismissible:
                                                                        false);
                                                              }

                                                              loadingDataController
                                                                  .update([
                                                                'card_loading_data'
                                                              ]);
                                                              loadingDataController
                                                                  .update([
                                                                'loading'
                                                              ]);

                                                              loadingDataController
                                                                      .isUpdate
                                                                      .value =
                                                                  false;
                                                            },
                                                            child: Container(
                                                              height: 30.h,
                                                              width: 35.w,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10.r),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5.r)),
                                                                color: AppColor
                                                                    .white,
                                                                border: Border.all(
                                                                    color: AppColor
                                                                        .silverGray),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Container(
                                                                    width: 17.r,
                                                                    height:
                                                                        17.r,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: (per > 100 ||
                                                                              per <
                                                                                  100)
                                                                          ? AppColor
                                                                              .palePink
                                                                          : AppColor
                                                                              .lightGreen,
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Icon(
                                                                        (per > 100 ||
                                                                                per < 100)
                                                                            ? Icons.sync_problem
                                                                            : Icons.check,
                                                                        color: (per > 100 ||
                                                                                per < 100)
                                                                            ? AppColor.crimsonRed
                                                                            : AppColor.emeraldGreen,
                                                                        size: Get.width *
                                                                            0.01,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10.r,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      color: (per > 100 ||
                                                                              per <
                                                                                  100)
                                                                          ? AppColor
                                                                              .palePink
                                                                          : AppColor
                                                                              .lightGreen,
                                                                      child:
                                                                          RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          style: TextStyle(
                                                                              color: (per > 100 || per < 100) ? AppColor.crimsonRed : AppColor.emeraldGreen,
                                                                              fontFamily: 'Tajawal'),
                                                                          children: <TextSpan>[
                                                                            TextSpan(
                                                                              text: '${'synchronization'.tr} : ',
                                                                            ),
                                                                            // get the number
                                                                            TextSpan(
                                                                              text: '${per.toInt()} % ',
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 3.sp, fontFamily: 'Tajawal'),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: 10.r,
                                      ),
                                      searchBarController.text != "" &&
                                              customerController
                                                  .searchResults.isEmpty
                                          ? Expanded(
                                              child: Center(
                                                  child: AppNoDataWidge(
                                              message: "empty_filter".tr,
                                            )))
                                          : Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 20.r, right: 20.r),
                                                child: Column(
                                                  children: [
                                                    // Header
                                                    buildBasicDataColumnHeader(
                                                        data: customerHeader,
                                                        color:
                                                            AppColor.cyanTeal,
                                                        context: context),
                                                    SizedBox(
                                                      height: 2.r,
                                                    ),
                                                    // body
                                                    if (customerController
                                                        .searchResults
                                                        .isNotEmpty) ...[
                                                      if (customerController
                                                          .seachCustomerPagingList
                                                          .isNotEmpty) ...[
                                                        buildCustomerBodyTable(
                                                            customerController:
                                                                customerController,
                                                            selectedpag:
                                                                selectedpag,
                                                            startIndex:
                                                                pagnationController
                                                                        .text
                                                                        .isEmpty
                                                                    ? null
                                                                    : int.parse(
                                                                        pagnationController
                                                                            .text)
                                                            // pagnationController.text.isEmpty?null: skip
                                                            )
                                                      ]
                                                    ] else if (customerController
                                                        .searchResults
                                                        .isEmpty) ...[
                                                      if (customerController
                                                          .customerpagingList
                                                          .isNotEmpty) ...[
                                                        buildCustomerBodyTable(
                                                            customerController:
                                                                customerController,
                                                            selectedpag:
                                                                selectedpag,
                                                            startIndex:
                                                                pagnationController
                                                                        .text
                                                                        .isEmpty
                                                                    ? null
                                                                    : int.parse(
                                                                        pagnationController
                                                                            .text)
                                                            // pagnationController.text.isEmpty?null: skip
                                                            )
                                                      ]
                                                    ],
                                                    if (customerController
                                                        .searchResults
                                                        .isNotEmpty) ...[
                                                      if (customerController
                                                          .seachCustomerPagingList
                                                          .isEmpty) ...[
                                                        Expanded(
                                                            child: Center(
                                                                child:
                                                                    AppNoDataWidge(
                                                          message:
                                                              "empty_filter".tr,
                                                        )))
                                                      ]
                                                    ] else if (customerController
                                                        .searchResults
                                                        .isEmpty) ...[
                                                      if (customerController
                                                          .customerpagingList
                                                          .isEmpty) ...[
                                                        Expanded(
                                                            child: Center(
                                                                child:
                                                                    AppNoDataWidge(
                                                          message:
                                                              "empty_filter".tr,
                                                        )))
                                                      ]
                                                    ],

                                                    // buildCustomerBodyTable(
                                                    //     customerController:
                                                    //         customerController,
                                                    //     selectedpag:
                                                    //         selectedpag,
                                                    //     startIndex:
                                                    //         pagnationController
                                                    //                 .text
                                                    //                 .isEmpty
                                                    //             ? null
                                                    //             : int.parse(
                                                    //                 pagnationController
                                                    //                     .text)
                                                    //     // pagnationController.text.isEmpty?null: skip
                                                    //     )
                                                  ],
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                ),

                                GetBuilder<LoadingDataController>(
                                    id: "pagin",
                                    builder: (controller) {
                                      var datatBaseLenght = customerController
                                              .searchResults.isNotEmpty
                                          ? customerController
                                              .searchResults.length
                                          : searchBarController.text != "" &&
                                                  customerController
                                                      .searchResults.isEmpty
                                              ? 0
                                              : loadingDataController.itemdata[
                                                  Loaddata.customers.name
                                                      .toString()]['local'];
                                      // print("datatBaseLenght $datatBaseLenght");
                                      int dataStart = pagnationController
                                              .text.isEmpty
                                          ? (customerController.limit *
                                                  (selectedpag + 1)) -
                                              (customerController.limit - 1)
                                          : int.parse(pagnationController.text);
                                      // print("dataStart $dataStart");
                                      pagnationController.text =
                                          dataStart.toString();
                                      pagesNumber = (datatBaseLenght ~/
                                              customerController.limit) +
                                          (datatBaseLenght %
                                                      customerController
                                                          .limit !=
                                                  0
                                              ? 1
                                              : 0);

                                      var datadisplayLenght =
                                          (int.parse(pagnationController.text) +
                                                      customerController
                                                          .limit) <
                                                  datatBaseLenght
                                              ? ((int.parse(pagnationController
                                                          .text) +
                                                      customerController
                                                          .limit) -
                                                  1)
                                              : datatBaseLenght;
                                      return datatBaseLenght != 0
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: (Get.height * 0.2),
                                                height: Get.height * 0.03,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          AppColor.silverGray),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5.r),
                                                  child: Row(
                                                    // mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      InkWell(
                                                        onTap: dataStart > 1
                                                            ? () async {
                                                                if (dataStart <=
                                                                    customerController
                                                                        .limit) {
                                                                  await customerController.getAllCustomerLocal(
                                                                      paging:
                                                                          true,
                                                                      type:
                                                                          "prefix",
                                                                      countSkip:
                                                                          0);
                                                                  selectedpag =
                                                                      0;
                                                                  pagnationController
                                                                          .text =
                                                                      "1";
                                                                } else {
                                                                  await customerController
                                                                      .getAllCustomerLocal(
                                                                    paging:
                                                                        true,
                                                                    type:
                                                                        "prefix",
                                                                  );
                                                                  selectedpag--;
                                                                  pagnationController
                                                                      .text = ((customerController.limit *
                                                                              (selectedpag +
                                                                                  1)) -
                                                                          (customerController.limit -
                                                                              1))
                                                                      .toString();
                                                                }
                                                              }
                                                            : null,
                                                        child: SvgPicture.asset(
                                                          SharedPr.lang == "ar"
                                                              ? "assets/image/arrow_right.svg"
                                                              : "assets/image/arrow_left.svg",
                                                          package:
                                                              'yousentech_pos_basic_data_management',
                                                          color: dataStart <= 1
                                                              ? AppColor
                                                                  .silverGray
                                                              : null,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      SizedBox(
                                                        height: 10.r,
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: <TextSpan>[
                                                              // Lenght data in DB
                                                              TextSpan(
                                                                text:
                                                                    "$datatBaseLenght / ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        6.5.r,
                                                                    color: AppColor
                                                                        .lavenderGray,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontFamily:
                                                                        'Tajawal'),
                                                              ),
                                                              // Lenght show in screen in
                                                              TextSpan(
                                                                text:
                                                                    "$datadisplayLenght -",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        6.5.r,
                                                                    color: AppColor
                                                                        .black
                                                                        .withOpacity(
                                                                            0.5),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontFamily:
                                                                        'Tajawal'),
                                                              ),
                                                              // TextSpan(
                                                              //   text: "$dataStart",
                                                              //   style: TextStyle(
                                                              //       fontSize: 6.5.r,
                                                              //       color: AppColor.black
                                                              //           .withOpacity(0.5),
                                                              //       fontWeight: FontWeight.w400,
                                                              //       fontFamily: 'Tajawal'),
                                                              // ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 10.r,
                                                          width: 40.r,
                                                          child: TextField(
                                                            style: TextStyle(
                                                              fontSize: 6.5.r,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              // fontWeight: FontWeight.bold
                                                            ),
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly, // Only digits allowed
                                                            ],
                                                            decoration:
                                                                InputDecoration(
                                                              isDense:
                                                                  true, // Reduces the padding inside the TextField
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          2.r), // Set padding to zero or adjust
                                                              border: InputBorder
                                                                  .none, // Remove the border if not needed
                                                            ),
                                                            controller:
                                                                pagnationController,
                                                            onSubmitted:
                                                                (value) async {
                                                              int? countSkip;
                                                              if (value
                                                                  .isEmpty) {
                                                                pagnationController
                                                                        .text =
                                                                    (1).toString();
                                                                countSkip = 0;
                                                                selectedpag = 0;
                                                              } else if (value
                                                                  .isNotEmpty) {
                                                                var pageselecteed = (int.parse(
                                                                            value) /
                                                                        customerController
                                                                            .limit)
                                                                    .ceilToDouble();
                                                                selectedpag =
                                                                    pageselecteed
                                                                            .toInt() -
                                                                        1;
                                                                if (int.parse(
                                                                        value) >
                                                                    datatBaseLenght) {
                                                                  // pagnationController.text = (datatBaseLenght).toString();
                                                                  // countSkip = datatBaseLenght -1;
                                                                  pagnationController
                                                                          .text =
                                                                      (1).toString();
                                                                  countSkip = 0;
                                                                  selectedpag =
                                                                      0;
                                                                } else if (int
                                                                        .parse(
                                                                            value) <=
                                                                    1) {
                                                                  pagnationController
                                                                          .text =
                                                                      (1).toString();
                                                                  countSkip = 0;
                                                                  selectedpag =
                                                                      0;
                                                                } else {
                                                                  countSkip =
                                                                      int.parse(
                                                                              value) -
                                                                          1;
                                                                }
                                                              }

                                                              customerController
                                                                  .update();
                                                              await customerController
                                                                  .getAllCustomerLocal(
                                                                      paging:
                                                                          true,
                                                                      type: "",
                                                                      countSkip:
                                                                          countSkip,
                                                                      pageselecteed:
                                                                          selectedpag);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: pagesNumber >
                                                                (selectedpag +
                                                                    1)
                                                            ? () async {
                                                                int prefixData =
                                                                    int.parse(
                                                                        pagnationController
                                                                            .text);
                                                                skip = (prefixData +
                                                                    (customerController
                                                                            .limit -
                                                                        1));
                                                                pagnationController
                                                                    .text = (skip +
                                                                        1)
                                                                    .toString();

                                                                await customerController
                                                                    .getAllCustomerLocal(
                                                                        paging:
                                                                            true,
                                                                        type:
                                                                            "suffix",
                                                                        // countSkip: pagnationController.text.isEmpty? null : (int.parse(pagnationController.text) )-1
                                                                        countSkip:
                                                                            skip);
                                                                selectedpag++;
                                                              }
                                                            : null,
                                                        child: SvgPicture.asset(
                                                          SharedPr.lang == "ar"
                                                              ? "assets/image/arrow_left.svg"
                                                              : "assets/image/arrow_right.svg",
                                                          package:
                                                              'yousentech_pos_basic_data_management',
                                                          color: pagesNumber >
                                                                  (selectedpag +
                                                                      1)
                                                              ? null
                                                              : AppColor
                                                                  .silverGray,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink();
                                    }),

                                // GetBuilder<LoadingDataController>(
                                //     id: "pagin",
                                //     builder: (controller) {
                                //       var dataResultLenght = customerController
                                //               .searchResults.isNotEmpty
                                //           ? customerController.searchResults.length
                                //           : loadingDataController.itemdata[Loaddata.customers.name.toString()]['local'];
                                //       pagesNumber = (dataResultLenght ~/
                                //               customerController.limit) +
                                //           (dataResultLenght %
                                //                       customerController
                                //                           .limit !=
                                //                   0
                                //               ? 1
                                //               : 0);
                                //       // var remainderDivision = dataResultLenght % customerController.limit;
                                //       // print("hh $remainderDivision");
                                //       return loadingDataController.itemdata.containsKey(Loaddata.customers.name)
                                //           ? ((dataResultLenght ~/
                                //                           customerController
                                //                               .limit) +
                                //                       (dataResultLenght %
                                //                                   customerController
                                //                                       .limit !=
                                //                               0
                                //                           ? 1
                                //                           : 0)) >
                                //                   10
                                //               ? Container(
                                //                   width: (Get.height * 0.2),
                                //                   height: Get.height * 0.03,
                                //                   decoration: BoxDecoration(
                                //                     color: AppColor.cyanTeal,
                                //                     // AppColor.shadepurple,
                                //                     borderRadius:
                                //                         BorderRadius.circular(
                                //                             50),
                                //                   ),
                                //                   padding:
                                //                       const EdgeInsets.all(5),
                                //                   child: InputQty(
                                //                     btnColor2: AppColor.white,
                                //                     qtyFormProps: QtyFormProps(
                                //                         cursorColor:
                                //                             AppColor.white,
                                //                         style: TextStyle(
                                //                             fontSize:
                                //                                 Get.height *
                                //                                     0.015,
                                //                             color:
                                //                                 AppColor.white,
                                //                             fontWeight:
                                //                                 FontWeight
                                //                                     .bold)),
                                //                     decoration:
                                //                         QtyDecorationProps(
                                //                             minusBtn: Icon(
                                //                               Icons.remove,
                                //                               size: Get.height *
                                //                                   0.02,
                                //                               color: AppColor
                                //                                   .white,
                                //                             ),
                                //                             plusBtn: Icon(
                                //                               Icons.add,
                                //                               size: Get.height *
                                //                                   0.02,
                                //                               color: AppColor
                                //                                   .white,
                                //                             ),
                                //                             btnColor:
                                //                                 AppColor.white,
                                //                             borderShape:
                                //                                 BorderShapeBtn
                                //                                     .circle,
                                //                             border: InputBorder
                                //                                 .none),
                                //                     maxVal: ((dataResultLenght ~/
                                //                             customerController
                                //                                 .limit) +
                                //                         (dataResultLenght %
                                //                                     customerController
                                //                                         .limit !=
                                //                                 0
                                //                             ? 1
                                //                             : 0)),
                                //                     initVal: selectedpag + 1,
                                //                     minVal: 1,
                                //                     steps: 1,
                                //                     onQtyChanged: (val) async {
                                //                       int value;
                                //                       if (val is double) {
                                //                         value = val.toInt();
                                //                       } else {
                                //                         value = val;
                                //                       }
                                //                       selectedpag = value - 1;

                                //                       await customerController
                                //                           .getAllCustomerLocal(
                                //                               paging: true,
                                //                               type: "",
                                //                               pageselecteed:selectedpag);
                                //                     },
                                //                   ),
                                //                 )
                                //               : SingleChildScrollView(
                                //                   scrollDirection:
                                //                       Axis.horizontal,
                                //                   child: Row(
                                //                     mainAxisAlignment:
                                //                         MainAxisAlignment
                                //                             .center,
                                //                     children: [
                                //                       if (customerController
                                //                               .hasLess.value &&
                                //                           pagesNumber != 1) ...[
                                //                         InkWell(
                                //                             onTap: () async {
                                //                               await customerController
                                //                                   .getAllCustomerLocal(
                                //                                 paging: true,
                                //                                 type: "prefix",
                                //                               );
                                //                               selectedpag--;
                                //                             },
                                //                             child: Container(
                                //                               padding:
                                //                                   const EdgeInsets
                                //                                       .all(5),
                                //                               decoration: BoxDecoration(
                                //                                   shape: BoxShape
                                //                                       .circle,
                                //                                   color: AppColor
                                //                                       .greyWithOpcity),
                                //                               child: Icon(
                                //                                 Icons
                                //                                     .arrow_back_ios,
                                //                                 size:
                                //                                     Get.height *
                                //                                         0.03,
                                //                               ),
                                //                             ))
                                //                       ],
                                //                       if (pagesNumber != 1) ...[
                                //                         SizedBox(
                                //                           width: ((dataResultLenght ~/
                                //                                       customerController
                                //                                           .limit) +
                                //                                   (dataResultLenght %
                                //                                               customerController
                                //                                                   .limit !=
                                //                                           0
                                //                                       ? 1
                                //                                       : 0)) *
                                //                               (Get.height *
                                //                                   0.045),
                                //                           height:
                                //                               Get.height * 0.04,
                                //                           child:
                                //                               ListView.builder(
                                //                                   scrollDirection:
                                //                                       Axis
                                //                                           .horizontal,
                                //                                   itemCount: (dataResultLenght ~/
                                //                                           customerController
                                //                                               .limit) +
                                //                                       (dataResultLenght % customerController.limit !=
                                //                                               0
                                //                                           ? 1
                                //                                           : 0),
                                //                                   itemBuilder:
                                //                                       (BuildContext
                                //                                               context,
                                //                                           int index) {
                                //                                     // print(index);
                                //                                     return InkWell(
                                //                                       onTap:
                                //                                           () async {
                                //                                         selectedpag =
                                //                                             index;
                                //                                         // print(
                                //                                         //     "selectedpag : $selectedpag");
                                //                                         await customerController.getAllCustomerLocal(
                                //                                             paging:
                                //                                                 true,
                                //                                             type:
                                //                                                 "",
                                //                                             pageselecteed:
                                //                                                 selectedpag);
                                //                                       },
                                //                                       child: Container(
                                //                                           margin: const EdgeInsets.symmetric(horizontal: 2),
                                //                                           padding: const EdgeInsets.all(2),
                                //                                           decoration: BoxDecoration(
                                //                                             shape:
                                //                                                 BoxShape.circle,
                                //                                             color: index == selectedpag
                                //                                                 ? AppColor.cyanTeal
                                //                                                 : AppColor.greyWithOpcity,
                                //                                           ),
                                //                                           alignment: Alignment.center,
                                //                                           width: Get.height * 0.04,
                                //                                           height: Get.height * 0.04,
                                //                                           child: Text("${index + 1}",
                                //                                               style: TextStyle(
                                //                                                 fontSize: Get.height * 0.02,
                                //                                                 color: index == selectedpag ? AppColor.white : AppColor.black,
                                //                                               ))),
                                //                                     );
                                //                                   }),
                                //                         ),
                                //                       ],
                                //                       if (customerController
                                //                               .hasMore.value &&
                                //                           pagesNumber != 1) ...[
                                //                         InkWell(
                                //                             onTap: () async {
                                //                               await customerController
                                //                                   .getAllCustomerLocal(
                                //                                       paging:
                                //                                           true,
                                //                                       type:
                                //                                           "suffix");
                                //                               selectedpag++;
                                //                             },
                                //                             child: Container(
                                //                                 padding:
                                //                                     const EdgeInsets
                                //                                         .all(5),
                                //                                 decoration: BoxDecoration(
                                //                                     shape: BoxShape
                                //                                         .circle,
                                //                                     color: AppColor
                                //                                         .greyWithOpcity),
                                //                                 child: Icon(
                                //                                   Icons
                                //                                       .arrow_forward_ios,
                                //                                   size:
                                //                                       Get.height *
                                //                                           0.03,
                                //                                 )))
                                //                       ],
                                //                     ],
                                //                   ),
                                //                 )
                                //           : Container();
                                //     })
                              ],
                            ),
                          ),
                        )
                      : AddCustomerScreen(
                          objectToEdit: customerController.object,
                        );
                }),
            Obx(() {
              if (loadingDataController.isUpdate.value ||
                  loadingDataController.isRefresh.value) {
                return const LoadingWidget();
              } else {
                return const SizedBox
                    .shrink(); // Return an empty widget when not loading
              }
            })
          ],
        ),
      ),
    );
  }
}
