import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/app_dialog.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_provider.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/utils/build_product_body_table.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/utils/build_basic_data_table.dart';

showDiffProductsDialog({required List items, required BuildContext context}) {
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
                      'product_list'.tr,
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
                      data: [
                        {"name": "number", "flex": 1},
                        {"name": "product_image", "flex": 1},
                        {"name": "product_name", "flex": 2},
                        {"name": "product_unit_price", "flex": 2},
                        {"name": "unit", "flex": 1},
                        // {"name": "actions", "flex": 1},
                      ],
                    ),
                    buildProductBodyTable(
                      context: context,
                      showActions: false,
                      isShowDiffItems: true,
                      data: items
                      // [
                      //   {
                      //     "item": Product(
                      //       id: 001,
                      //       productName: ProductName(
                      //         ar001: "رز روان",
                      //         enUS: "رز روان",
                      //       ),
                      //       unitPrice: 250,
                      //       uomName: "الوحدة",
                      //     ),

                      //     "vale": 0,
                      //   },
                      //   {
                      //     "item": Product(
                      //       id: 002,
                      //       productName: ProductName(
                      //         ar001: "دقيق حضرموت",
                      //         enUS: "دقيق حضرموت",
                      //       ),
                      //       unitPrice: 250,
                      //       uomName: "الوحدة",
                      //     ),

                      //     "vale": 1,
                      //   },
                      //   {
                      //     "item": Product(
                      //       id: 002,
                      //       productName: ProductName(
                      //         ar001: "دقيق حضرموت",
                      //         enUS: "دقيق حضرموت",
                      //       ),
                      //       unitPrice: 250,
                      //       uomName: "الوحدة",
                      //     ),
                      //     "vale": -1,
                      //   },
                      // ],
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
