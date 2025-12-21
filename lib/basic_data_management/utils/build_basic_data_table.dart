import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';

buildBasicDataColumnHeader({
  required data,
  required BuildContext context,
  Color? color,
  int? fontSize,
}) {
  return Container(
    width: Get.width,
    height: context.setHeight(30),
    decoration: BoxDecoration(color: color),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...List.generate(
          data.length,
          (index) => Expanded(
            flex: data[index]["flex"],
            child: Center(
              child: Text(
                '${data[index]["name"]}'.tr,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color:Get.find<ThemeController>().isDarkMode.value ? Colors.white : const Color(0xFF0C0C0C),
                  fontSize:context.setSp(fontSize?? 17) ,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
