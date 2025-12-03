import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';

import '../presentation/create_edit_category.dart';

buildCategoryBodyTable({
  required List data,
  required BuildContext context,
}) {
  return ListView.builder(
    shrinkWrap: true,
    primary: false,
    physics: const ClampingScrollPhysics(),
    itemCount: data.length,
    itemBuilder: (BuildContext context, int index) {
      var item =  data[index];
      return Container(
        color:(index % 2 == 0
                ? null
                : SharedPr.isDarkMode!
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
                          SharedPr.isDarkMode!
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
                          SharedPr.isDarkMode!
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
                          SharedPr.isDarkMode!
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
                  child: GestureDetector(
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
                            SharedPr.isDarkMode!
                                ? null
                                : const  Color(0xFFF2AC57),
                      ),
                    ),
                  ),
                ),
              
            ],
          ),
        ),
      );
    },
  );
}
