import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/shared_widgets/app_dialog.dart';
import 'package:yousentech_pos_basic_data_management/config/app_list.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/build_basic_data_table.dart';
import 'package:yousentech_pos_loading_synchronizing_data/yousentech_pos_loading_synchronizing_data.dart';

// showCategorysDialog({required ResponseResult items}) {
showCategorysDialog({required List items}) {
  CustomDialog.getInstance().itemDialog(
    title: 'pos_category_list'.tr,
    content: Center(
      child: Container(
          // width: Get.width,
          width: 200.w,
          height: Get.height * 0.66,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              definitionColorTable(),
              //  Padding(
              //         padding:
              //             EdgeInsets.symmetric(horizontal: 10.r, vertical: 5.r),
              //         child: Row(
              //           children: [
              //             Row(
              //               children: [
              //                 Container(
              //                     width: 7.r,
              //                     height: 7.r,
              //                     decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.all(
              //                             Radius.circular(1.r)),
              //                         color: AppColor.cyanTeal)),
              //                 SizedBox(
              //                   width: 2.r,
              //                 ),
              //                 Text(
              //                   'local'.tr,
              //                   style: TextStyle(
              //                       fontSize: 8.r,
              //                       color: AppColor.strongDimGray),
              //                 ),
              //               ],
              //             ),
              //             SizedBox(
              //               width: 7.r,
              //             ),
              //             Row(
              //               children: [
              //                 Container(
              //                     width: 7.r,
              //                     height: 7.r,
              //                     decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.all(
              //                             Radius.circular(1.r)),
              //                         color: AppColor.amber)),
              //                 SizedBox(
              //                   width: 2.r,
              //                 ),
              //                 Text('remote'.tr,
              //                     style: TextStyle(
              //                         fontSize: 8.r,
              //                         color: AppColor.strongDimGray)),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),

              SizedBox(
                height: 10.r,
              ),
              Expanded(
                  child: Column(
                children: [
                  buildBasicDataColumnHeader(
                      data: posCategHeader,
                      color: AppColor.cyanTeal,
                      context: Get.context!,
                      showIndex: true,
                      addEmpty: false),
                  buildBodyTablePosCategory(category: items)
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
              //             data: posCategHeader,
              //             color: AppColor.cyanTeal,
              //             context: Get.context!,
              //             showIndex: true,
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
              //               data: posCategHeader,
              //               color: AppColor.amber,
              //               addEmpty: false,
              //               showIndex: true,
              //               context: Get.context!),
              //           buildBodyTable(
              //               customer: items.data["remot"].isNotEmpty
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
          //         child: Column(

          //           children: [
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.start,
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 items.data["local"].isNotEmpty?
          //                 Expanded(
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                     const Text("categories removed from server"),
          //                     ...items.data["local"].map((item) => Container(
          //                         margin: const EdgeInsets.all(5),
          //                         height: Get.height * 0.05,
          //                         decoration: BoxDecoration(
          //                             color: AppColor.white,
          //                             borderRadius:
          //                                 const BorderRadius.all(Radius.circular(100))),
          //                         child: Padding(
          //                           padding: const EdgeInsets.symmetric(horizontal: 50),
          //                           child: Row(
          //                             children: [
          //                               Container(
          //                                 margin: const EdgeInsets.all(10),
          //                                 width: Get.height * 0.04,
          //                                 decoration: BoxDecoration(
          //                                   shape: BoxShape.circle,
          //                                   color: AppColor.shadepurple,
          //                                 ),
          //                                 child: Center(
          //                                     child: Text(
          //                                   (items.data["local"].indexOf(item) + 1).toString(),
          //                                   style: const TextStyle(color: Colors.white),
          //                                 )),
          //                               ),
          //                               Expanded(
          //                                 flex: 1,
          //                                 child: Center(
          //                                   child: Text((SharedPr.lang == 'ar' ? item.name!.ar001 : item.name!.enUS)!),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         )))
          //                   ]),
          //                 ): Container(),
          //                 items.data["remot"].isNotEmpty?
          //                 Expanded(
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.start,
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                     const Text("categories added from server"),
          //                     ...items.data["remot"].map((item) => Container(
          //                         margin: const EdgeInsets.all(5),
          //                         height: Get.height * 0.05,
          //                         decoration: BoxDecoration(
          //                             color: AppColor.white,
          //                             borderRadius:
          //                                 const BorderRadius.all(Radius.circular(100))),
          //                         child: Padding(
          //                           padding: const EdgeInsets.symmetric(horizontal: 50),
          //                           child: Row(
          //                             children: [
          //                               Container(
          //                                 margin: const EdgeInsets.all(10),
          //                                 width: Get.height * 0.04,
          //                                 decoration: BoxDecoration(
          //                                   shape: BoxShape.circle,
          //                                   color: AppColor.shadepurple,
          //                                 ),
          //                                 child: Center(
          //                                     child: Text(
          //                                   (items.data["remot"].indexOf(item) + 1).toString(),
          //                                   style: const TextStyle(color: Colors.white),
          //                                 )),
          //                               ),
          //                               Expanded(
          //                                 flex: 1,
          //                                 child: Center(
          //                                   child: Text((SharedPr.lang == 'ar' ? item.name!.ar001 : item.name!.enUS)!),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         )))
          //                   ]),
          //                 )
          //                 : Container(),

          //               ],
          //             ),
          //           ],
          //         ),
          //       )
          //     : Text(items.message)

          ),
    ),
  );
}

// buildBodyTable({required List<PosCategory> customer}) {
buildBodyTablePosCategory({required List category}) {
  return Expanded(
    child: ListView.builder(
      itemCount: category.length,
      shrinkWrap: true,
      primary: true,
      itemBuilder: (BuildContext context, int index) {
        // var item = customer[index];
        var item = category[index]["item"];
        return Container(
            margin: EdgeInsets.symmetric(vertical: 5.r),
            height: 40.5,
            decoration: BoxDecoration(
                // color: AppColor.white,
                color: category[index]["vale"] == 0
                    ? AppColor.cyanTeal.withOpacity(0.2)
                    : category[index]["vale"] == 1
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
                    flex: 2,
                    child: Center(
                      child: Text(
                        (SharedPr.lang == 'ar'
                            ? item.name!.ar001
                            : item.name!.enUS)!,
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
