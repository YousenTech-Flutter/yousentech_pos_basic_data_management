// ignore_for_file: unused_element

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/shared_widgets/app_dialog.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/config/app_list.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/build_basic_data_table.dart';
import 'package:yousentech_pos_loading_synchronizing_data/yousentech_pos_loading_synchronizing_data.dart';

// showCustomersDialog({required ResponseResult items}) {
showCustomersDialog({required List items}) {
  CustomDialog.getInstance().itemDialog(
    title: 'customer_list'.tr,
    content: Center(
      child: Container(
          width: 200.w,
          height: Get.height * 0.66,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              definitionColorTable(),
              SizedBox(
                height: 10.r,
              ),
              Expanded(
                  child: Column(
                children: [
                  buildBasicDataColumnHeader(
                      data: customerHeader,
                      color: AppColor.cyanTeal,
                      context: Get.context!,
                      addEmpty: false),
                  buildBodyTableCustomer(customer: items)
                ],
              )),

              // Expanded(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Expanded(
              //           child: Column(
              //         children: [
              //           buildBasicDataColumnHeader(
              //             data: customerHeader,
              //             color: AppColor.cyanTeal,
              //             context: Get.context!,
              //             addEmpty: false
              //           ),
              //           buildBodyTable(
              //               customer: items.data["local"].isNotEmpty
              //                   ? items.data["local"]
              //                   : [])
              //         ],
              //       )),
              //       SizedBox(
              //         width: 10.r,
              //       ),
              //       Expanded(
              //           child: Column(
              //         children: [
              //           buildBasicDataColumnHeader(
              //               data: customerHeader,
              //               color: AppColor.amber,
              //               addEmpty: false,
              //               context: Get.context!),
              //           buildBodyTable(
              //               customer: items.data["remot"].isNotEmpty
              //                   ? items.data["remot"]
              //                   : [])
              //         ],
              //       )),

              //       // items.data["local"].isNotEmpty
              //       //     ? Expanded(
              //       //         child: Column(
              //       //             mainAxisAlignment: MainAxisAlignment.start,
              //       //             crossAxisAlignment: CrossAxisAlignment.start,
              //       //             children: [
              //       //               const Text("customers removed from server"),
              //       //               ...items.data["local"].map((item) =>
              //       //                   Container(
              //       //                       margin: const EdgeInsets.all(5),
              //       //                       height: Get.height * 0.05,
              //       //                       // width: MediaQuery.of(context).size.width,
              //       //                       decoration: BoxDecoration(
              //       //                           color: AppColor.white,
              //       //                           borderRadius:
              //       //                               const BorderRadius.all(
              //       //                                   Radius.circular(100))),
              //       //                       child: Padding(
              //       //                         padding:
              //       //                             const EdgeInsets.symmetric(
              //       //                                 horizontal: 50),
              //       //                         child: Row(
              //       //                           children: [
              //       //                             Container(
              //       //                               margin:
              //       //                                   const EdgeInsets.all(
              //       //                                       10),
              //       //                               width: Get.height * 0.04,
              //       //                               decoration: BoxDecoration(
              //       //                                 shape: BoxShape.circle,
              //       //                                 color:
              //       //                                     AppColor.shadepurple,
              //       //                               ),
              //       //                               child: Center(
              //       //                                   child: Text(
              //       //                                 (items.data["local"]
              //       //                                             .indexOf(
              //       //                                                 item) +
              //       //                                         1)
              //       //                                     .toString(),
              //       //                                 style: const TextStyle(
              //       //                                     color: Colors.white),
              //       //                               )),
              //       //                             ),
              //       //                             Expanded(
              //       //                               flex: 1,
              //       //                               child: Center(
              //       //                                 child: Text(item.name!),
              //       //                               ),
              //       //                             ),
              //       //                             ClipRRect(
              //       //                                 borderRadius:
              //       //                                     BorderRadius.circular(
              //       //                                         100),
              //       //                                 child: item.image == "" ||
              //       //                                         item.image == null
              //       //                                     ? CircleAvatar(
              //       //                                         backgroundColor:
              //       //                                             AppColor
              //       //                                                 .greyWithOpcity,
              //       //                                         child: Icon(
              //       //                                           Icons.person,
              //       //                                           color: AppColor
              //       //                                               .black,
              //       //                                           size:
              //       //                                               Get.height *
              //       //                                                   0.04,
              //       //                                         ),
              //       //                                       )
              //       //                                     : isSvg(item.image!
              //       //                                             .toString())
              //       //                                         ? SvgPicture
              //       //                                             .memory(
              //       //                                             base64.decode(item
              //       //                                                 .image!
              //       //                                                 .toString()),
              //       //                                             width:
              //       //                                                 Get.height *
              //       //                                                     0.04,
              //       //                                             height:
              //       //                                                 Get.height *
              //       //                                                     0.04,
              //       //                                           )
              //       //                                         : Image.memory(
              //       //                                             base64Decode(item
              //       //                                                 .image!
              //       //                                                 .toString()),
              //       //                                             width:
              //       //                                                 Get.height *
              //       //                                                     0.04,
              //       //                                             height:
              //       //                                                 Get.height *
              //       //                                                     0.04,
              //       //                                           )),
              //       //                             Expanded(
              //       //                               flex: 1,
              //       //                               child: Center(
              //       //                                 child: Text(
              //       //                                     item.email ?? ''),
              //       //                               ),
              //       //                             ),
              //       //                             Expanded(
              //       //                               flex: 1,
              //       //                               child: Center(
              //       //                                 child: Text(
              //       //                                     item.phone ?? ''),
              //       //                               ),
              //       //                             ),
              //       //                           ],
              //       //                         ),
              //       //                       )))
              //       //             ]),
              //       //       )
              //       //     : Container(),
              //       // items.data["remot"].isNotEmpty
              //       //     ? Expanded(
              //       //         child: Column(
              //       //             mainAxisAlignment: MainAxisAlignment.start,
              //       //             crossAxisAlignment: CrossAxisAlignment.start,
              //       //             children: [
              //       //               const Text("customers added from server"),
              //       //               ...items.data["remot"].map((item) =>
              //       //                   Container(
              //       //                       margin: const EdgeInsets.all(5),
              //       //                       height: Get.height * 0.05,
              //       //                       // width: MediaQuery.of(context).size.width,
              //       //                       decoration: BoxDecoration(
              //       //                           color: AppColor.white,
              //       //                           borderRadius:
              //       //                               const BorderRadius.all(
              //       //                                   Radius.circular(100))),
              //       //                       child: Padding(
              //       //                         padding:
              //       //                             const EdgeInsets.symmetric(
              //       //                                 horizontal: 50),
              //       //                         child: Row(
              //       //                           children: [
              //       //                             Container(
              //       //                               margin:
              //       //                                   const EdgeInsets.all(
              //       //                                       10),
              //       //                               width: Get.height * 0.04,
              //       //                               decoration: BoxDecoration(
              //       //                                 shape: BoxShape.circle,
              //       //                                 color:
              //       //                                     AppColor.shadepurple,
              //       //                               ),
              //       //                               child: Center(
              //       //                                   child: Text(
              //       //                                 (items.data["remot"]
              //       //                                             .indexOf(
              //       //                                                 item) +
              //       //                                         1)
              //       //                                     .toString(),
              //       //                                 style: const TextStyle(
              //       //                                     color: Colors.white),
              //       //                               )),
              //       //                             ),
              //       //                             Expanded(
              //       //                               flex: 1,
              //       //                               child: Center(
              //       //                                 child: Text(item.name!),
              //       //                               ),
              //       //                             ),
              //       //                             ClipRRect(
              //       //                                 borderRadius:
              //       //                                     BorderRadius.circular(
              //       //                                         100),
              //       //                                 child: item.image == "" ||
              //       //                                         item.image == null
              //       //                                     ? CircleAvatar(
              //       //                                         backgroundColor:
              //       //                                             AppColor
              //       //                                                 .greyWithOpcity,
              //       //                                         child: Icon(
              //       //                                           Icons.person,
              //       //                                           color: AppColor
              //       //                                               .black,
              //       //                                           size:
              //       //                                               Get.height *
              //       //                                                   0.04,
              //       //                                         ),
              //       //                                       )
              //       //                                     : isSvg(item.image!
              //       //                                             .toString())
              //       //                                         ? SvgPicture
              //       //                                             .memory(
              //       //                                             base64.decode(item
              //       //                                                 .image!
              //       //                                                 .toString()),
              //       //                                             width:
              //       //                                                 Get.height *
              //       //                                                     0.04,
              //       //                                             height:
              //       //                                                 Get.height *
              //       //                                                     0.04,
              //       //                                           )
              //       //                                         : Image.memory(
              //       //                                             base64Decode(item
              //       //                                                 .image!
              //       //                                                 .toString()),
              //       //                                             width:
              //       //                                                 Get.height *
              //       //                                                     0.04,
              //       //                                             height:
              //       //                                                 Get.height *
              //       //                                                     0.04,
              //       //                                           )),
              //       //                             Expanded(
              //       //                               flex: 1,
              //       //                               child: Center(
              //       //                                 child: Text(
              //       //                                     item.email ?? ''),
              //       //                               ),
              //       //                             ),
              //       //                             Expanded(
              //       //                               flex: 1,
              //       //                               child: Center(
              //       //                                 child: Text(
              //       //                                     item.phone ?? ''),
              //       //                               ),
              //       //                             ),
              //       //                           ],
              //       //                         ),
              //       //                       )))
              //       //             ]),
              //       //       )
              //       //     : Container(),
              //     ],
              //   ),
              // ),
            ],
          )),
    ),
  );
}

// buildBodyTable({required List<Customer> customer}) {
buildBodyTableCustomer({required List customer}) {
  return Expanded(
    child: ListView.builder(
      itemCount: customer.length,
      shrinkWrap: true,
      primary: true,
      itemBuilder: (BuildContext context, int index) {
        var item = customer[index]["item"];
        return Container(
            margin: EdgeInsets.symmetric(vertical: 5.r),
            height: 40.5,
            // width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: customer[index]["vale"] == 0
                    ? AppColor.cyanTeal.withOpacity(0.2)
                    : customer[index]["vale"] == 1
                        ? AppColor.lightGreen
                        : AppColor.crimsonLight,
                borderRadius: BorderRadius.all(Radius.circular(3.r))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                children: [
                  Container(
                      width: Get.width * 0.04,
                      height: Get.height * 0.04,
                      alignment: Alignment.center,
                      child: Center(
                          child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                            fontSize: 10.r, color: AppColor.charcoalGray),
                      ))),
                  Expanded(
                    flex: 1,
                    child: item.image == "" || item.image == null
                        ? CircleAvatar(
                            backgroundColor: AppColor.cyanTeal.withOpacity(0.3),
                            child: Icon(
                              Icons.person,
                              color: AppColor.black,
                            ),
                          )
                        : isSvg(item.image!.toString())
                            ? CircleAvatar(
                                backgroundColor:
                                    AppColor.cyanTeal.withOpacity(0.3),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: ClipOval(
                                    child: SvgPicture.memory(
                                      base64.decode(item.image!.toString()),
                                      width: Get.height * 0.04,
                                      height: Get.height * 0.04,
                                    ),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor:
                                    AppColor.cyanTeal.withOpacity(0.3),
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Container(
                                    width: Get.height * 0.04,
                                    height: Get.height * 0.04,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      //  border: Border.all(color: AppColor.grey.withOpacity(0.3)),
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: MemoryImage(base64Decode(
                                              item.image!.toString()))),
                                    ),
                                  ),
                                ),
                              ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        item.name!,
                        style: TextStyle(
                            fontSize: 10.r, color: AppColor.charcoalGray),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        item.email ?? "",
                        style: TextStyle(
                            fontSize: 10.r, color: AppColor.charcoalGray),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        item.phone ?? "",
                        style: TextStyle(
                            fontSize: 10.r, color: AppColor.charcoalGray),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    ),
  );
}
