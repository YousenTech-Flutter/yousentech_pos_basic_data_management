// import 'package:flutter/material.dart';
  
// import 'package:flutter_svg/svg.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:shared_widgets/config/app_colors.dart';
// import 'package:shared_widgets/shared_widgets/app_no_data.dart';
// import 'package:shared_widgets/shared_widgets/app_text_field.dart';
// import 'package:yousentech_pos_basic_data_management/basic_data_management/src/product_unit/domain/product_unit_viewmodel.dart';
// import '../domain/product_unit_service.dart';

// class PosProductUnitListScreen extends StatefulWidget {
//   const PosProductUnitListScreen({super.key});

//   @override
//   State<PosProductUnitListScreen> createState() =>
//       _PosProductUnitListScreenState();
// }

// class _PosProductUnitListScreenState extends State<PosProductUnitListScreen> {
//   // Initialize the controller using Get.put or Get.find
//   late final ProductUnitController posProductUnitController;
//   TextEditingController searchBarController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     ProductUnitService.productUnitDataServiceInstance = null;
//     ProductUnitService.getInstance();
//     posProductUnitController = Get.put(ProductUnitController());
//   }

//   @override
//   void dispose() {
//     searchBarController.dispose();
//     posProductUnitController.searchResults.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ProductUnitController>(builder: (controller) {
//       return Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: 15.r),
//             child: Text(
//               'pos_unit_list'.tr,
//               style: TextStyle(color: AppColor.lavenderGray, fontSize: 4.sp),
//             ),
//           ),
//           SizedBox(height: 15.r),

//           ContainerTextField(
//             controller: searchBarController,
//             height: 30.h,
//             labelText: '',
//             hintText: 'search'.tr,
//             fontSize: 10.r,
//             fillColor: AppColor.white,
//             borderColor: AppColor.silverGray,
//             hintcolor: AppColor.black.withOpacity(0.5),
//             isAddOrEdit: true,
//             borderRadius: 5.r,
//             prefixIcon: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 5.r, vertical: 5.r),
//               child: SvgPicture.asset(
//                 "assets/image/search_quick.svg",
//                 package: 'yousentech_pos_basic_data_management',
//                 width: 19.r,
//                 height: 19.r,
//               ),
//             ),
//             suffixIcon: searchBarController.text.isNotEmpty
//                 ? InkWell(
//                     onTap: () async {
//                       searchBarController.text = '';
//                       controller.searchResults.clear();
//                       controller.update();
//                     },
//                     child: Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 5.r, vertical: 10.r),
//                       child: FaIcon(FontAwesomeIcons.circleXmark,
//                           color: AppColor.red, size: 10.r),
//                     ),
//                   )
//                 : null,
//             onChanged: (text) async {
//               if (searchBarController.text == '') {
//                 controller.searchResults.clear();
//                 controller.update();
//               } else {
//                 controller.search(searchBarController.text);
//               }
//             },
//           ),

//           SizedBox(height: 10.r),
//           searchBarController.text != "" && controller.searchResults.isEmpty
//               ? Expanded(
//                   child: Center(
//                       child: AppNoDataWidge(
//                   message: "empty_filter".tr,
//                 )))
//               : Expanded(
//                   child: SingleChildScrollView(
//                     child: Wrap(
//                       children: List.generate(
//                           controller.searchResults.isNotEmpty
//                               ? controller.searchResults.length
//                               : controller.productUnitList.length, (int index) {
//                         var item = controller.searchResults.isNotEmpty
//                             ? controller.searchResults[index]
//                             : controller.productUnitList[index];
//                         return Container(
//                           margin: EdgeInsets.only(
//                               top: 20.r, left: 15.r, right: 15.r),
//                           height: 50.h,
//                           width: 60.w,
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                   color: AppColor.gray.withOpacity(0.2)),
//                               color: AppColor.white,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(5.r))),
//                           child: Padding(
//                             padding: EdgeInsets.only(top: 10.r),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding:
//                                       EdgeInsets.only(left: 10.r, right: 10.r),
//                                   child: Container(
//                                     width: 10.w,
//                                     height: 35.h,
//                                     decoration: BoxDecoration(
//                                         color: AppColor.amber.withOpacity(0.5),
//                                         borderRadius:
//                                             BorderRadiusDirectional.all(
//                                                 Radius.circular(5.r))),
//                                     child: Padding(
//                                       padding: EdgeInsets.all(5.r),
//                                       child: SvgPicture.asset(
//                                         'assets/image/productunit_menu_icon.svg',
//                                         package: 'yousentech_pos_basic_data_management',
//                                         color: AppColor.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       SizedBox(
//                                         width: 52.w,
//                                         child: Text(
//                                           item.getProductUnitBasedOnLang,
//                                           style: TextStyle(
//                                               fontSize: 2.3.sp,
//                                               fontWeight: FontWeight.bold),
//                                           softWrap: true,
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                       Text(
//                                         "unit".tr,
//                                         style: TextStyle(
//                                             fontSize: 2.sp,
//                                             color: const Color(0xffABA2A2)),
//                                       ),
//                                       Text(
//                                         "(No : ${index + 1} )",
//                                         style: TextStyle(
//                                             fontSize: 2.sp,
//                                             color: const Color(0xffABA2A2)),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 )
//         ],
//       );
//     });
//   }
// }
