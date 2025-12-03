// import 'package:flutter/material.dart';
  
// import 'package:get/get.dart';
// import 'package:shared_widgets/config/app_colors.dart';

// buildBasicDataColumnHeader(
//     {required data,
//     required BuildContext context,
//     bool isPending = false,
//     double? width,
//     double? fontSize,
//     bool addEmpty = true,
//     double? padding,
//     double? height,
//     Color? color,
//     bool showIndex = true}) {
//   return Container(
//       // margin: const EdgeInsets.all(2),
//       width: width ?? MediaQuery.of(context).size.width,
//       height: height,
//       // width: width ?? MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//           color: color ?? AppColor.cyanTeal,
//           borderRadius: BorderRadius.all(Radius.circular(3.r))),
//       child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: padding ?? 50),
//           child: Row(children: [
//             if (showIndex) ...[
//               Container(
//                   width: Get.width * 0.04,
//                   height: Get.height * 0.04,
//                   alignment: Alignment.center,
//                   child: Center(
//                       child: Text(
//                     "No".tr,
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: fontSize ?? Get.width * 0.008),
//                   ))),
//             ],
//             ...List.generate(
//               data.length,
//               (index) => Expanded(
//                   flex: data[index]["flex"],
//                   child: Center(
//                       child: Text(
//                     '${data[index]["name"]}'.tr,
//                     style: TextStyle(
//                         color: Colors.white,
//                         // fontWeight: FontWeight.bold
//                         fontSize: fontSize ?? Get.width * 0.008),
//                   ))),
//             ),
//             if (addEmpty) ...[
//               const Expanded(
//                   flex: 1,
//                   child: Center(
//                       child: Text(
//                     "",
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ))),
//             ],
//           ])));
// }
