import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/shared_widgets/app_dialog.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
import 'package:yousentech_pos_basic_data_management/config/app_list.dart';
import 'package:yousentech_pos_basic_data_management/utils/build_basic_data_table.dart';
import 'package:yousentech_pos_loading_synchronizing_data/yousentech_pos_loading_synchronizing_data.dart';

// showProductsDialog({required ResponseResult items}) {
showProductsDialog({required List items}) {
  CustomDialog.getInstance().itemDialog(
    title: 'product_list'.tr,
    content: Center(
      child: Container(
          // width: Get.width,
          width: 200.w,
          height: Get.height * 0.66,
          // height: Get.height * 0.75,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              definitionColorTable(),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 5.r),
              //   child: Row(
              //     children: [
              //       Row(
              //         children: [
              //           Container(
              //               width: 7.r,
              //               height: 7.r,
              //               decoration: BoxDecoration(
              //                   borderRadius:
              //                       BorderRadius.all(Radius.circular(1.r)),
              //                   color: AppColor.cyanTeal)),
              //           SizedBox(
              //             width: 2.r,
              //           ),
              //           Text(
              //             'local'.tr,
              //             style: TextStyle(
              //                 fontSize: 8.r, color: AppColor.strongDimGray),
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         width: 7.r,
              //       ),
              //       Row(
              //         children: [
              //           Container(
              //               width: 7.r,
              //               height: 7.r,
              //               decoration: BoxDecoration(
              //                   borderRadius:
              //                       BorderRadius.all(Radius.circular(1.r)),
              //                   color: AppColor.amber)),
              //           SizedBox(
              //             width: 2.r,
              //           ),
              //           Text('remote'.tr,
              //               style: TextStyle(
              //                   fontSize: 8.r, color: AppColor.strongDimGray)),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),

              SizedBox(
                height: 10.r,
              ),

              Expanded(
                  child: Column(
                children: [
                  buildBasicDataColumnHeader(
                      data: productHeader,
                      color: AppColor.amber,
                      addEmpty: false,
                      context: Get.context!),
                  buildBodyTable(product: items)
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
              //             data: productHeader,
              //             color: AppColor.cyanTeal,
              //             context: Get.context!,
              //             addEmpty: false
              //           ),
              //           buildBodyTable(
              //               product: items.data["local"].isNotEmpty
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
              //               data: productHeader,
              //               color: AppColor.amber,
              //               addEmpty: false,
              //               context: Get.context!),
              //           buildBodyTable(
              //               product: items.data["remot"].isNotEmpty
              //                   ? items.data["remot"]
              //                   : [])
              //         ],
              //       )),

              //     ],
              //   ),
              // ),
            ],
          )
          // items.status
          //     ? SingleChildScrollView(
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             items.data["local"].isNotEmpty
          //                 ? Expanded(
          //                     child: Column(
          //                         mainAxisAlignment: MainAxisAlignment.start,
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           const Text("products removed from server"),
          //                           ...items.data["local"].map((item) =>
          //                               Container(
          //                                   margin: const EdgeInsets.all(5),
          //                                   height: Get.height * 0.05,
          //                                   decoration: BoxDecoration(
          //                                       color: AppColor.white,
          //                                       borderRadius:
          //                                           const BorderRadius.all(
          //                                               Radius.circular(100))),
          //                                   child: Padding(
          //                                     padding:
          //                                         const EdgeInsets.symmetric(
          //                                             horizontal: 50),
          //                                     child: Row(
          //                                       children: [
          //                                         Container(
          //                                           margin:
          //                                               const EdgeInsets.all(
          //                                                   10),
          //                                           width: Get.height * 0.04,
          //                                           decoration: BoxDecoration(
          //                                             shape: BoxShape.circle,
          //                                             color:
          //                                                 AppColor.shadepurple,
          //                                           ),
          //                                           child: Center(
          //                                               child: Text(
          //                                             (items.data["local"]
          //                                                         .indexOf(
          //                                                             item) +
          //                                                     1)
          //                                                 .toString(),
          //                                             style: const TextStyle(
          //                                                 color: Colors.white),
          //                                           )),
          //                                         ),
          //                                         Expanded(
          //                                           flex: 1,
          //                                           child: Center(
          //                                             child: Text((SharedPr
          //                                                             .lang ==
          //                                                         'ar'
          //                                                     ? item
          //                                                         .productName!
          //                                                         .ar001
          //                                                     : item
          //                                                         .productName!
          //                                                         .enUS) ??
          //                                                 ''),
          //                                           ),
          //                                         ),
          //                                         ClipRRect(
          //                                             borderRadius:
          //                                                 BorderRadius.circular(
          //                                                     100),
          //                                             child: item.image == null
          //                                                 ? CircleAvatar(
          //                                                     backgroundColor:
          //                                                         AppColor
          //                                                             .white,
          //                                                     child:
          //                                                         Image.asset(
          //                                                       "assets/image/product.png",
          //                                                       // width: MediaQuery.of(cont)
          //                                                       //         .size
          //                                                       //         .width *
          //                                                       //     0.02,
          //                                                       color: AppColor
          //                                                           .grey,
          //                                                     ),
          //                                                   )
          //                                                 : isSvg(item.image!
          //                                                         .toString())
          //                                                     ? SvgPicture
          //                                                         .memory(
          //                                                         base64.decode(item
          //                                                             .image!
          //                                                             .toString()),
          //                                                         width:
          //                                                             Get.height *
          //                                                                 0.04,
          //                                                         height:
          //                                                             Get.height *
          //                                                                 0.04,
          //                                                       )
          //                                                     : Image.memory(
          //                                                         base64Decode(item
          //                                                             .image!
          //                                                             .toString()),
          //                                                         width:
          //                                                             Get.height *
          //                                                                 0.04,
          //                                                         height:
          //                                                             Get.height *
          //                                                                 0.04,
          //                                                       )),
          //                                         Expanded(
          //                                           flex: 1,
          //                                           child: Center(
          //                                             child: Text(
          //                                                 item.soPosCategName ??
          //                                                     ""),
          //                                           ),
          //                                         ),
          //                                         Expanded(
          //                                           flex: 1,
          //                                           child: Center(
          //                                             child: Text(item.unitPrice
          //                                                 .toString()),
          //                                           ),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   )))
          //                         ]),
          //                   )
          //                 : Container(),
          //             items.data["remot"].isNotEmpty
          //                 ? Expanded(
          //                     child: Column(
          //                         mainAxisAlignment: MainAxisAlignment.start,
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           const Text("products added from server"),
          //                           ...items.data["remot"].map((item) =>
          //                               Container(
          //                                   margin: const EdgeInsets.all(5),
          //                                   height: Get.height * 0.05,
          //                                   decoration: BoxDecoration(
          //                                       color: AppColor.white,
          //                                       borderRadius:
          //                                           const BorderRadius.all(
          //                                               Radius.circular(100))),
          //                                   child: Padding(
          //                                     padding:
          //                                         const EdgeInsets.symmetric(
          //                                             horizontal: 50),
          //                                     child: Row(
          //                                       children: [
          //                                         Container(
          //                                           margin:
          //                                               const EdgeInsets.all(
          //                                                   10),
          //                                           width: Get.height * 0.04,
          //                                           decoration: BoxDecoration(
          //                                             shape: BoxShape.circle,
          //                                             color:
          //                                                 AppColor.shadepurple,
          //                                           ),
          //                                           child: Center(
          //                                               child: Text(
          //                                             (items.data["remot"]
          //                                                         .indexOf(
          //                                                             item) +
          //                                                     1)
          //                                                 .toString(),
          //                                             style: const TextStyle(
          //                                                 color: Colors.white),
          //                                           )),
          //                                         ),
          //                                         Expanded(
          //                                           flex: 1,
          //                                           child: Center(
          //                                             child: Text((SharedPr
          //                                                             .lang ==
          //                                                         'ar'
          //                                                     ? item
          //                                                         .productName!
          //                                                         .ar001
          //                                                     : item
          //                                                         .productName!
          //                                                         .enUS) ??
          //                                                 ''),
          //                                           ),
          //                                         ),
          //                                         ClipRRect(
          //                                             borderRadius:
          //                                                 BorderRadius.circular(
          //                                                     100),
          //                                             child: item.image == null
          //                                                 ? CircleAvatar(
          //                                                     backgroundColor:
          //                                                         AppColor
          //                                                             .white,
          //                                                     child:
          //                                                         Image.asset(
          //                                                       "assets/image/product.png",
          //                                                       // width: MediaQuery.of(cont)
          //                                                       //         .size
          //                                                       //         .width *
          //                                                       //     0.02,
          //                                                       color: AppColor
          //                                                           .grey,
          //                                                     ),
          //                                                   )
          //                                                 : isSvg(item.image!
          //                                                         .toString())
          //                                                     ? SvgPicture
          //                                                         .memory(
          //                                                         base64.decode(item
          //                                                             .image!
          //                                                             .toString()),
          //                                                         width:
          //                                                             Get.height *
          //                                                                 0.04,
          //                                                         height:
          //                                                             Get.height *
          //                                                                 0.04,
          //                                                       )
          //                                                     : Image.memory(
          //                                                         base64Decode(item
          //                                                             .image!
          //                                                             .toString()),
          //                                                         width:
          //                                                             Get.height *
          //                                                                 0.04,
          //                                                         height:
          //                                                             Get.height *
          //                                                                 0.04,
          //                                                       )),
          //                                         Expanded(
          //                                           flex: 1,
          //                                           child: Center(
          //                                             child: Text(
          //                                                 item.soPosCategName ??
          //                                                     ""),
          //                                           ),
          //                                         ),
          //                                         Expanded(
          //                                           flex: 1,
          //                                           child: Center(
          //                                             child: Text(item.unitPrice
          //                                                 .toString()),
          //                                           ),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   )))
          //                         ]),
          //                   )
          //                 : Container(),
          //           ],
          //         ),
          //       )
          //     : Text(items.message)

          ),
    ),
  );
}

// buildBodyTable({required List<Product> product}) {
buildBodyTable({required List product}) {
  return Expanded(
    child: ListView.builder(
      itemCount: product.length,
      shrinkWrap: true,
      primary: true,
      itemBuilder: (BuildContext context, int index) {
        // var item = product[index];
        var item = product[index]["item"];
        return Container(
            margin: EdgeInsets.symmetric(vertical: 5.r),
            height: 40.5,
            decoration: BoxDecoration(
                // color: AppColor.white,
                color: product[index]["vale"] == 0
                    ? AppColor.cyanTeal.withOpacity(0.2)
                    : product[index]["vale"] == 1
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
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                width: Get.height * 0.04,
                                height: Get.height * 0.04,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                        "assets/image/product.png",
                                        package:
                                            'yousentech_pos_basic_data_management',
                                      )),
                                ),
                                // child:
                                // Image.memory(
                                //   base64Decode(item.image!.toString()),
                                //   width: Get.height * 0.04,
                                //   height: Get.height * 0.04,
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                            ),
                          )
                        : isSvg(item.image!.toString())
                            ? CircleAvatar(
                                backgroundColor:
                                    AppColor.cyanTeal.withOpacity(0.3),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                                  padding: const EdgeInsets.all(3.0),
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
                                    // child:
                                    // Image.memory(
                                    //   base64Decode(item.image!.toString()),
                                    //   width: Get.height * 0.04,
                                    //   height: Get.height * 0.04,
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                ),
                              ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        item.getProductNameBasedOnLang,
                        style: TextStyle(
                            fontSize: 10.r, color: AppColor.charcoalGray),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        item.soPosCategName!,
                        style: TextStyle(
                            fontSize: 10.r, color: AppColor.charcoalGray),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        item.unitPrice.toString(),
                        style: TextStyle(
                            fontSize: 10.r, color: AppColor.charcoalGray),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        item.uomName!,
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
