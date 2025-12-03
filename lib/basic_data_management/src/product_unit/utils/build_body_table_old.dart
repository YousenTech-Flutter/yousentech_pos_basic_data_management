// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_widgets/config/app_colors.dart';
// import 'package:yousentech_pos_basic_data_management/basic_data_management/src/product_unit/domain/product_unit_viewmodel.dart';

// buildProductUnitBodyTable(
//     {required ProductUnitController controller,
//     required BuildContext context}) {
//   return Expanded(
//     child: ListView.builder(
//       itemCount: controller.searchResults.isNotEmpty
//           ? controller.searchResults.length
//           : controller.productUnitList.length,
//       itemBuilder: (BuildContext context, int index) {
//         var item = controller.searchResults.isNotEmpty
//             ? controller.searchResults[index]
//             : controller.productUnitList[index];
//         return Container(
//            margin: const EdgeInsets.symmetric(vertical: 2),
//             height: 40.5,
//             width: MediaQuery.of(context).size.width,
//             decoration: const BoxDecoration(
//                 ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 50),
//               child: Row(
//                 children: [
//                   Container(
//                     width: Get.width * 0.03,
//                     height: Get.height * 0.04,
//                     alignment: Alignment.center,
//                     padding: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.rectangle,
//                       borderRadius: BorderRadius.circular(10),
//                       color: AppColor.shadepurple,
//                     ),
//                     child: Text(
//                       (index + 1).toString(),
//                       style: const TextStyle(
//                           color: Colors.white),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Center(
//                       child: Text(
//                         item.getProductUnitBasedOnLang
//                           ),
//                     ),
//                   ),
//                 ],
//               ),
//             ));
//       },
//     ),
//   );
// }
