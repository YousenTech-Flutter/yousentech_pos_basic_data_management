// import 'package:flutter/material.dart';
//   
// import 'package:flutter_svg/svg.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:shared_widgets/config/app_colors.dart';
// import 'package:shared_widgets/shared_widgets/app_no_data.dart';
// import 'package:shared_widgets/shared_widgets/app_text_field.dart';
// import 'package:yousentech_pos_basic_data_management/basic_data_management/config/app_list.dart';
// import 'package:yousentech_pos_basic_data_management/basic_data_management/src/account_tax/utils/build_body_table.dart';
// import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/widget/tital.dart';
// import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/build_basic_data_table.dart';
// import '../domain/account_tax_service.dart';
// import '../domain/account_tax_viewmodel.dart';

// class PosAccountTaxListScreen extends StatefulWidget {
//   const PosAccountTaxListScreen({super.key});

//   @override
//   State<PosAccountTaxListScreen> createState() =>
//       _PosAccountTaxListScreenState();
// }

// class _PosAccountTaxListScreenState extends State<PosAccountTaxListScreen> {
//   // Initialize the controller using Get.put or Get.find
//   late final AccountTaxController posAccountTaxController;
//   TextEditingController searchBarController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     AccountTaxService.accountTaxDataServiceInstance = null;
//     AccountTaxService.getInstance();
//     posAccountTaxController = Get.put(AccountTaxController());
//   }

//   @override
//   void dispose() {
//     searchBarController.dispose();
//     posAccountTaxController.searchResults.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AccountTaxController>(builder: (controller) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TitalWidget(
//             title: 'pos_account_tax_list'.tr,
//           ),
//           Container(
//             margin: EdgeInsets.only(top: 10.r, left: 20.r, right: 20.r),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ContainerTextField(
//                   controller: searchBarController,
//                   height: 30.h,
//                   labelText: '',
//                   hintText: 'search'.tr,
//                   fontSize: 10.r,
//                   fillColor: AppColor.white,
//                   borderColor: AppColor.silverGray,
//                   hintcolor: AppColor.black.withOpacity(0.5),
//                   isAddOrEdit: true,
//                   borderRadius: 5.r,
//                   prefixIcon: Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 5.r, vertical: 5.r),
//                     child: SvgPicture.asset(
//                       "assets/image/search_quick.svg",
//                       package: 'yousentech_pos_basic_data_management',
//                       width: 19.r,
//                       height: 19.r,
//                     ),
//                   ),
//                   suffixIcon: searchBarController.text.isNotEmpty
//                       ? InkWell(
//                           onTap: () async {
//                             searchBarController.text = '';
//                             controller.searchResults.clear();
//                             controller.update();
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 5.r, vertical: 10.r),
//                             child: FaIcon(FontAwesomeIcons.circleXmark,
//                                 color: AppColor.red, size: 10.r),
//                           ),
//                         )
//                       : null,
//                   onChanged: (text) async {
//                     if (searchBarController.text == '') {
//                       controller.searchResults.clear();
//                       controller.update();
//                     } else {
//                       controller.search(searchBarController.text);
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 10.r,
//           ),
//           searchBarController.text != "" && controller.searchResults.isEmpty
//               ? Expanded(
//                   child: Center(
//                       child: AppNoDataWidge(
//                   message: "empty_filter".tr,
//                 )))
//               : Expanded(
//                   child: controller.accountTaxList.isNotEmpty
//                       ? Container(
//                           margin: EdgeInsets.only(left: 20.r, right: 20.r),
//                           child: Column(
//                             children: [
//                               buildBasicDataColumnHeader(
//                                   data: taxHeader,
//                                   color: AppColor.cyanTeal,
//                                   addEmpty: false,
//                                   context: context),
//                               SizedBox(
//                                 height: 2.r,
//                               ),
//                               // body
//                               buildAccountTaxBodyTable(
//                                   controller: controller, context: context)
//                             ],
//                           ),
//                         )
//                       : Center(
//                           child: AppNoDataWidge(
//                           message: "empty_filter".tr,
//                         )))
//         ],
//       );
//     });
//   }
// }
