// import 'package:flutter/material.dart';
  
// import 'package:get/get.dart';
// import 'package:popover/popover.dart';
// import 'package:shared_widgets/config/app_colors.dart';
// import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/domain/product_viewmodel.dart';
// import 'package:yousentech_pos_invoice/invoices/domain/invoice_viewmodel.dart';

// filtterProductByCategory({required BuildContext context,required ProductController productController, bool  isProductPage = true , InvoiceController? invoiceController}) {
//   return showPopover(
//     direction: PopoverDirection.bottom,
//     context: context,
//     width: Get.width * 0.15,
//     backgroundColor: AppColor.white,
//     bodyBuilder: (context) {
//       return StatefulBuilder(builder: (BuildContext context, setState) {
//         return SingleChildScrollView(
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ...productController.categoriesList.map((item) {
//                   return Column(
//                     children: [
//                       CheckboxListTile(
//                         side: BorderSide(
//                           color: AppColor.gray.withOpacity(0.3), // Border color
//                           width: 2.0, // Border width
//                         ),
//                         activeColor: const Color(0xff6F6F6F).withOpacity(0.2),
//                         checkColor: const Color(0xff6F6F6F),
//                         checkboxShape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(4),
//                             side: BorderSide(
//                               color:
//                                   AppColor.red.withOpacity(0.3), // Border color
//                               width: 2.0, // Border width
//                             )),
//                         value: productController.categoriesCheckFiltter[
//                                 productController.categoriesList.indexOf(item)]
//                             ["is_check"],
//                         onChanged: (value) async {
//                           setState(
//                             () {
//                               productController.categoriesCheckFiltter[
//                                   productController.categoriesList
//                                       .indexOf(item)]["is_check"] = value!;
//                             },
//                           );
//                           if(isProductPage){
//                             await productController.searchByCateg(query: productController.categoriesCheckFiltter);
//                             await productController.resetPagingList(selectedpag: 0);
//                           }
//                           else{
//                             productController.update();
//                             invoiceController!.categoriesCheckFiltter = productController.categoriesCheckFiltter;
//                             invoiceController.pagingController.refresh();
//                           }
//                           // await productController.searchByCateg(query: productController.categoriesCheckFiltter);
//                           // await productController.resetPagingList(
//                           //     selectedpag: 0);
//                         },
//                         title: Text(
//                           item.getPosCategoryNameBasedOnLang,
//                           style: TextStyle(
//                               color: const Color(0xff6F6F6F), fontSize: 3.sp),
//                         ),
//                       ),
//                       Divider(
//                         height: 0,
//                         color: AppColor.gray.withOpacity(0.3),
//                       )
//                     ],
//                   );
//                 }),
//               ]),
//         );
//       });
//     },
//   );
// }
