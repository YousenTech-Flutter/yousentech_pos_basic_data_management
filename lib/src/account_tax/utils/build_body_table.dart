import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:yousentech_pos_basic_data_management/src/account_tax/domain/account_tax_viewmodel.dart';

buildAccountTaxBodyTable(
    {required AccountTaxController controller, required BuildContext context}) {
  return Expanded(
    child: ListView.builder(
      itemCount: controller.searchResults.isNotEmpty
          ? controller.searchResults.length
          : controller.accountTaxList.length,
      itemBuilder: (BuildContext context, int index) {
        var item = controller.searchResults.isNotEmpty
            ? controller.searchResults[index]
            : controller.accountTaxList[index];
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
                  // Container(
                  //   width: Get.width * 0.03,
                  //   // width: Get.width * 0.04,
                  //   height: Get.height * 0.04,
                  //   alignment: Alignment.center,
                  //   padding: const EdgeInsets.all(5),
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.rectangle,
                  //     borderRadius: BorderRadius.circular(10),
                  //     color: AppColor.shadepurple,
                  //   ),
                  //   child: Text(
                  //     (index + 1).toString(),
                  //     style: const TextStyle(
                  //         // fontSize: Get.width * 0.01,
                  //         color: Colors.white),
                  //   ),
                  // ),
                  Container(
                      width: Get.width * 0.04,
                      height: Get.height * 0.04,
                      alignment: Alignment.center,
                      child: Center(
                          child: Text(
                        ((index + 1)).toString(),
                        style: TextStyle(
                            fontSize: 10.r, color: AppColor.charcoalGray),
                      ))),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        item.getAccountTaxBasedOnLang,
                        style: TextStyle(
                            fontSize: 10.r, color: AppColor.charcoalGray),
                      ),
                      // (SharedPr.lang == 'ar' ? item.name! : item.name!) ?? ''),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        item.amount.toString(),
                        style: TextStyle(
                            fontSize: 10.r, color: AppColor.charcoalGray),
                      ),
                      // (SharedPr.lang == 'ar' ? item.name! : item.name!) ?? ''),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        item.getIfPriceIncluded,
                        style: TextStyle(
                            fontSize: 10.r, color: AppColor.charcoalGray),
                      ),
                      // (SharedPr.lang == 'ar' ? item.name! : item.name!) ?? ''),
                    ),
                  ),
                ],
              ),
            ));
      },
    ),
  );
}
