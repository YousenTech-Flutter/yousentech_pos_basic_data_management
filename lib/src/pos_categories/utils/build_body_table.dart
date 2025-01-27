import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:yousentech_pos_basic_data_management/src/pos_categories/domain/pos_category_viewmodel.dart';

buildPosCategoreBodyTable(
    {required PosCategoryController posCategoryController}) {
  return Expanded(
    child: ListView.builder(
      itemCount: posCategoryController.searchResults.isNotEmpty
          ? posCategoryController.searchResults.length
          : posCategoryController.posCategoryList.length,
      itemBuilder: (BuildContext context, int index) {
        var item = posCategoryController.searchResults.isNotEmpty
            ? posCategoryController.searchResults[index]
            : posCategoryController.posCategoryList[index];
        return Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            height: 40.5,
            // margin: const EdgeInsets.all(2),
            // height: Get.height * 0.045,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                // color: AppColor.brawn,
                // borderRadius: const BorderRadius.all(Radius.circular(100))
                ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                children: [
                  Container(
                    width: Get.width * 0.03,
                    // width: Get.width * 0.04,
                    height: Get.height * 0.04,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.shadepurple,
                    ),
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(
                          // fontSize: Get.width * 0.01,
                          color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        item.getPosCategoryNameBasedOnLang,
                        // (SharedPr.lang == 'ar'
                        //         ? item.name?.ar001
                        //         : item.name?.enUS)! ??
                        //     '',
                        // style: TextStyle(fontSize: Get.width * 0.01),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () async {
                            posCategoryController.object = item;
                            // print('posCategoryController.object');
                            // print(posCategoryController.object!.toJson());
                            posCategoryController.updateHideMenu(true);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: AppColor.purple,
                          ),
                        ),
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
