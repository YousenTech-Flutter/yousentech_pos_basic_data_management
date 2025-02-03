// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../core/config/app_colors.dart';
// import '../../../../core/config/app_enums.dart';
// import '../../../../core/config/app_lists.dart';
// import '../../../../core/config/app_styles.dart';
// import '../../../../core/shared_widgets/app_button.dart';
// import '../../../../core/shared_widgets/app_snack_bar.dart';
// import '../../../../core/shared_widgets/app_text_field.dart';
// import '../../../../core/utils/response_result.dart';
// import '../../../dashboard/domain/dashboard_viewmodel.dart';
// import '../data/product_unit.dart';
// import '../domain/product_unit_service.dart';
// import '../domain/product_unit_viewmodel.dart';

// class AddEditProductUnitScreen extends StatefulWidget {
//   ProductUnit? objectToEdit;

//   AddEditProductUnitScreen({super.key, this.objectToEdit});

//   @override
//   State<AddEditProductUnitScreen> createState() => _AddPosCategoryScreenState();
// }

// class _AddPosCategoryScreenState extends State<AddEditProductUnitScreen> {
//   final ProductUnitController posProductUnitController =
//       Get.put(ProductUnitController());
//   final TextEditingController nameController = TextEditingController();
//   final FocusNode nameFocusNode = FocusNode();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   ProductUnit? productUnit;
//   String? errorMessage;
//   int countErrors = 0;

//   //
//   back() {
//     posProductUnitController.updateHideMenu(false);
//     posProductUnitController.object = null;
//   }

//   @override
//   void initState() {
//     super.initState();
//     productUnit = widget.objectToEdit;
//     if (kDebugMode) {
//       print(productUnit?.name);
//     }
//     if (productUnit?.id != null) {
//       nameController.text = productUnit!.name!;
//     }
//   }

//   final DashboardController dashboardController =
//       Get.put(DashboardController.getInstance());

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ProductUnitController>(builder: (controller) {
//       return Center(
//         child: Container(
//           width: Get.width * 0.5,
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   TextButton(
//                       onPressed: () {
//                         back();
//                       },
//                       child: Text("${"units".tr} ")),
//                   Text(
//                       "/ ${(productUnit?.id == null) ? 'add_new_pos_unit'.tr : 'edit_pos_unit'.tr} "),
//                 ],
//               ),
//               Card(
//                 // surfaceTintColor: AppColor.white,
//                 child: Form(
//                   key: _formKey,
//                   child: Padding(
//                     padding: const EdgeInsets.all(30.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Center(
//                           child: sideUserMenu[SideUserMenu.dataManagement]![1]
//                                   .last
//                                   .first is IconData
//                               ? Icon(
//                                   sideUserMenu[SideUserMenu.dataManagement]![1]
//                                       .last
//                                       .first,
//                                   size:
//                                       MediaQuery.of(context).size.height * 0.1,
//                                   color: AppColor.purple,
//                                 )
//                               : Image.asset(
//                                   "assets/image/${sideUserMenu[SideUserMenu.dataManagement]![1].last.first}.png",
//                                   width:
//                                       MediaQuery.of(context).size.height * 0.1,
//                                   color: AppColor.purple,
//                                 ),
//                         ),

//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                     ((productUnit?.id == null)
//                                             ? 'add_new_pos_unit'
//                                             : 'edit_pos_unit')
//                                         .tr,
//                                     style: AppStyle.textStyle(
//                                         color: AppColor.black,
//                                         fontSize: Get.width * 0.02,
//                                         fontWeight: FontWeight.bold)
//                                     //  AppStyle.header1,
//                                     ),
//                                 Text('add_new_pos_category_message'.tr,
//                                     style: AppStyle.textStyle(
//                                         color: AppColor.grey,
//                                         fontSize: Get.width * 0.01,
//                                         fontWeight: FontWeight.bold)),
//                               ],
//                             ),
//                           ],
//                         ),
//                         // Text((sideUserMenu[SideUserMenu.prodects]!.last.first)
//                         //     .toString()),

//                         SizedBox(height: Get.height * 0.02),
//                         Text('pos_unit_name'.tr,
//                             style: AppStyle.textStyle(
//                                 color: AppColor.black,
//                                 fontSize: Get.width * 0.01,
//                                 fontWeight: FontWeight.bold)
//                             //  AppStyle.header1,
//                             ),
//                         SizedBox(height: Get.height * 0.01),

//                         Container(
//                           width: Get.width * 0.45,
//                           height: MediaQuery.sizeOf(context).height * 0.05,
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: AppColor.grey,
//                               ),
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(20))),
//                           child: ContainerTextField(
//                             focusNode: nameFocusNode,
//                             width: Get.width * 0.45,
//                             prefixIcon: Icons.person,
//                             height: MediaQuery.sizeOf(context).height * 0.05,
//                             controller: nameController,
//                             isPIN: true,
//                             hintText: 'pos_unit_name'.tr,
//                             labelText: 'pos_unit_name'.tr,
//                             hintcolor: AppColor.black.withOpacity(0.5),
//                             iconcolor: AppColor.black,
//                             color: AppColor.black,
//                             fontSize: Get.width * 0.01,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 errorMessage = 'required_message'.trParams(
//                                     {'field_name': 'pos_unit_name'.tr});
//                                 countErrors++;
//                                 return "";
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         SizedBox(height: Get.height * 0.02),

//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             ButtonElevated(
//                                 width: Get.width * 0.15,
//                                 text: 'cancel'.tr,
//                                 backgroundColor: AppColor.shadepurple,
//                                 onPressed: () {
//                                   back();
//                                 }),
//                             SizedBox(width: Get.width * 0.01),
//                             ButtonElevated(
//                                 text: (productUnit?.id != null
//                                         ? 'edit_pos_unit'
//                                         : 'add_new_pos_unit')
//                                     .tr,
//                                 width: Get.width * 0.15,
//                                 backgroundColor: AppColor.shadepurple,
//                                 onPressed: _onPressed),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   _onPressed() async {
//     ProductUnitService.productUnitDataServiceInstance = null;
//     ProductUnitService.getInstance();

//     countErrors = 0;
//     if (_formKey.currentState!.validate()) {
//       productUnit ??= ProductUnit()..name = nameController.text;
//       ResponseResult responseResult;
//       if (productUnit?.id == null) {
//         responseResult = await posProductUnitController.createProductUnit(
//             productUnit: productUnit!);
//       } else {
//         productUnit?.name = nameController.text;
//         responseResult = await posProductUnitController.updateProductUnit(
//             productUnit: productUnit!);
//       }
//       if (responseResult.status) {
//         if (widget.objectToEdit == null) {
//           posProductUnitController.productUnitList.add(responseResult.data!);
//         }
//         productUnit = null;
//         back();
//         appSnackBar(
//           messageType: MessageTypes.success,
//           message: responseResult.message,
//         );
//       } else {
//         appSnackBar(
//           message: responseResult.message,
//         );
//       }
//     } else {
//       appSnackBar(
//         message: countErrors > 1 ? 'enter_required_info'.tr : errorMessage!,
//       );
//     }
//   }
// }
