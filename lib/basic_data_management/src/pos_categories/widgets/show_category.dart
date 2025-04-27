import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/shared_widgets/app_dialog.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/config/app_list.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/build_basic_data_table.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/definition_color_table.dart';

showCategorysDialog({required List items}) {
  CustomDialog.getInstance().itemDialog(
    title: 'pos_category_list'.tr,
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
                      data: posCategHeader,
                      color: AppColor.cyanTeal,
                      context: Get.context!,
                      showIndex: true,
                      addEmpty: false),
                  buildBodyTable(category: items)
                ],
              )),
            ],
          )),
    ),
  );
}

buildBodyTable({required List category}) {
  return Expanded(
    child: ListView.builder(
      itemCount: category.length,
      shrinkWrap: true,
      primary: true,
      itemBuilder: (BuildContext context, int index) {
        var item = category[index]["item"];
        return Container(
            margin: EdgeInsets.symmetric(vertical: 5.r),
            height: 40.5,
            decoration: BoxDecoration(
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
