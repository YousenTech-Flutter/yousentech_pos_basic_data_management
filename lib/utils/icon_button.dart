import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_colors.dart';

IconButton iconButtonWidg(
    {required BuildContext context,
    required void Function()? onPressed,
    required String data,
    required IconData icon,
    Color? color = const Color(0xFF5F27CD)}) {
  return IconButton(
      onPressed: onPressed,
      icon: Container(
          // width: Get.width / 15,
          height: 33,
          // MediaQuery.sizeOf(context).height * 0.03,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  icon,
                  color: AppColor.white,
                  size: Get.width * 0.01,
                ),
                const SizedBox(width: 10),
                Text(data.tr,
                    style: const TextStyle(
                        color: Colors.white,
                        // fontSize: Get.width * 0.01,
                        fontWeight: FontWeight.normal)),
              ],
            ),
          )));
}
