import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/domain/product_viewmodel.dart';
import 'package:yousentech_pos_invoice/invoices/domain/invoice_viewmodel.dart';

filtterProductByCategory({
  required BuildContext context,
  required ProductController productController,
  bool isProductPage = true,
  InvoiceController? invoiceController,
  bool skipOffset = false
}) {
  return showPopover(
    direction: PopoverDirection.bottom,
    backgroundColor:
         Get.find<ThemeController>().isDarkMode.value  ? const Color(0xFF2B2B2B) : AppColor.white,
    context: context,
    width: context.setWidth(220),
    height: context.setHeight(220),
    bodyBuilder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, setState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...productController.categoriesList.map((item) {
                  return Column(
                    children: [
                      CheckboxListTile(
                        side: BorderSide(
                          color: AppColor.gray.withOpacity(0.3), // Border color
                          width: 2.0,
                        ),
                        activeColor: const Color(0xff6F6F6F).withOpacity(0.2),
                        checkColor: const Color(0xff6F6F6F),
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(
                            color: AppColor.red.withOpacity(
                              0.3,
                            ), // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        value:
                            productController
                                .categoriesCheckFiltter[productController
                                .categoriesList
                                .indexOf(item)]["is_check"],
                        onChanged: (value) async {
                          setState(() {
                            productController
                                    .categoriesCheckFiltter[productController
                                    .categoriesList
                                    .indexOf(item)]["is_check"] =
                                value!;
                          });
                          if (isProductPage) {
                            productController.selectedPagnation = 0;
                            productController.pagnationpagesNumber = 0;
                            await productController.searchByCateg(
                              query: productController.categoriesCheckFiltter,
                            );
                            await productController.resetPagingList(
                              selectedpag: 0,
                              skipOffset: skipOffset
                            );
                          } else {
                            productController.update();
                            invoiceController!.categoriesCheckFiltter =
                                productController.categoriesCheckFiltter;
                            invoiceController.pagingController.refresh();
                          }
                        },
                        title: Text(
                          item.getPosCategoryNameBasedOnLang,
                          style: TextStyle(
                            color: Get.find<ThemeController>().isDarkMode.value  ? Colors.white : const Color(0xff6F6F6F),
                            fontSize: context.setSp(13),
                          ),
                        ),
                      ),
                      Divider(height: 0, color: AppColor.gray.withOpacity(0.3)),
                    ],
                  );
                }),
              ],
            ),
          );
        },
      );
    },
  );
}
