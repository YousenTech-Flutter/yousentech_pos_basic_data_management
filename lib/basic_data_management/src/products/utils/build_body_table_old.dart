// import 'dart:convert';

// import 'package:flutter/material.dart';
  
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:pos_shared_preferences/models/pos_categories_data/pos_category.dart';
// import 'package:pos_shared_preferences/models/product_data/product.dart';
// import 'package:pos_shared_preferences/models/product_unit/data/product_unit.dart';
// import 'package:shared_widgets/config/app_colors.dart';
// import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
// import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/domain/product_viewmodel.dart';

// buildProductBodyTable(
//     {required ProductController productController,
//     required int selectedpag,
//     int? startIndex}) {
//   var result = productController.filtterResults.isNotEmpty &&
//           productController.searchResults.isEmpty
//       ? productController.filtterResults
//       : productController.searchResults.isNotEmpty
//           ? productController.searchResults
//           : RxList<Product>();
//   productController.isEmptylist.value = result.isEmpty;
//   productController.update(['productControllerMain']);
//   return Expanded(
//     child: ListView.builder(
//       itemCount: result.isNotEmpty
//           ? productController.seachFilterPagingList.length
//           : productController.isHaveCheck.value
//               ? 0
//               : productController.pagingList.length,
//       itemBuilder: (BuildContext context, int index) {
//         var item = result.isNotEmpty
//             ? productController.seachFilterPagingList[index]
//             : productController.pagingList[index];

//         ProductUnit? unitObject = productController.unitsList
//             .firstWhereOrNull((element) => element.id == item.uomId);

//         PosCategory? categoryObject = productController.categoriesList
//             .firstWhereOrNull((element) => element.id == item.soPosCategId);
//         return Container(
//             margin: EdgeInsets.symmetric(vertical: 2.r),
//             height: 40.5,
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//                 color: AppColor.white,
//                 borderRadius: BorderRadius.all(Radius.circular(3.r))),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 50),
//               child: Row(
//                 children: [
//                   Container(
//                       width: Get.width * 0.04,
//                       height: Get.height * 0.04,
//                       alignment: Alignment.center,
//                       child: Center(
//                         child: Text(
//                           startIndex != null
//                               ? "${startIndex + index}"
//                               : ((index + 1) +
//                                       (selectedpag * productController.limit))
//                                   .toString(),
//                           style: TextStyle(
//                               fontSize: 10.r, color: AppColor.charcoalGray),
//                         ),
//                       )),
//                   Expanded(
//                     flex: 1,
//                     child: item.image == null
//                         ? CircleAvatar(
//                             backgroundColor: AppColor.cyanTeal.withOpacity(0.3),
//                             child: Padding(
//                               padding: const EdgeInsets.all(3.0),
//                               child: Container(
//                                 width: Get.height * 0.04,
//                                 height: Get.height * 0.04,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   image: DecorationImage(
//                                       fit: BoxFit.contain,
//                                       image: AssetImage(
//                                           "assets/image/product.png",package: 'yousentech_pos_basic_data_management',)),
//                                 ),
//                               ),
//                             ),
//                           )
//                         : isSvg(item.image!.toString())
//                             ? CircleAvatar(
//                                 backgroundColor:
//                                     AppColor.cyanTeal.withOpacity(0.3),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: ClipOval(
//                                     child: SvgPicture.memory(
//                                       base64.decode(item.image!.toString()),
//                                       width: Get.height * 0.04,
//                                       height: Get.height * 0.04,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             : CircleAvatar(
//                                 backgroundColor:
//                                     AppColor.cyanTeal.withOpacity(0.3),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(3.0),
//                                   child: Container(
//                                     width: Get.height * 0.04,
//                                     height: Get.height * 0.04,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       image: DecorationImage(
//                                           fit: BoxFit.contain,
//                                           image: MemoryImage(base64Decode(
//                                               item.image!.toString()))),
//                                     ),
//                                   ),
//                                 ),
//                               ),
                  
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Center(
//                       child: Text(
//                         item.getProductNameBasedOnLang,
//                         style: TextStyle(
//                             fontSize: 10.r, color: AppColor.charcoalGray),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Center(
//                       child: Text(
//                         categoryObject == null 
//                             ? ""
//                             : categoryObject.getPosCategoryNameBasedOnLang,
//                         style: TextStyle(
//                             fontSize: 10.r, color: AppColor.charcoalGray),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Center(
//                       child: Text(
//                         item.unitPrice.toString(),
//                         style: TextStyle(
//                             fontSize: 10.r, color: AppColor.charcoalGray),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Center(
//                       child: Text(
//                         unitObject == null
//                             ? ""
//                             : unitObject.getProductUnitBasedOnLang,
//                         style: TextStyle(
//                             fontSize: 10.r, color: AppColor.charcoalGray),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             productController.object = item;
//                             productController.updateHideMenu(true);
//                           },
//                           child: SvgPicture.asset(
//                             "assets/image/edit.svg",
//                             package: 'yousentech_pos_basic_data_management',
//                             clipBehavior: Clip.antiAlias,
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ));
//       },
//     ),
//   );
// }
