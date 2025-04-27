import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/domain/customer_viewmodel.dart';

buildCustomerBodyTable({required CustomerController customerController,required int selectedpag , int ? startIndex}) {
  return Expanded(
    child: ListView.builder(
      itemCount: customerController.searchResults.isNotEmpty
          ? customerController.seachCustomerPagingList.length
          : customerController.customerpagingList.length,
      itemBuilder: (BuildContext context, int index) {
        var item = customerController.searchResults.isNotEmpty
            ? customerController.seachCustomerPagingList[index]
            : customerController.customerpagingList[index];

        return Container(
            margin: EdgeInsets.symmetric(vertical: 2.r),
            height: 40.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: AppColor.white,
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
                      startIndex != null ? "${startIndex + index}" : 
                       ((index + 1) + (selectedpag * customerController.limit))
                            .toString(),
                        style: TextStyle(
                            fontSize: 10.r, color: AppColor.charcoalGray),
                      ))),
                  Expanded(
                    flex: 1,
                    child:
                    
                     item.image == "" || item.image == null
                         ? CircleAvatar(
                             backgroundColor:AppColor.cyanTeal.withOpacity(0.3),
                             child: Icon(
                               Icons.person,
                               color: AppColor.black,
                             ),
                           )
                         : isSvg(item.image!.toString())
                             ? CircleAvatar(
                                 backgroundColor: AppColor.cyanTeal.withOpacity(0.3),
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
                                 backgroundColor:AppColor.cyanTeal.withOpacity(0.3),
                                 child: Padding(
                                   padding: const EdgeInsets.all(3),
                                   child: Container(
                                     width: Get.height * 0.04,
                                       height: Get.height * 0.04,
                                       decoration: BoxDecoration(
                                      shape: BoxShape.circle,
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
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            customerController.object = item;
                            customerController.updateHideMenu(true);
                          },
                          child: SvgPicture.asset(
                            "assets/image/edit.svg",
                            package: 'yousentech_pos_basic_data_management',
                            clipBehavior: Clip.antiAlias,
                            fit: BoxFit.fill,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
      },
    ),
  );
}
