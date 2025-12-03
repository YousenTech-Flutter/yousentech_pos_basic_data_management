// // ignore_for_file: unused_element

// import 'dart:convert';

// import 'package:flutter/material.dart';
  
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:shared_widgets/config/app_colors.dart';
// import 'package:shared_widgets/shared_widgets/app_dialog.dart';
// import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
// import 'package:yousentech_pos_basic_data_management/basic_data_management/config/app_list.dart';
// import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/build_basic_data_table.dart';
// import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/definition_color_table.dart';


// showCustomersDialog({required List items}) {
//   CustomDialog.getInstance().itemDialog(
//     title: 'customer_list'.tr,
//     content: Center(
//       child: Container(
//           width: 200.w,
//           height: Get.height * 0.66,
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             children: [
             
//               definitionColorTable(),
              
              
//               SizedBox(
//                 height: 10.r,
//               ),
//               Expanded(
//                   child: Column(
//                 children: [
//                   buildBasicDataColumnHeader(
//                       data: customerHeader,
//                       color: AppColor.cyanTeal,
//                       context: Get.context!,
//                       addEmpty: false),
//                   buildBodyTable(customer: items)
//                 ],
//               )),
//             ],
//           )),
//     ),
//   );
// }


// buildBodyTable({required List customer}) {
//   return Expanded(
//     child: ListView.builder(
//       itemCount: customer.length,
//       shrinkWrap: true,
//       primary: true,
//       itemBuilder: (BuildContext context, int index) {
//         var item = customer[index]["item"];
//         return Container(
//             margin: EdgeInsets.symmetric(vertical: 5.r),
//             height: 40.5,
//             decoration: BoxDecoration(
//                 color: customer[index]["vale"] == 0
//                     ? AppColor.cyanTeal.withOpacity(0.2)
//                     : customer[index]["vale"] == 1
//                         ? AppColor.lightGreen
//                         : AppColor.crimsonLight,
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
//                           child: Text(
//                         (index + 1).toString(),
//                         style: TextStyle(
//                             fontSize: 10.r, color: AppColor.charcoalGray),
//                       ))),
//                   Expanded(
//                     flex: 1,
//                     child: item.image == "" || item.image == null
//                         ? CircleAvatar(
//                             backgroundColor: AppColor.cyanTeal.withOpacity(0.3),
//                             child: Icon(
//                               Icons.person,
//                               color: AppColor.black,
//                             ),
//                           )
//                         : isSvg(item.image!.toString())
//                             ? CircleAvatar(
//                                 backgroundColor:
//                                     AppColor.cyanTeal.withOpacity(0.3),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(3.0),
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
//                                   padding: const EdgeInsets.all(3),
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
//                         item.name!,
//                         style: TextStyle(
//                             fontSize: 10.r, color: AppColor.charcoalGray),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Center(
//                       child: Text(
//                         item.email ?? "",
//                         style: TextStyle(
//                             fontSize: 10.r, color: AppColor.charcoalGray),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Center(
//                       child: Text(
//                         item.phone ?? "",
//                         style: TextStyle(
//                             fontSize: 10.r, color: AppColor.charcoalGray),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ));
//       },
//     ),
//   );
// }
