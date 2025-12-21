import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/domain/customer_viewmodel.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/presentation/views/create_edit_customer.dart';

buildCustomerBodyTable({
  required List data,
  required BuildContext context,
  bool showActions = true,
  bool isShowDiffItems = false,
}) {
  CustomerController customerController = Get.put(
    CustomerController(),
    tag: 'customerControllerMain',
  );
  return ListView.builder(
    shrinkWrap: true,
    primary: false,
    physics: const ClampingScrollPhysics(),
    itemCount: data.length,
    itemBuilder: (BuildContext context, int index) {
      var item = isShowDiffItems ? data[index]["item"] : data[index];
      return Container(
        color: isShowDiffItems
            ? data[index]["vale"] == 0
                ? AppColor.green.withValues(alpha: 0.50)
                : data[index]["vale"] == 1
                    ? AppColor.cyanTeal.withValues(alpha: 0.50)
                    : AppColor.red.withValues(alpha: 0.50)
            : (index % 2 == 0
                ? null
                :  Get.find<ThemeController>().isDarkMode.value 
                    ? const Color(0xFF1E1E1E)
                    : const Color(0xFFF3F2F2)),
        height: context.setHeight(35),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.setHeight(5.5)),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    // '${item.id}',
                    // '${index + 1}',
                    ((index + 1) +
                            (customerController.pagnationpagesNumber *
                                ((customerController.limit))))
                        .toString(),
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color:  Get.find<ThemeController>().isDarkMode.value 
                          ? const Color(0xFFE0E0E0)
                          : const Color(0xFF2B2B2B),
                      fontSize: context.setSp(16),
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: context.setWidth(28),
                  height: context.setHeight(28),
                  decoration:
                      item.image == null || isSvg(item.image!.toString())
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              color:  Get.find<ThemeController>().isDarkMode.value 
                                  ? const Color(0xFF4B5563)
                                  : const Color(0xFFE4E4E4),
                            )
                          : BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: MemoryImage(
                                  base64Decode(item.image!.toString()),
                                ),
                              ),
                            ),
                  child: item.image == null || isSvg(item.image!.toString())
                      ? Center(
                          child: SvgPicture.asset(
                            AppImages.partner,
                            package: 'shared_widgets',
                            color:  Get.find<ThemeController>().isDarkMode.value 
                                ? null
                                : const Color(0xFF666C6D),
                          ),
                        )
                      : null,
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color:  Get.find<ThemeController>().isDarkMode.value 
                          ? const Color(0xFFE0E0E0)
                          : const Color(0xFF2B2B2B),
                      fontSize: context.setSp(16),
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    item.email ?? "-",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color:  Get.find<ThemeController>().isDarkMode.value 
                          ? const Color(0xFFE0E0E0)
                          : const Color(0xFF2B2B2B),
                      fontSize: context.setSp(16),
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    item.phone ?? "-",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color:  Get.find<ThemeController>().isDarkMode.value 
                          ? const Color(0xFFE0E0E0)
                          : const Color(0xFF2B2B2B),
                      fontSize: context.setSp(16),
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
              if (showActions) ...[
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      createEditeCustomer(context: context, objectToEdit: item);
                    },
                    child: Center(
                      child: SvgPicture.asset(
                        AppImages.edit,
                        package: 'shared_widgets',
                        width: context.setWidth(22),
                        height: context.setHeight(22),
                        color:  Get.find<ThemeController>().isDarkMode.value 
                            ? null
                            : const Color(0xFFF2AC57),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
