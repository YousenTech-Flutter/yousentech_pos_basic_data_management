// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_enum.dart';
import 'package:shared_widgets/shared_widgets/app_dialog.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_no_data.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/mac_address_helper.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos_categories/domain/pos_category_service.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos_categories/presentation/views/add_edit_pos_category_screen.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/pos_categories/presentation/widgets/show_category.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/define_type_function.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/config/app_enums.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/config/app_list.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_viewmodel.dart';
import '../../../products/presentation/widget/tital.dart';
import '../../domain/pos_category_viewmodel.dart';

class PosCategoryListScreen extends StatefulWidget {
  const PosCategoryListScreen({super.key});

  @override
  State<PosCategoryListScreen> createState() => _PosCategoryListScreenState();
}

class _PosCategoryListScreenState extends State<PosCategoryListScreen> {
  // Initialize the posCategoryController using Get.put or Get.find
  late final PosCategoryController posCategoryController;
  TextEditingController searchBarController = TextEditingController();
  LoadingDataController loadingDataController = Get.find<LoadingDataController>();
  @override
  void initState() {
    super.initState();
    PosCategoryService.posCategoryDataServiceInstance = null;
    PosCategoryService.getInstance();
    posCategoryController =
        Get.put(PosCategoryController(), tag: 'categoryControllerMain');
    categoriesData();
  }

  @override
  void dispose() {
    searchBarController.dispose();
    posCategoryController.searchResults.clear();
    super.dispose();
  }

  Future categoriesData() async {
    await posCategoryController.categoriesData();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: loadingDataController.isUpdate.value,
      child: Container(
        color: AppColor.dashbordcolor,
        child: Stack(
          children: [
            GetBuilder<PosCategoryController>(
                tag: 'categoryControllerMain',
                builder: (controller) {
                  return
                      // !posCategoryController.hideMainScreen.value
                      //     ?
                      Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TitalWidget(
                          title: 'pos_category_list',
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10.r, left: 20.r, right: 20.r),
                          child: Row(
                            // mainAxisAlignment:
                            //     MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        bool isTrustedDevice =
                                            await MacAddressHelper
                                                .isTrustedDevice();
                                        if (isTrustedDevice) {
                                          posCategoryController
                                              .updateHideMenu(true);
                                          CustomDialog.getInstance().dialog2(
                                              color: AppColor.dashbordcolor,
                                              colorBorderSide:
                                                  AppColor.cyanTeal,
                                              addCancelButton: false,
                                              // height: 270.h,
                                              // width: 0.5.sw,
                                              height: 300.h,
                                              width: 0.4.sw,
                                              title: '',
                                              context: context,
                                              content: AddPosCategoryScreen(
                                                objectToEdit:
                                                    posCategoryController
                                                        .object,
                                              ));
                                        }
                                      },
                                      child: Container(
                                        height: 30.h,
                                        width: 15.w,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.r)),
                                          color: AppColor.white,
                                          border: Border.all(
                                              color: AppColor.silverGray),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/image/add_categry.svg",
                                            package:
                                                'yousentech_pos_basic_data_management',
                                            clipBehavior: Clip.antiAlias,
                                            fit: BoxFit.fill,
                                            width: 19.r,
                                            height: 19.r,
                                            color:
                                                AppColor.amber.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.r,
                                    ),
                                    Expanded(
                                      child: ContainerTextField(
                                        controller: searchBarController,
                                        height: 30.h,
                                        labelText: '',
                                        hintText: 'search'.tr,
                                        fontSize: 10.r,
                                        fillColor: AppColor.white,
                                        borderColor: AppColor.silverGray,
                                        hintcolor:
                                            AppColor.black.withOpacity(0.5),
                                        isAddOrEdit: true,
                                        borderRadius: 5.r,
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.r, vertical: 5.r),
                                          child: SvgPicture.asset(
                                            "assets/image/search_quick.svg",
                                            package:
                                                'yousentech_pos_basic_data_management',
                                            width: 19.r,
                                            height: 19.r,
                                          ),
                                        ),
                                        suffixIcon: searchBarController
                                                .text.isNotEmpty
                                            ? IconButton(
                                                onPressed: () async {
                                                  searchBarController.text = '';
                                                  posCategoryController
                                                      .searchResults
                                                      .clear();
                                                  posCategoryController
                                                      .update();
                                                },
                                                icon: Icon(
                                                  Icons.cancel_outlined,
                                                  color: AppColor.grey
                                                      .withOpacity(0.7),
                                                ))
                                            : null,
                                        onChanged: (text) async {
                                          if (searchBarController.text == '') {
                                            posCategoryController.searchResults
                                                .clear();
                                            posCategoryController.update();
                                          } else {
                                            posCategoryController.search(
                                                searchBarController.text);
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
                                    InkWell(
                                      onTap: () async {
                                        var e = loaddata.entries.firstWhere(
                                            (element) =>
                                                element.key ==
                                                Loaddata.categories);
                                        var result = await loadingDataController
                                            .updateAll(name: e.key.toString());
                                        if (result == true) {
                                          appSnackBar(
                                              message: 'update_success'.tr,
                                              messageType: MessageTypes.success,
                                              isDismissible: false);
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
                                              isDismissible: false);
                                        }
                                        loadingDataController
                                            .update(['card_loading_data']);
                                      },
                                      child: Container(
                                        height: 30.h,
                                        width: 30.w,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.r)),
                                          color: AppColor.white,
                                          border: Border.all(
                                              color: AppColor.silverGray),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/image/refresh-circle.svg",
                                              package:
                                                  'yousentech_pos_basic_data_management',
                                              clipBehavior: Clip.antiAlias,
                                              fit: BoxFit.fill,
                                              width: 19.r,
                                              height: 19.r,
                                            ),
                                            Text(
                                              "Update_All".tr,
                                              style: TextStyle(
                                                  fontSize: 10.r,
                                                  color: AppColor.black
                                                      .withOpacity(0.4)),
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
                                        loadingDataController.isUpdate.value =
                                            true;
                                        var e = loaddata.entries.firstWhere(
                                            (element) =>
                                                element.key ==
                                                Loaddata.categories);

                                        var result =
                                            await displayDataDiffBasedOnModelType(
                                                type: e.key.toString());
                                        if (result is List &&
                                            result.isNotEmpty) {
                                          showCategorysDialog(items: result);
                                        } else if (result is String) {
                                          appSnackBar(
                                            message: result,
                                            messageType:
                                                MessageTypes.connectivityOff,
                                          );
                                        } else {
                                          appSnackBar(
                                              message: "empty_filter".tr,
                                              messageType:
                                                  MessageTypes.success);
                                        }

                                        loadingDataController.isUpdate.value =
                                            false;
                                      },
                                      child: Container(
                                        height: 30.h,
                                        width: 25.w,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.r)),
                                          color: AppColor.white,
                                          border: Border.all(
                                              color: AppColor.silverGray),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/image/list-left.svg",
                                              package:
                                                  'yousentech_pos_basic_data_management',
                                              clipBehavior: Clip.antiAlias,
                                              fit: BoxFit.fill,
                                              width: 19.r,
                                              height: 19.r,
                                            ),
                                            Text(
                                              "display".tr,
                                              style: TextStyle(
                                                  fontSize: 10.r,
                                                  color: AppColor.black
                                                      .withOpacity(0.4)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.r,
                                    ),
                                    Expanded(
                                      child: GetBuilder<LoadingDataController>(
                                          id: "card_loading_data",
                                          builder: (_) {
                                            var localNumber =
                                                loadingDataController.itemdata
                                                        .containsKey(Loaddata
                                                            .categories.name
                                                            .toString())
                                                    ? loadingDataController
                                                                .itemdata[
                                                            Loaddata
                                                                .categories.name
                                                                .toString()]
                                                        ['local']
                                                    : 0;
                                            var remotNumber =
                                                loadingDataController.itemdata
                                                        .containsKey(Loaddata
                                                            .categories.name
                                                            .toString())
                                                    ? loadingDataController
                                                                .itemdata[
                                                            Loaddata
                                                                .categories.name
                                                                .toString()]
                                                        ['remote']
                                                    : 0;
                                            // var localNumber= 70;
                                            // var remotNumber =50;
                                            var per = (remotNumber >
                                                    localNumber)
                                                ? (localNumber /
                                                        (remotNumber == 0
                                                            ? 1
                                                            : remotNumber)) *
                                                    100
                                                : (remotNumber /
                                                        (localNumber == 0
                                                            ? 1
                                                            : localNumber)) *
                                                    100;
                                            return InkWell(
                                              onTap: () async {
                                                loadingDataController
                                                    .isUpdate.value = true;

                                                var e = loaddata.entries
                                                    .firstWhere((element) =>
                                                        element.key ==
                                                        Loaddata.categories);
                                                var result =
                                                    await synchronizeBasedOnModelType(
                                                        type: e.key.toString());
                                                if (result == true) {
                                                  appSnackBar(
                                                      message:
                                                          'synchronized'.tr,
                                                      messageType:
                                                          MessageTypes.success,
                                                      isDismissible: false);
                                                } else if (result is String) {
                                                  appSnackBar(
                                                    message: result,
                                                    messageType: MessageTypes
                                                        .connectivityOff,
                                                  );
                                                } else if (result == false) {
                                                  appSnackBar(
                                                      message:
                                                          'synchronized_successfully'
                                                              .tr,
                                                      messageType:
                                                          MessageTypes.success,
                                                      isDismissible: false);
                                                } else {
                                                  appSnackBar(
                                                      message:
                                                          'synchronization_problem'
                                                              .tr,
                                                      messageType:
                                                          MessageTypes.success,
                                                      isDismissible: false);
                                                }
                                                loadingDataController
                                                    .isUpdate.value = false;
                                                loadingDataController.update(
                                                    ['card_loading_data']);
                                                loadingDataController
                                                    .update(['loading']);
                                              },
                                              child: Container(
                                                height: 30.h,
                                                width: 35.w,
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.r),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5.r)),
                                                  color: AppColor.white,
                                                  border: Border.all(
                                                      color:
                                                          AppColor.silverGray),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      width: 17.r,
                                                      height: 17.r,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: (per > 100 ||
                                                                per < 100)
                                                            ? AppColor.palePink
                                                            : AppColor
                                                                .lightGreen,
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          (per > 100 ||
                                                                  per < 100)
                                                              ? Icons
                                                                  .sync_problem
                                                              : Icons.check,
                                                          color: (per > 100 ||
                                                                  per < 100)
                                                              ? AppColor
                                                                  .crimsonRed
                                                              : AppColor
                                                                  .emeraldGreen,
                                                          size:
                                                              Get.width * 0.01,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.r,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        color: (per > 100 ||
                                                                per < 100)
                                                            ? AppColor.palePink
                                                            : AppColor
                                                                .lightGreen,
                                                        child: RichText(
                                                          text: TextSpan(
                                                            style: TextStyle(
                                                                color: (per >
                                                                            100 ||
                                                                        per <
                                                                            100)
                                                                    ? AppColor
                                                                        .crimsonRed
                                                                    : AppColor
                                                                        .emeraldGreen,
                                                                fontFamily:
                                                                    'Tajawal',package: 'yousentech_pos_basic_data_management'),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text:
                                                                    '${'synchronization'.tr} : ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10.r,
                                                                    fontFamily:
                                                                        'Tajawal',package: 'yousentech_pos_basic_data_management'),
                                                              ),
                                                              // get the number
                                                              TextSpan(
                                                                text:
                                                                    '${per.toInt()} % ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10.r,
                                                                    fontFamily:
                                                                        'Tajawal',package: 'yousentech_pos_basic_data_management'),
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
                                posCategoryController.searchResults.isEmpty
                            ? Expanded(
                                child: Center(
                                    child: AppNoDataWidge(
                                message: "empty_filter".tr,
                              )))
                            : posCategoryController.posCategoryList.isNotEmpty
                                ? Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.r, right: 20.r),
                                      child: Wrap(
                                        spacing: 10.r,
                                        runSpacing: 10.r,
                                        children: [
                                          ...List.generate(
                                              posCategoryController
                                                      .searchResults.isNotEmpty
                                                  ? posCategoryController
                                                      .searchResults.length
                                                  : posCategoryController
                                                      .posCategoryList
                                                      .length, (index) {
                                            var item = posCategoryController
                                                    .searchResults.isNotEmpty
                                                ? posCategoryController
                                                    .searchResults[index]
                                                : posCategoryController
                                                    .posCategoryList[index];
                                            return Container(
                                              width: 80.w,
                                              height: 90.h,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColor.softIceBlue,
                                                    blurRadius: 60,
                                                    offset: const Offset(0, 10),
                                                    spreadRadius: 0,
                                                  )
                                                ],
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(5.r),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  5.r),
                                                          decoration: BoxDecoration(
                                                              color: AppColor
                                                                  .amber
                                                                  .withOpacity(
                                                                      0.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.r)),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0.r),
                                                            child: SvgPicture.asset(
                                                                "assets/image/categories_menu_icon.svg",
                                                                package:
                                                                    'yousentech_pos_basic_data_management',
                                                                width: 12.r,
                                                                height: 12.r,
                                                                color: AppColor
                                                                    .white),
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                item
                                                                    .getPosCategoryNameBasedOnLang,
                                                                style:
                                                                    TextStyle(
                                                                  color: AppColor
                                                                      .gunmetalGray,
                                                                  fontSize:
                                                                      10.r,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                )),
                                                            // if(item.getPosParentCategoryNameBasedOnLang != null)
                                                            // Text(item.getPosParentCategoryNameBasedOnLang!,
                                                            //     style:
                                                            //     TextStyle(
                                                            //       color: AppColor
                                                            //           .gunmetalGray,
                                                            //       fontSize:
                                                            //       10.r,
                                                            //       fontWeight:
                                                            //       FontWeight
                                                            //           .w700,
                                                            //     )),
                                                            if (item.getPosParentCategoryNameBasedOnLang !=
                                                                null)
                                                              Text(
                                                                // '(${"No".tr} : ${(index + 1).toString()} )',
                                                                '(parent  : ${item.getPosParentCategoryNameBasedOnLang ?? ""} )',
                                                                style:
                                                                    TextStyle(
                                                                  color: AppColor
                                                                      .lavenderGray,
                                                                  fontSize: 8.r,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .centerEnd,
                                                      child: InkWell(
                                                        onTap: () {
                                                          posCategoryController
                                                              .object = item;

                                                          posCategoryController
                                                              .updateHideMenu(
                                                                  true);
                                                          CustomDialog
                                                                  .getInstance()
                                                              .dialog2(
                                                                  color: AppColor
                                                                      .dashbordcolor,
                                                                  colorBorderSide:
                                                                      AppColor
                                                                          .cyanTeal,
                                                                  addCancelButton:
                                                                      false,
                                                                  height: 300.h,
                                                                  width: 0.4.sw,
                                                                  title: '',
                                                                  context:
                                                                      context,
                                                                  content:
                                                                      AddPosCategoryScreen(
                                                                    objectToEdit:
                                                                        posCategoryController
                                                                            .object,
                                                                  ));
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  5.r),
                                                          decoration: BoxDecoration(
                                                              color: AppColor
                                                                  .gainsborolite,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.r)),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0.r),
                                                            child: SvgPicture.asset(
                                                                "assets/image/edit.svg",
                                                                package:
                                                                    'yousentech_pos_basic_data_management',
                                                                width: 15.r,
                                                                height: 15.r,
                                                                color: AppColor
                                                                    .darkGray2),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                      // child: Column(
                                      //   children: [
                                      //     // Header
                                      // buildBasicDataColumnHeader(
                                      //     data: posCategHeader,
                                      //     context: context),
                                      //     // body
                                      //     buildPosCategoreBodyTable(
                                      //         posCategoryController:
                                      //             posCategoryController)
                                      //   ],
                                      // ),
                                    ),
                                  )
                                : Expanded(
                                    child: Center(
                                        child: AppNoDataWidge(
                                    message: "empty_filter".tr,
                                  )))
                      ],
                    ),
                  );
                  // : AddPosCategoryScreen(
                  //     objectToEdit: posCategoryController.object,
                  //   );
                }),
            Obx(() {
              if (loadingDataController.isUpdate.value) {
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
