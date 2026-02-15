// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_shared_preferences/models/customer_model.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_enums.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';

import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:shared_widgets/utils/validator_helper.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/config/app_list.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/domain/customer_viewmodel.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/presentation/views/create_edit_customer.dart';

import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/product_screen.dart';
import 'package:yousentech_pos_invoice/invoices/domain/invoice_viewmodel.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_viewmodel.dart';

class CreateEditeCustomerMobile extends StatefulWidget {
  final Customer? objectToEdit;
  String? customerName;
  CreateEditeCustomerMobile({super.key, this.objectToEdit, this.customerName});

  @override
  State<CreateEditeCustomerMobile> createState() =>
      _CreateEditeCustomerMobileState();
}

class _CreateEditeCustomerMobileState extends State<CreateEditeCustomerMobile> {
  CustomerController customerController = Get.put(
    CustomerController(),
    tag: 'customerControllerMain',
  );
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController(),
      email = TextEditingController(),
      taxNumber = TextEditingController(),
      street = TextEditingController(),
      district = TextEditingController(),
      building = TextEditingController(),
      phone = TextEditingController(),
      otherSelleId = TextEditingController(),
      postalCode = TextEditingController(),
      additionalNo = TextEditingController(),
      l10nSaEdiPlotIdentification = TextEditingController(),
      city = TextEditingController();
  String errorMessage = '';
  int countErrors = 0;
  bool? _selectedOption;
  Customer? customer;
  @override
  void initState() {
    super.initState();
    customer = widget.objectToEdit != null
        ? Customer.fromJson(widget.objectToEdit!.toJson())
        : null;
    _selectedOption = false;
    if (customer?.id != null) {
      name.text = customer!.name!;
      email.text = customer!.email ?? '';
      phone.text = customer!.phone ?? '';
      taxNumber.text = customer!.vat ?? "";
      street.text = customer!.street ?? "";
      postalCode.text = customer!.postalCode ?? "";
      additionalNo.text = customer!.additionalNo ?? "";
      district.text = customer!.district ?? "";
      city.text = customer!.city ?? "";
      building.text = customer!.buildingNo ?? "";
      otherSelleId.text = customer!.otherSelleId ?? "";
      l10nSaEdiPlotIdentification.text =
          customer!.l10nSaEdiPlotIdentification ?? "";
      _selectedOption = customer!.isCompany;
    }
    if (widget.customerName != null) name.text = widget.customerName!;
    customer ??= Customer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Obx(() {
      return IgnorePointer(
        ignoring: customerController.isLoading.value,
        child: Scaffold(
            backgroundColor: Get.find<ThemeController>().isDarkMode.value
                ? AppColor.darkModeBackgroundColor
                : const Color(0xFFF6F6F6),
            appBar: customAppBar(
              context: context,
              isMobile: true,
              onDarkModeChanged: () {},
            ),
            body: Stack(
              children: [
                GetBuilder<CustomerController>(
                    tag: 'customerControllerMain',
                    builder: (controller) {
                      return Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(context.setMinSize(16.92)),
                            child: Column(
                              spacing: context.setHeight(19),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Get.find<ThemeController>()
                                            .isDarkMode
                                            .value
                                        ? const Color(0xFF2B2B2B)
                                        : AppColor.white,
                                    borderRadius: BorderRadius.circular(
                                        context.setMinSize(11.17)),
                                  ),
                                  child: Padding(
                                    padding:  EdgeInsets.all(context.setMinSize(10)),
                                    child: Row(
                                      spacing: context.setWidth(10),
                                      children: [
                                        Text(
                                          (customer?.id == null)
                                              ? "add_new_customer".tr
                                              : 'edit_customer'.tr,
                                          style: TextStyle(
                                            color: Get.find<ThemeController>()
                                                    .isDarkMode
                                                    .value
                                                ? AppColor.white
                                                : AppColor.black,
                                            fontSize: context.setSp(14),
                                            fontFamily: 'SansBold',
                                            fontWeight: FontWeight.w600,
                                            height: 1.56,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: ShapeDecoration(
                                    color: Get.find<ThemeController>()
                                            .isDarkMode
                                            .value
                                        ? const Color(0xFF232323)
                                        : AppColor.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1.06,
                                        color: Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? const Color(0x82474747)
                                            : const Color(0xFFF3F4F6),
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          context.setMinSize(11.17)),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    spacing: context.setWidth(
                                      10,
                                    ), // المسافة بين الخيارات
                                    children: customerType.map((
                                      option,
                                    ) {
                                      return Row(
                                        children: [
                                          Radio<bool>(
                                            side: BorderSide(
                                              color: Get.find<ThemeController>()
                                                      .isDarkMode
                                                      .value
                                                  ? const Color(
                                                      0xFFD1D5DB,
                                                    )
                                                  : const Color(
                                                      0xFF2F343C,
                                                    ),
                                              width: 1,
                                            ),
                                            activeColor: AppColor.appColor,
                                            value: option.isCompany,
                                            groupValue: _selectedOption ?? false,
                                            onChanged: (
                                              value,
                                            ) {
                                              _selectedOption = value;
                                              customerController.update();
                                            },
                                          ),
                                          Text(
                                            option.lable.tr,
                                            style: TextStyle(
                                              color: Get.find<ThemeController>()
                                                      .isDarkMode
                                                      .value
                                                  ? const Color(
                                                      0xFFD1D5DB,
                                                    )
                                                  : const Color(
                                                      0xFF2F343C,
                                                    ),
                                              fontSize: context.setSp(
                                                12,
                                              ),
                                              fontFamily: 'SansMedium',
                                              fontWeight: FontWeight.w500,
                                              height: 1.01,
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  // height: context.setHeight(240.01),
                                  height: context.setHeight(200),
                                  decoration: ShapeDecoration(
                                    color: Get.find<ThemeController>()
                                            .isDarkMode
                                            .value
                                        ? const Color(0xFF232323)
                                        : AppColor.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1.06,
                                        color: Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? const Color(0x82474747)
                                            : const Color(0xFFF3F4F6),
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          context.setMinSize(11.17)),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(context.setMinSize(20)),
                                    child: Column(
                                      spacing: context.setHeight(10),
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   'customer_image'.tr,
                                        //   textAlign: TextAlign.right,
                                        //   style: TextStyle(
                                        //     color: Get.find<ThemeController>()
                                        //             .isDarkMode
                                        //             .value
                                        //         ? AppColor.white
                                        //         : AppColor.black,
                                        //     fontSize: context.setSp(14),
                                        //     fontFamily: 'SansBold',
                                        //     fontWeight: FontWeight.w600,
                                        //     height: 1.56,
                                        //   ),
                                        // ),
                                        GestureDetector(
                                          onTap: () async {
                                            final ImagePicker picker =
                                                ImagePicker();
                                            final XFile? image =
                                                await picker.pickImage(
                                              source: ImageSource.gallery,
                                            );
                                            if (image != null) {
                                              String imagePath = image.path;
                                              File imageFile = File(imagePath);
                                              Uint8List bytes =
                                                  await imageFile.readAsBytes();
                                              String base64String = base64.encode(
                                                bytes,
                                              );
                                              customer!.image = base64String;
                                              setState(() {});
                                            }
                                          },
                                          child: CustomPaint(
                                            painter: DashedBorderPainter(),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                width: double.infinity,
                                                height:
                                                    context.setMinSize(143.80),
                                                alignment: Alignment.center,
                                                child: customer == null ||
                                                        customer!.image == null ||
                                                        customer!.image == ''
                                                    ? Center(
                                                        child: Column(
                                                          spacing: context
                                                              .setHeight(10.62),
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons.camera_alt,
                                                              size: context
                                                                  .setMinSize(
                                                                      25.64),
                                                              color: Colors.grey,
                                                            ),
                                                            Text(
                                                              "upload".tr,
                                                              style: TextStyle(
                                                                color: const Color(
                                                                    0xFF9CA3AF),
                                                                fontSize: context
                                                                    .setSp(12),
                                                                fontFamily:
                                                                    'Tajawal',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.43,
                                                              ),
                                                            ),
                                                            // Align(
                                                            //  alignment: Alignment.center,
                                                            //   child:
                                                            //     ButtonClick(
                                                            //       color: AppColor.appColor,
                                                            //       data: 'select_image'.tr,
                                                            //       onTap:null ,
                                                            //     ),
                        
                                                            // )
                                                          ],
                                                        ),
                                                      )
                                                    : isSvg(customer!.image!
                                                            .toString())
                                                        ? SvgPicture.memory(
                                                            base64.decode(
                                                                customer!.image!
                                                                    .toString()),
                                                            fit: BoxFit.cover,
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                          )
                                                        : Image.memory(
                                                            base64Decode(customer!
                                                                .image!
                                                                .toString()),
                                                            fit: BoxFit.cover,
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                            filterQuality:
                                                                FilterQuality
                                                                    .high,
                                                          ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: ShapeDecoration(
                                    color: Get.find<ThemeController>()
                                            .isDarkMode
                                            .value
                                        ? const Color(0xFF232323)
                                        : AppColor.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1.06,
                                        color: Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? const Color(0x82474747)
                                            : const Color(0xFFF3F4F6),
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          context.setMinSize(11.17)),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(context.setMinSize(20)),
                                    child: Column(
                                      spacing: context.setHeight(10),
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'main_customer_information'.tr,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Get.find<ThemeController>()
                                                    .isDarkMode
                                                    .value
                                                ? AppColor.white
                                                : AppColor.black,
                                            fontSize: context.setSp(14),
                                            fontFamily: 'SansBold',
                                            fontWeight: FontWeight.w600,
                                            height: 1.56,
                                          ),
                                        ),
                                        // name
                                        ContainerTextField(
                                          controller: name,
                                          labelText: 'customer_name'.tr,
                                          hintText: 'customer_name'.tr,
                                          keyboardType: TextInputType.text,
                                          width: context.screenWidth,
                                          height: context.setHeight(40),
                                          fontSize: context.setSp(14),
                                          contentPadding: EdgeInsets.fromLTRB(
                                            context.setWidth(9.36),
                                            context.setHeight(
                                              10.29,
                                            ),
                                            context.setWidth(7.86),
                                            context.setHeight(4.71),
                                          ),
                                          showLable: false,
                                          borderColor: Get.find<ThemeController>()
                                                  .isDarkMode
                                                  .value
                                              ? Colors.white.withValues(
                                                  alpha: 0.50,
                                                )
                                              : const Color(
                                                  0xFFC2C3CB,
                                                ),
                                          fillColor: !Get.find<ThemeController>()
                                                  .isDarkMode
                                                  .value
                                              ? Colors.white.withValues(
                                                  alpha: 0.43,
                                                )
                                              : const Color(
                                                  0xFF2B2B2B,
                                                ),
                                          hintcolor: !Get.find<ThemeController>()
                                                  .isDarkMode
                                                  .value
                                              ? const Color(
                                                  0xFF6B7280,
                                                )
                                              : const Color(
                                                  0xFF9CA3AF,
                                                ),
                                          color: !Get.find<ThemeController>()
                                                  .isDarkMode
                                                  .value
                                              ? const Color(
                                                  0xFF6B7280,
                                                )
                                              : const Color(
                                                  0xFF6B7280,
                                                ),
                                          isAddOrEdit: true,
                                          borderRadius: context.setMinSize(8),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: context.setWidth(10),
                                              vertical: context.setHeight(10),
                                            ),
                                            child: SvgPicture.asset(
                                              AppImages.partner,
                                              package: 'shared_widgets',
                                              color: AppColor.appColor,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              errorMessage =
                                                  'required_message_f'.trParams({
                                                'field_name': 'customer_name'.tr,
                                              });
                                              countErrors++;
                                              return "";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        if (_selectedOption != null &&
                                            _selectedOption!) ...[
                                          //street
                                          ContainerTextField(
                                            controller: street,
                                            labelText: 'street'.tr,
                                            hintText: 'street'.tr,
                                            keyboardType: TextInputType.text,
                                            width: context.screenWidth,
                                            height: context.setHeight(40),
                                            fontSize: context.setSp(
                                              14,
                                            ),
                                            contentPadding: EdgeInsets.fromLTRB(
                                              context.setWidth(
                                                9.36,
                                              ),
                                              context.setHeight(
                                                10.29,
                                              ),
                                              context.setWidth(
                                                7.86,
                                              ),
                                              context.setHeight(
                                                4.71,
                                              ),
                                            ),
                                            showLable: false,
                                            borderColor:
                                                Get.find<ThemeController>()
                                                        .isDarkMode
                                                        .value
                                                    ? Colors.white.withValues(
                                                        alpha: 0.50,
                                                      )
                                                    : const Color(
                                                        0xFFC2C3CB,
                                                      ),
                                            fillColor:
                                                !Get.find<ThemeController>()
                                                        .isDarkMode
                                                        .value
                                                    ? Colors.white.withValues(
                                                        alpha: 0.43,
                                                      )
                                                    : const Color(
                                                        0xFF2B2B2B,
                                                      ),
                                            hintcolor:
                                                !Get.find<ThemeController>()
                                                        .isDarkMode
                                                        .value
                                                    ? const Color(
                                                        0xFF6B7280,
                                                      )
                                                    : const Color(
                                                        0xFF9CA3AF,
                                                      ),
                                            color: !Get.find<ThemeController>()
                                                    .isDarkMode
                                                    .value
                                                ? const Color(
                                                    0xFF6B7280,
                                                  )
                                                : const Color(
                                                    0xFF6B7280,
                                                  ),
                                            isAddOrEdit: true,
                                            borderRadius: context.setMinSize(8),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: context.setWidth(
                                                  6.3,
                                                ),
                                                vertical: context.setHeight(
                                                  6.3,
                                                ),
                                              ),
                                              child: SvgPicture.asset(
                                                AppImages.dIV59,
                                                package: 'shared_widgets',
                                              ),
                                            ),
                                            validator: (value) {
                                              if (_selectedOption! &&
                                                  (value == null ||
                                                      value.isEmpty)) {
                                                errorMessage =
                                                    'required_message_f'
                                                        .trParams({
                                                  'field_name': 'street'.tr,
                                                });
                                                countErrors++;
                                                return "";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          // district
                                          ContainerTextField(
                                            controller: district,
                                            labelText: 'district'.tr,
                                            hintText: 'district'.tr,
                                            keyboardType: TextInputType.text,
                                            width: context.screenWidth,
                                            height: context.setHeight(40),
                                            fontSize: context.setSp(
                                              14,
                                            ),
                                            contentPadding: EdgeInsets.fromLTRB(
                                              context.setWidth(
                                                9.36,
                                              ),
                                              context.setHeight(
                                                10.29,
                                              ),
                                              context.setWidth(
                                                7.86,
                                              ),
                                              context.setHeight(
                                                4.71,
                                              ),
                                            ),
                                            showLable: false,
                                            borderColor:
                                                Get.find<ThemeController>()
                                                        .isDarkMode
                                                        .value
                                                    ? Colors.white.withValues(
                                                        alpha: 0.50,
                                                      )
                                                    : const Color(
                                                        0xFFC2C3CB,
                                                      ),
                                            fillColor:
                                                !Get.find<ThemeController>()
                                                        .isDarkMode
                                                        .value
                                                    ? Colors.white.withValues(
                                                        alpha: 0.43,
                                                      )
                                                    : const Color(
                                                        0xFF2B2B2B,
                                                      ),
                                            hintcolor:
                                                !Get.find<ThemeController>()
                                                        .isDarkMode
                                                        .value
                                                    ? const Color(
                                                        0xFF6B7280,
                                                      )
                                                    : const Color(
                                                        0xFF9CA3AF,
                                                      ),
                                            color: !Get.find<ThemeController>()
                                                    .isDarkMode
                                                    .value
                                                ? const Color(
                                                    0xFF6B7280,
                                                  )
                                                : const Color(
                                                    0xFF6B7280,
                                                  ),
                                            isAddOrEdit: true,
                                            borderRadius: context.setMinSize(8),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: context.setWidth(
                                                  6.3,
                                                ),
                                                vertical: context.setHeight(
                                                  6.3,
                                                ),
                                              ),
                                              child: SvgPicture.asset(
                                                AppImages.dIV59,
                                                package: 'shared_widgets',
                                              ),
                                            ),
                                            validator: (value) {
                                              if (_selectedOption! &&
                                                  (value == null ||
                                                      value.isEmpty)) {
                                                errorMessage =
                                                    'required_message_f'
                                                        .trParams({
                                                  'field_name': 'district'.tr,
                                                });
                                                countErrors++;
                                                return "";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          // building_no
                                          ContainerTextField(
                                            controller: building,
                                            labelText: 'building_no'.tr,
                                            hintText: 'building_no'.tr,
                                            keyboardType: TextInputType.text,
                                            width: context.screenWidth,
                                            height: context.setHeight(40),
                                            fontSize: context.setSp(
                                              14,
                                            ),
                                            contentPadding: EdgeInsets.fromLTRB(
                                              context.setWidth(
                                                9.36,
                                              ),
                                              context.setHeight(
                                                10.29,
                                              ),
                                              context.setWidth(
                                                7.86,
                                              ),
                                              context.setHeight(
                                                4.71,
                                              ),
                                            ),
                                            showLable: false,
                                            borderColor:
                                                Get.find<ThemeController>()
                                                        .isDarkMode
                                                        .value
                                                    ? Colors.white.withValues(
                                                        alpha: 0.50,
                                                      )
                                                    : const Color(
                                                        0xFFC2C3CB,
                                                      ),
                                            fillColor:
                                                !Get.find<ThemeController>()
                                                        .isDarkMode
                                                        .value
                                                    ? Colors.white.withValues(
                                                        alpha: 0.43,
                                                      )
                                                    : const Color(
                                                        0xFF2B2B2B,
                                                      ),
                                            hintcolor:
                                                !Get.find<ThemeController>()
                                                        .isDarkMode
                                                        .value
                                                    ? const Color(
                                                        0xFF6B7280,
                                                      )
                                                    : const Color(
                                                        0xFF9CA3AF,
                                                      ),
                                            color: !Get.find<ThemeController>()
                                                    .isDarkMode
                                                    .value
                                                ? const Color(
                                                    0xFF6B7280,
                                                  )
                                                : const Color(
                                                    0xFF6B7280,
                                                  ),
                                            isAddOrEdit: true,
                                            borderRadius: context.setMinSize(8),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: context.setWidth(
                                                  6.3,
                                                ),
                                                vertical: context.setHeight(
                                                  6.3,
                                                ),
                                              ),
                                              child: SvgPicture.asset(
                                                AppImages.dIV59,
                                                package: 'shared_widgets',
                                              ),
                                            ),
                                            validator: (value) {
                                              if (_selectedOption! &&
                                                  (value == null ||
                                                      value.isEmpty)) {
                                                errorMessage =
                                                    'required_message_f'
                                                        .trParams({
                                                  'field_name': 'building_no'.tr,
                                                });
                                                countErrors++;
                                                return "";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: ShapeDecoration(
                                    color: Get.find<ThemeController>()
                                            .isDarkMode
                                            .value
                                        ? const Color(0xFF232323)
                                        : AppColor.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1.06,
                                        color: Get.find<ThemeController>()
                                                .isDarkMode
                                                .value
                                            ? const Color(0x82474747)
                                            : const Color(0xFFF3F4F6),
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          context.setMinSize(11.17)),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(context.setMinSize(20)),
                                    child: Column(
                                      spacing: context.setHeight(10),
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'more_options'.tr,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Get.find<ThemeController>()
                                                        .isDarkMode
                                                        .value
                                                    ? AppColor.white
                                                    : AppColor.black,
                                                fontSize: context.setSp(14),
                                                fontFamily: 'SansBold',
                                                fontWeight: FontWeight.w600,
                                                height: 1.56,
                                              ),
                                            ),
                                            Obx(() {
                                                return GestureDetector(
                                                  onTap: () {
                                                    customerController
                                                        .toggleCustomerViewOptionsInfo();
                                                  },
                                                  child: Container(
                                                      width: context.setWidth(30),
                                                      height:
                                                          context.setHeight(30),
                                                      decoration: ShapeDecoration(
                                                        color: Get.find<
                                                                    ThemeController>()
                                                                .isDarkMode
                                                                .value
                                                            ? const Color(0xFF202020)
                                                            : const Color(0xFFF1F1F1),
                                                        shape: RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            width: 1.06,
                                                            color: const Color(
                                                                0x21848484),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  context.setMinSize(
                                                                      6.34)),
                                                        ),
                                                      ),
                                                      child: Center(
                                                          child: Transform(
                                                        alignment: Alignment.center,
                                                        transform: Matrix4.rotationX(
                                                          customerController
                                                                  .showCustomerOptionsInfo
                                                                  .value
                                                              ? 0
                                                              : 3.14,
                                                        ),
                                                        child: SvgPicture.asset(
                                                          AppImages.arrowDown,
                                                          package: 'shared_widgets',
                                                          // width:
                                                          //     context.setWidth(20),
                                                          // height: context
                                                          //     .setHeight(20),
                                                        ),
                                                      ))),
                                                );
                                              }
                                            )
                                          ],
                                        ),
                                        Obx(() {
                                          return customerController
                                                  .showCustomerOptionsInfo.value
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  spacing: context.setHeight(10),
                                                  children: [
                                                    
                                                        // phone
                                                        ContainerTextField(
                                                                                                                  controller: phone,
                                                                                                                  labelText: 'phone'.tr,
                                                                                                                  hintText: 'phone'.tr,
                                                                                                                  inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(
                                                          RegExp(r'[0-9]+'),
                                                        ),
                                                                                                                  ],
                                                                                                                  keyboardType:
                                                          TextInputType
                                                              .number,
                                                                                                                  width: context
                                                          .screenWidth,
                                                                                                                  height: context
                                                          .setHeight(40),
                                                                                                                  fontSize:
                                                          context.setSp(
                                                        14,
                                                                                                                  ),
                                                                                                                  contentPadding:
                                                          EdgeInsets
                                                              .fromLTRB(
                                                        context.setWidth(
                                                          9.36,
                                                        ),
                                                        context.setHeight(
                                                          10.29,
                                                        ),
                                                        context.setWidth(
                                                          7.86,
                                                        ),
                                                        context.setHeight(
                                                          4.71,
                                                        ),
                                                                                                                  ),
                                                                                                                  showLable: false,
                                                                                                                  borderColor: Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? Colors.white
                                                              .withValues(
                                                              alpha: 0.50,
                                                            )
                                                          : const Color(
                                                              0xFFC2C3CB,
                                                            ),
                                                                                                                  fillColor: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? Colors.white
                                                              .withValues(
                                                              alpha: 0.43,
                                                            )
                                                          : const Color(
                                                              0xFF2B2B2B,
                                                            ),
                                                                                                                  hintcolor: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? const Color(
                                                              0xFF6B7280,
                                                            )
                                                          : const Color(
                                                              0xFF9CA3AF,
                                                            ),
                                                                                                                  color: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? const Color(
                                                              0xFF6B7280,
                                                            )
                                                          : const Color(
                                                              0xFF6B7280,
                                                            ),
                                                                                                                  isAddOrEdit: true,
                                                                                                                  borderRadius: context
                                                          .setMinSize(8),
                                                                                                                  prefixIcon: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              context
                                                                  .setWidth(
                                                            6.3,
                                                          ),
                                                          vertical: context
                                                              .setHeight(
                                                            6.3,
                                                          ),
                                                        ),
                                                        child: SvgPicture
                                                            .asset(
                                                          AppImages.dIV59,
                                                          package:
                                                              'shared_widgets',
                                                        ),
                                                                                                                  ),
                                                                                                                ),
                                                        // email
                                                        ContainerTextField(
                                                                                                                  controller: email,
                                                                                                                  labelText: 'email'.tr,
                                                                                                                  hintText: 'email'.tr,
                                                                                                                  keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                                                                                  width: context
                                                          .screenWidth,
                                                                                                                  height: context
                                                          .setHeight(40),
                                                                                                                  fontSize:
                                                          context.setSp(
                                                        14,
                                                                                                                  ),
                                                                                                                  contentPadding:
                                                          EdgeInsets
                                                              .fromLTRB(
                                                        context.setWidth(
                                                          9.36,
                                                        ),
                                                        context.setHeight(
                                                          10.29,
                                                        ),
                                                        context.setWidth(
                                                          7.86,
                                                        ),
                                                        context.setHeight(
                                                          4.71,
                                                        ),
                                                                                                                  ),
                                                                                                                  showLable: false,
                                                                                                                  borderColor: Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? Colors.white
                                                              .withValues(
                                                              alpha: 0.50,
                                                            )
                                                          : const Color(
                                                              0xFFC2C3CB,
                                                            ),
                                                                                                                  fillColor: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? Colors.white
                                                              .withValues(
                                                              alpha: 0.43,
                                                            )
                                                          : const Color(
                                                              0xFF2B2B2B,
                                                            ),
                                                                                                                  hintcolor: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? const Color(
                                                              0xFF6B7280,
                                                            )
                                                          : const Color(
                                                              0xFF9CA3AF,
                                                            ),
                                                                                                                  color: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? const Color(
                                                              0xFF6B7280,
                                                            )
                                                          : const Color(
                                                              0xFF6B7280,
                                                            ),
                                                                                                                  isAddOrEdit: true,
                                                                                                                  borderRadius: context
                                                          .setMinSize(8),
                                                                                                                  prefixIcon: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              context
                                                                  .setWidth(
                                                            6.3,
                                                          ),
                                                          vertical: context
                                                              .setHeight(
                                                            6.3,
                                                          ),
                                                        ),
                                                        child: SvgPicture
                                                            .asset(
                                                          AppImages.dIV59,
                                                          package:
                                                              'shared_widgets',
                                                        ),
                                                                                                                  ),
                                                                                                                  validator: (value) {
                                                        var message =
                                                            ValidatorHelper
                                                                .emailValidation(
                                                          value: value!,
                                                          field: 'email'.tr,
                                                        );
                                                        if (message == "") {
                                                          return null;
                                                        }
                                                        errorMessage =
                                                            message;
                                                        countErrors++;
                                                        return "";
                                                                                                                  },
                                                                                                                ),
                                                    
                                                    
                                                        // city
                                                        ContainerTextField(
                                                                                                                  controller: city,
                                                                                                                  labelText: 'city'.tr,
                                                                                                                  hintText: 'city'.tr,
                                                                                                                  keyboardType:
                                                          TextInputType
                                                              .text,
                                                                                                                  width: context
                                                          .screenWidth,
                                                                                                                  height: context
                                                          .setHeight(40),
                                                                                                                  fontSize:
                                                          context.setSp(
                                                        14,
                                                                                                                  ),
                                                                                                                  contentPadding:
                                                          EdgeInsets
                                                              .fromLTRB(
                                                        context.setWidth(
                                                          9.36,
                                                        ),
                                                        context.setHeight(
                                                          10.29,
                                                        ),
                                                        context.setWidth(
                                                          7.86,
                                                        ),
                                                        context.setHeight(
                                                          4.71,
                                                        ),
                                                                                                                  ),
                                                                                                                  showLable: false,
                                                                                                                  borderColor: Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? Colors.white
                                                              .withValues(
                                                              alpha: 0.50,
                                                            )
                                                          : const Color(
                                                              0xFFC2C3CB,
                                                            ),
                                                                                                                  fillColor: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? Colors.white
                                                              .withValues(
                                                              alpha: 0.43,
                                                            )
                                                          : const Color(
                                                              0xFF2B2B2B,
                                                            ),
                                                                                                                  hintcolor: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? const Color(
                                                              0xFF6B7280,
                                                            )
                                                          : const Color(
                                                              0xFF9CA3AF,
                                                            ),
                                                                                                                  color: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? const Color(
                                                              0xFF6B7280,
                                                            )
                                                          : const Color(
                                                              0xFF6B7280,
                                                            ),
                                                                                                                  isAddOrEdit: true,
                                                                                                                  borderRadius: context
                                                          .setMinSize(8),
                                                                                                                  prefixIcon: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              context
                                                                  .setWidth(
                                                            6.3,
                                                          ),
                                                          vertical: context
                                                              .setHeight(
                                                            6.3,
                                                          ),
                                                        ),
                                                        child: SvgPicture
                                                            .asset(
                                                          AppImages.dIV59,
                                                          package:
                                                              'shared_widgets',
                                                        ),
                                                                                                                  ),
                                                                                                                ),
                                                        // l10n_sa_edi_plot_identification
                                                        ContainerTextField(
                                                                                                                  controller:
                                                          l10nSaEdiPlotIdentification,
                                                                                                                  labelText:
                                                          'l10n_sa_edi_plot_identification'
                                                              .tr,
                                                                                                                  hintText:
                                                          'l10n_sa_edi_plot_identification'
                                                              .tr,
                                                                                                                  keyboardType:
                                                          TextInputType
                                                              .text,
                                                                                                                  width: context
                                                          .screenWidth,
                                                                                                                  height: context
                                                          .setHeight(40),
                                                                                                                  fontSize:
                                                          context.setSp(
                                                        14,
                                                                                                                  ),
                                                                                                                  contentPadding:
                                                          EdgeInsets
                                                              .fromLTRB(
                                                        context.setWidth(
                                                          9.36,
                                                        ),
                                                        context.setHeight(
                                                          10.29,
                                                        ),
                                                        context.setWidth(
                                                          7.86,
                                                        ),
                                                        context.setHeight(
                                                          4.71,
                                                        ),
                                                                                                                  ),
                                                                                                                  showLable: false,
                                                                                                                  borderColor: Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? Colors.white
                                                              .withValues(
                                                              alpha: 0.50,
                                                            )
                                                          : const Color(
                                                              0xFFC2C3CB,
                                                            ),
                                                                                                                  fillColor: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? Colors.white
                                                              .withValues(
                                                              alpha: 0.43,
                                                            )
                                                          : const Color(
                                                              0xFF2B2B2B,
                                                            ),
                                                                                                                  hintcolor: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? const Color(
                                                              0xFF6B7280,
                                                            )
                                                          : const Color(
                                                              0xFF9CA3AF,
                                                            ),
                                                                                                                  color: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? const Color(
                                                              0xFF6B7280,
                                                            )
                                                          : const Color(
                                                              0xFF6B7280,
                                                            ),
                                                                                                                  isAddOrEdit: true,
                                                                                                                  borderRadius: context
                                                          .setMinSize(8),
                                                                                                                  prefixIcon: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              context
                                                                  .setWidth(
                                                            6.3,
                                                          ),
                                                          vertical: context
                                                              .setHeight(
                                                            6.3,
                                                          ),
                                                        ),
                                                        child: SvgPicture
                                                            .asset(
                                                          AppImages.dIV59,
                                                          package:
                                                              'shared_widgets',
                                                        ),
                                                                                                                  ),
                                                                                                                ),
                                                    
                                                    
                                                        // additional_no
                                                        ContainerTextField(
                                                                                                                  controller:
                                                          additionalNo,
                                                                                                                  labelText:
                                                          'additional_no'
                                                              .tr,
                                                                                                                  hintText:
                                                          'additional_no'
                                                              .tr,
                                                                                                                  keyboardType:
                                                          TextInputType
                                                              .text,
                                                                                                                  width: context
                                                          .screenWidth,
                                                                                                                  height: context
                                                          .setHeight(40),
                                                                                                                  fontSize:
                                                          context.setSp(
                                                        14,
                                                                                                                  ),
                                                                                                                  contentPadding:
                                                          EdgeInsets
                                                              .fromLTRB(
                                                        context.setWidth(
                                                          9.36,
                                                        ),
                                                        context.setHeight(
                                                          10.29,
                                                        ),
                                                        context.setWidth(
                                                          7.86,
                                                        ),
                                                        context.setHeight(
                                                          4.71,
                                                        ),
                                                                                                                  ),
                                                                                                                  showLable: false,
                                                                                                                  borderColor: Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? Colors.white
                                                              .withValues(
                                                              alpha: 0.50,
                                                            )
                                                          : const Color(
                                                              0xFFC2C3CB,
                                                            ),
                                                                                                                  fillColor: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? Colors.white
                                                              .withValues(
                                                              alpha: 0.43,
                                                            )
                                                          : const Color(
                                                              0xFF2B2B2B,
                                                            ),
                                                                                                                  hintcolor: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? const Color(
                                                              0xFF6B7280,
                                                            )
                                                          : const Color(
                                                              0xFF9CA3AF,
                                                            ),
                                                                                                                  color: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? const Color(
                                                              0xFF6B7280,
                                                            )
                                                          : const Color(
                                                              0xFF6B7280,
                                                            ),
                                                                                                                  isAddOrEdit: true,
                                                                                                                  borderRadius: context
                                                          .setMinSize(8),
                                                                                                                  prefixIcon: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              context
                                                                  .setWidth(
                                                            6.3,
                                                          ),
                                                          vertical: context
                                                              .setHeight(
                                                            6.3,
                                                          ),
                                                        ),
                                                        child: SvgPicture
                                                            .asset(
                                                          AppImages.dIV59,
                                                          package:
                                                              'shared_widgets',
                                                        ),
                                                                                                                  ),
                                                                                                                ),
                                                        // postal_code
                                                        ContainerTextField(
                                                                                                                  controller:
                                                          postalCode,
                                                                                                                  labelText:
                                                          'postal_code'.tr,
                                                                                                                  hintText:
                                                          'postal_code'.tr,
                                                                                                                  keyboardType:
                                                          TextInputType
                                                              .text,
                                                                                                                  width: context
                                                          .screenWidth,
                                                                                                                  height: context
                                                          .setHeight(40),
                                                                                                                  fontSize:
                                                          context.setSp(
                                                        14,
                                                                                                                  ),
                                                                                                                  contentPadding:
                                                          EdgeInsets
                                                              .fromLTRB(
                                                        context.setWidth(
                                                          9.36,
                                                        ),
                                                        context.setHeight(
                                                          10.29,
                                                        ),
                                                        context.setWidth(
                                                          7.86,
                                                        ),
                                                        context.setHeight(
                                                          4.71,
                                                        ),
                                                                                                                  ),
                                                                                                                  showLable: false,
                                                                                                                  borderColor: Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? Colors.white
                                                              .withValues(
                                                              alpha: 0.50,
                                                            )
                                                          : const Color(
                                                              0xFFC2C3CB,
                                                            ),
                                                                                                                  fillColor: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? Colors.white
                                                              .withValues(
                                                              alpha: 0.43,
                                                            )
                                                          : const Color(
                                                              0xFF2B2B2B,
                                                            ),
                                                                                                                  hintcolor: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? const Color(
                                                              0xFF6B7280,
                                                            )
                                                          : const Color(
                                                              0xFF9CA3AF,
                                                            ),
                                                                                                                  color: !Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value
                                                          ? const Color(
                                                              0xFF6B7280,
                                                            )
                                                          : const Color(
                                                              0xFF6B7280,
                                                            ),
                                                                                                                  isAddOrEdit: true,
                                                                                                                  borderRadius: context
                                                          .setMinSize(8),
                                                                                                                  prefixIcon: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              context
                                                                  .setWidth(
                                                            6.3,
                                                          ),
                                                          vertical: context
                                                              .setHeight(
                                                            6.3,
                                                          ),
                                                        ),
                                                        child: SvgPicture
                                                            .asset(
                                                          AppImages.dIV59,
                                                          package:
                                                              'shared_widgets',
                                                        ),
                                                                                                                  ),
                                                                                                                ),
                                                    
                                                    if (_selectedOption != null &&
                                                        _selectedOption!) ...[
                                                      
                                                          // tax_number
                                                          ContainerTextField(
                                                                                                                      controller:
                                                            taxNumber,
                                                                                                                      labelText:
                                                            'tax_number'.tr,
                                                                                                                      hintText:
                                                            'tax_number'.tr,
                                                                                                                      inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(
                                                            RegExp('[0-9]'),
                                                          ),
                                                                                                                      ],
                                                                                                                      keyboardType:
                                                            TextInputType
                                                                .name,
                                                                                                                      width: context
                                                            .screenWidth,
                                                                                                                      height: context
                                                            .setHeight(40),
                                                                                                                      fontSize: context
                                                            .setSp(14),
                                                                                                                      contentPadding:
                                                            EdgeInsets
                                                                .fromLTRB(
                                                          context.setWidth(
                                                            9.36,
                                                          ),
                                                          context.setHeight(
                                                            10.29,
                                                          ),
                                                          context.setWidth(
                                                            7.86,
                                                          ),
                                                          context.setHeight(
                                                            4.71,
                                                          ),
                                                                                                                      ),
                                                                                                                      showLable: false,
                                                                                                                      borderColor: Get.find<
                                                                    ThemeController>()
                                                                .isDarkMode
                                                                .value
                                                            ? Colors.white
                                                                .withValues(
                                                                alpha: 0.50,
                                                              )
                                                            : const Color(
                                                                0xFFC2C3CB,
                                                              ),
                                                                                                                      fillColor: !Get.find<
                                                                    ThemeController>()
                                                                .isDarkMode
                                                                .value
                                                            ? Colors.white
                                                                .withValues(
                                                                alpha: 0.43,
                                                              )
                                                            : const Color(
                                                                0xFF2B2B2B,
                                                              ),
                                                                                                                      hintcolor: !Get.find<
                                                                    ThemeController>()
                                                                .isDarkMode
                                                                .value
                                                            ? const Color(
                                                                0xFF6B7280,
                                                              )
                                                            : const Color(
                                                                0xFF9CA3AF,
                                                              ),
                                                                                                                      color: !Get.find<
                                                                    ThemeController>()
                                                                .isDarkMode
                                                                .value
                                                            ? const Color(
                                                                0xFF6B7280,
                                                              )
                                                            : const Color(
                                                                0xFF6B7280,
                                                              ),
                                                                                                                      isAddOrEdit: true,
                                                                                                                      borderRadius:
                                                            context
                                                                .setMinSize(
                                                                    8),
                                                                                                                      prefixIcon: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                context
                                                                    .setWidth(
                                                              6.3,
                                                            ),
                                                            vertical: context
                                                                .setHeight(
                                                              6.3,
                                                            ),
                                                          ),
                                                          child: SvgPicture
                                                              .asset(
                                                            AppImages.dIV59,
                                                            package:
                                                                'shared_widgets',
                                                          ),
                                                                                                                      ),
                                                                                                                    ),
                                                          //other_selleId
                                                          ContainerTextField(
                                                                                                                      controller:
                                                            otherSelleId,
                                                                                                                      labelText:
                                                            'other_selleId'
                                                                .tr,
                                                                                                                      hintText:
                                                            'other_selleId'
                                                                .tr,
                                                                                                                      inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(
                                                            RegExp('[0-9]'),
                                                          ),
                                                                                                                      ],
                                                                                                                      keyboardType:
                                                            TextInputType
                                                                .number,
                                                                                                                      // textAlign: TextAlign.justify,
                                                                                                                      width: context
                                                            .screenWidth,
                                                                                                                      height: context
                                                            .setHeight(40),
                                                                                                                      fontSize: context
                                                            .setSp(14),
                                                                                                                      contentPadding:
                                                            EdgeInsets
                                                                .fromLTRB(
                                                          context.setWidth(
                                                            9.36,
                                                          ),
                                                          context.setHeight(
                                                            10.29,
                                                          ),
                                                          context.setWidth(
                                                            7.86,
                                                          ),
                                                          context.setHeight(
                                                            4.71,
                                                          ),
                                                                                                                      ),
                                                                                                                      showLable: false,
                                                                                                                      borderColor: Get.find<
                                                                    ThemeController>()
                                                                .isDarkMode
                                                                .value
                                                            ? Colors.white
                                                                .withValues(
                                                                alpha: 0.50,
                                                              )
                                                            : const Color(
                                                                0xFFC2C3CB,
                                                              ),
                                                                                                                      fillColor: !Get.find<
                                                                    ThemeController>()
                                                                .isDarkMode
                                                                .value
                                                            ? Colors.white
                                                                .withValues(
                                                                alpha: 0.43,
                                                              )
                                                            : const Color(
                                                                0xFF2B2B2B,
                                                              ),
                                                                                                                      hintcolor: !Get.find<
                                                                    ThemeController>()
                                                                .isDarkMode
                                                                .value
                                                            ? const Color(
                                                                0xFF6B7280,
                                                              )
                                                            : const Color(
                                                                0xFF9CA3AF,
                                                              ),
                                                                                                                      color: !Get.find<
                                                                    ThemeController>()
                                                                .isDarkMode
                                                                .value
                                                            ? const Color(
                                                                0xFF6B7280,
                                                              )
                                                            : const Color(
                                                                0xFF6B7280,
                                                              ),
                                                                                                                      isAddOrEdit: true,
                                                                                                                      borderRadius:
                                                            context
                                                                .setMinSize(
                                                                    8),
                                                                                                                      prefixIcon: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                context
                                                                    .setWidth(
                                                              10,
                                                            ),
                                                            vertical: context
                                                                .setHeight(
                                                              10,
                                                            ),
                                                          ),
                                                          child: SvgPicture
                                                              .asset(
                                                            AppImages
                                                                .partner,
                                                            package:
                                                                'shared_widgets',
                                                            color:
                                                                const Color(
                                                              0xFF16A6B7,
                                                            ),
                                                          ),
                                                                                                                      ),
                                                                                                                    ),
                                                      
                                                    ],
                                                  ],
                                                )
                                              : Container();
                                        })
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  spacing: context.setWidth(16),
                                  children: [
                                    Expanded(
                                      child: ButtonClick(
                                        color: AppColor.appColor,
                                        data: 'save'.tr,
                                        // (customer?.id != null)
                                        //               ? 'edit_customer'.tr
                                        //               : 'add_new_customer'.tr,
                                        onTap: _onPressed,
                                      ),
                                    ),
                                    Expanded(
                                      child: ButtonClick(
                                        color: const Color(0xFF4B5563),
                                        data: "back".tr,
                                        onTap: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                customerController.isLoading.value
                    ? const LoadingWidget()
                    : Container(),
              ],
            )),
      );
    }));
  }

  _onPressed() async {
    try {
      LoadingDataController loadingDataController =
          Get.find<LoadingDataController>();
      customerController.isLoading.value = true;
      customerController.searchResults.clear();
      customerController.update();
      countErrors = 0;
      errorMessage = '';
      if (_formKey.currentState!.validate()) {
        customer?.name = name.text.trim();
        customer?.email = email.text == '' ? null : email.text;
        customer?.phone = phone.text;
        customer?.street = street.text;
        customer?.district = district.text;
        customer?.buildingNo = building.text;
        customer?.vat = taxNumber.text;
        customer?.customerRank = 1;
        customer?.isCompany = _selectedOption;
        customer?.otherSelleId = otherSelleId.text;
        var func = customer?.id != null
            ? await customerController.updateCustomerRemotAndLocal(
                id: customer!.id!.toInt(),
                customer: customer!,
              )
            : await customerController.createCustomerRemotAndLocal(
                customer: customer!,
              );

        await loadingDataController.getitems();
        if (func.status) {
          InvoiceController invoiceController =
              Get.isRegistered<InvoiceController>()
                  ? Get.find<InvoiceController>()
                  : Get.put(InvoiceController());

          // if (objectToEdit == null ) {
          //   if(pagesNumber == 1){
          //     customerController.customerpagingList.add(func.data);
          //   }

          // }
          var customerIndex = customerController.customerpagingList.indexWhere(
            (item) => item.id == widget.objectToEdit?.id,
          );
          if (customerIndex != -1) {
            customerController.customerpagingList[customerIndex] = customer!;
          }
          customerController.update();
          customer = null;
          customerController.isLoading.value = false;
          customerController.update();
          invoiceController.update();
          appSnackBar(messageType: MessageTypes.success, message: func.message);
          // Get.back();
          customerController.pagnationpagesNumber = 0;
          await customerController.resetPagingList(selectedpag: 0);
          if (widget.customerName != null) {
            invoiceController.changeSelection(
              func.data.id!,
              name.text.trim(),
              phone.text.trim(),
              email.text.trim(),
            );

            // Get.back();
            // if (invoiceController.isDialogOpen) {
            //   Get.back();
            //   invoiceController.isDialogOpen = false;
            // }
          }
          Get.back(closeOverlays: true);
        } else {
          customerController.isLoading.value = false;
          customerController.update();

          appSnackBar(message: func.message);
        }
        customerController.isLoading.value = false;
        customerController.update();
      } else {
        appSnackBar(
          message: countErrors == 3 ? 'enter_required_info'.tr : errorMessage,
        );
        customerController.isLoading.value = false;
        customerController.update();
      }
    } catch (e) {
      customerController.isLoading.value = false;
      appSnackBar(status: false, message: e.toString());
    }
  }
}
