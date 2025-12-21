import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';

import '../presentation/create_edit_category.dart';

buildCategoryBodyTable({
  required List data,
  required BuildContext context,
  bool showActions = true,
  bool isShowDiffItems = false,
}) {
  return ListView.builder(
    shrinkWrap: true,
    primary: false,
    physics: const ClampingScrollPhysics(),
    itemCount: data.length,
    itemBuilder: (BuildContext context, int index) {
      var item = isShowDiffItems ? data[index]["item"] : data[index];
      return Container(
                color:
            isShowDiffItems
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
                    '${index+1}',
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color:
                           Get.find<ThemeController>().isDarkMode.value 
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
                    item.getPosCategoryNameBasedOnLang,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color:
                           Get.find<ThemeController>().isDarkMode.value 
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
                    '${item.getPosParentCategoryNameBasedOnLang?? "-"}',
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color:
                           Get.find<ThemeController>().isDarkMode.value 
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
              if(showActions)...[

              
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      createEditeCategory(context: context , objectToEdit: item);
                    },
                    child: Center(
                      child: SvgPicture.asset(
                        AppImages.edit,
                        package: 'shared_widgets',
                        width: context.setWidth(22),
                        height: context.setHeight(22),
                        color:
                             Get.find<ThemeController>().isDarkMode.value 
                                ? null
                                : const  Color(0xFFF2AC57),
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      );
    },
  );
}
