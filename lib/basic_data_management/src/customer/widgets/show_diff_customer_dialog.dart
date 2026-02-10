import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/app_dialog.dart';
import 'package:shared_widgets/utils/responsive_helpers/device_utils.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_provider.dart';

import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/build_basic_data_table.dart';

import '../utils/build_customer_body_table.dart';

showDiffCustomersDialog({required List items, required BuildContext context}) {
  dialogcontent(
    context: context,
    content: Builder(
      builder: (context) {
        return SizeProvider(
          baseSize: Size(context.screenWidth, context.setHeight(500)),
          width: context.screenWidth,
          height: context.setHeight(500),
          child: SizedBox(
            height: context.setHeight(500),
            width: context.screenWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.setHeight(16),
                horizontal: context.setWidth(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: context.setHeight(16),
                  children: [
                    Text(
                      'customer_list'.tr,
                      style: TextStyle(
                        color:
                             Get.find<ThemeController>().isDarkMode.value 
                                ? Colors.white
                                : const Color(0xFF0C0C0C),
                        fontSize: context.setSp(22),
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.w700,
                        height: 1.45,
                      ),
                    ),
                    definitionColorTable(context: context),
                    buildBasicDataColumnHeader(
                      context: context,

                      data:
                      DeviceUtils.isMobile(context) ? [
                        {"name": "number", "flex": 1},
                        {"name": "name", "flex": 2},
                        {"name": "email", "flex": 2},
                        {"name": "phone", "flex": 1},
                      ]:
                       [
                        {"name": "number", "flex": 1},
                        {"name": "customer_image", "flex": 1},
                        {"name": "name", "flex": 2},
                        {"name": "email", "flex": 2},
                        {"name": "phone", "flex": 1},
                      ],
                    ),
                    buildCustomerBodyTable(
                      context: context,
                      showActions: false,
                      isShowDiffItems: true,
                      data:items,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

definitionColorTable({required BuildContext context}) {
  return Row(
    spacing: context.setWidth(25),
    children: [
      Row(
        spacing: context.setWidth(10),
        children: [
          Container(
            width: context.setMinSize(10),
            height: context.setMinSize(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(context.setMinSize(2)),
              ),
              color: AppColor.cyanTeal,
            ),
          ),
          Text(
            'addition'.tr,
            style: TextStyle(
              fontSize: context.setSp(12),
              color: AppColor.cyanTeal,
            ),
          ),
        ],
      ),
      Row(
        spacing: context.setWidth(10),
        children: [
          Container(
            width: context.setMinSize(10),
            height: context.setMinSize(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(context.setMinSize(2)),
              ),
              color: AppColor.green,
            ),
          ),
          Text(
            'edit'.tr,
            style: TextStyle(
              fontSize: context.setSp(12),
              color: AppColor.green,
            ),
          ),
        ],
      ),
      Row(
        spacing: context.setWidth(10),
        children: [
          Container(
            width: context.setMinSize(10),
            height: context.setMinSize(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(context.setMinSize(2)),
              ),
              color: AppColor.red,
            ),
          ),
          Text(
            'delete'.tr,
            style: TextStyle(fontSize: context.setSp(12), color: AppColor.red),
          ),
        ],
      ),
    ],
  );
}
