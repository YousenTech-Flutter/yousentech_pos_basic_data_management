// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:pos_shared_preferences/models/customer_model.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_enums.dart';
import 'package:shared_widgets/config/app_styles.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
import 'package:shared_widgets/utils/validator_helper.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/config/app_list.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/domain/customer_viewmodel.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/widget/tital.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/config/app_enums.dart';

// ignore: must_be_immutable
class AddCustomerScreen extends StatefulWidget {
  Customer? objectToEdit;

  AddCustomerScreen({super.key, this.objectToEdit});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final FocusNode nameFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Customer? customer;
  String errorMessage = '';
  int countErrors = 0;
  int pagesNumber = 0;
  String completeNumber = '';
  bool? _selectedOption;
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

  CustomerController customerController =
      Get.put(CustomerController(), tag: 'customerControllerMain');
  back() async {
    customerController.updateHideMenu(false);
    customerController.object = null;
  }

  @override
  void initState() {
    super.initState();
    customer = widget.objectToEdit != null
        ? Customer.fromJson(widget.objectToEdit!.toJson())
        : null;
    if (customer?.id != null) {
      name.text = customer!.name!;
      email.text = customer!.email ?? '';
      phone.text = customer!.phone ?? '';
      taxNumber.text = customer!.vat ?? "";
      street.text = customer!.street ?? "";
      postalCode.text = customer!.postalCode ?? "";
      additionalNo .text = customer!.additionalNo ?? "";
      district.text = customer!.district ?? "";
      city.text = customer!.city ?? "";
      building.text = customer!.buildingNo ?? "";
      otherSelleId.text = customer!.otherSelleId ?? "";
      l10nSaEdiPlotIdentification.text = customer!.l10nSaEdiPlotIdentification ?? "";
      _selectedOption = customer!.isCompany;
    }
    customer ??= Customer();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerController>(
        tag: 'customerControllerMain',
        builder: (controller) {
          return IgnorePointer(
            ignoring: customerController.isLoading.value,
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: Get.width * 0.6,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitalWidget(
                              title: (customer?.id == null)
                                  ? 'add_new_customer'.tr
                                  : 'edit_customer'.tr),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10.r, left: 20.r, right: 20.r),
                            child: Card(
                              color: AppColor.white,
                              surfaceTintColor: AppColor.white,
                              elevation: 5,
                              shadowColor: AppColor.semitransparentblack,
                              child: Form(
                                key: _formKey,
                                child: Padding(
                                  padding: EdgeInsets.all(10.r),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: Get.width * 0.2,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: customerType
                                                        .map((option) {
                                                      return Expanded(
                                                        child:
                                                            RadioListTile<bool>(
                                                          activeColor:
                                                              AppColor.cyanTeal,
                                                          title: Text(
                                                              option.lable.tr),
                                                          value:
                                                              option.isCompany,
                                                          groupValue:
                                                              _selectedOption ??
                                                                  false,
                                                          onChanged: (value) {
                                                            _selectedOption = value;
                                                            customerController.update();
                                                          },
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                ContainerTextField(
                                                  controller: name,
                                                  height: 30.h,
                                                  labelText: 'customer_name'.tr,
                                                  showLable: true,
                                                  hintText: 'customer_name'.tr,
                                                  fontSize: 10.r,
                                                  fillColor: AppColor.white,
                                                  borderColor:
                                                      AppColor.silverGray,
                                                  hintcolor: AppColor.black
                                                      .withOpacity(0.5),
                                                  isAddOrEdit: true,
                                                  borderRadius: 5.r,
                                                  prefixIcon: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.r,
                                                            vertical: 5.r),
                                                    child: SvgPicture.asset(
                                                      "assets/image/user-2.svg",
                                                      package: 'yousentech_pos_basic_data_management',
                                                      width: 19.r,
                                                      height: 19.r,
                                                    ),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      errorMessage =
                                                          'required_message_f'
                                                              .trParams({
                                                        'field_name':
                                                            'customer_name'.tr
                                                      });
                                                      countErrors++;
                                                      return "";
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.02),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ContainerTextField(
                                                        controller: email,
                                                        height: 30.h,
                                                        labelText: 'email'.tr,
                                                        showLable: true,
                                                        hintText: 'email'.tr,
                                                        fontSize: 10.r,
                                                        fillColor:
                                                            AppColor.white,
                                                        borderColor:
                                                            AppColor.silverGray,
                                                        hintcolor: AppColor
                                                            .black
                                                            .withOpacity(0.5),
                                                        isAddOrEdit: true,
                                                        borderRadius: 5.r,
                                                        prefixIcon: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5.r,
                                                                  vertical:
                                                                      5.r),
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/image/mail.svg",
                                                            package: 'yousentech_pos_basic_data_management',
                                                            width: 19.r,
                                                            height: 19.r,
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          var message = ValidatorHelper
                                                              .emailValidation(
                                                                  value: value!,
                                                                  field: 'email'
                                                                      .tr);
                                                          if (message == "") {
                                                            return null;
                                                          }
                                                          errorMessage =
                                                              message;
                                                          countErrors++;
                                                          return "";
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.r),
                                                    Expanded(
                                                      child: ContainerTextField(
                                                        controller: phone,
                                                        height: 30.h,
                                                        labelText: 'phone'.tr,
                                                        showLable: true,
                                                        hintText: 'phone'.tr,
                                                        fontSize: 10.r,
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  r'[0-9]+')),
                                                        ],
                                                        maxLength: 12,
                                                        fillColor:
                                                            AppColor.white,
                                                        borderColor:
                                                            AppColor.silverGray,
                                                        hintcolor: AppColor
                                                            .black
                                                            .withOpacity(0.5),
                                                        isAddOrEdit: true,
                                                        borderRadius: 5.r,
                                                        prefixIcon: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5.r,
                                                                  vertical:
                                                                      5.r),
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/image/phone.svg",
                                                            package: 'yousentech_pos_basic_data_management',
                                                            width: 19.r,
                                                            height: 19.r,
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.02),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ContainerTextField(
                                                        controller: street,
                                                        height: 30.h,
                                                        labelText: 'street'.tr,
                                                        showLable: true,
                                                        hintText: 'street'.tr,
                                                        fontSize: 10.r,
                                                        fillColor:
                                                            AppColor.white,
                                                        borderColor:
                                                            AppColor.silverGray,
                                                        hintcolor: AppColor
                                                            .black
                                                            .withOpacity(0.5),
                                                        isAddOrEdit: true,
                                                        borderRadius: 5.r,
                                                        prefixIcon: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5.r,
                                                                  vertical:
                                                                      5.r),
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/image/location.svg",
                                                            package: 'yousentech_pos_basic_data_management',
                                                            width: 19.r,
                                                            height: 19.r,
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (_selectedOption! && (value == null ||value.isEmpty)) {
                                                            errorMessage =
                                                                'required_message_f'
                                                                    .trParams({
                                                              'field_name':
                                                                  'street'
                                                                      .tr
                                                            });
                                                            countErrors++;
                                                            return "";
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.r),
                                                    Expanded(
                                                      child: ContainerTextField(
                                                        controller: district,
                                                        height: 30.h,
                                                        labelText: 'district'.tr,
                                                        showLable: true,
                                                        hintText: 'district'.tr,
                                                        fontSize: 10.r,
                                                        fillColor:
                                                            AppColor.white,
                                                        borderColor:
                                                            AppColor.silverGray,
                                                        hintcolor: AppColor
                                                            .black
                                                            .withOpacity(0.5),
                                                        isAddOrEdit: true,
                                                        borderRadius: 5.r,
                                                        prefixIcon: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5.r,
                                                                  vertical:
                                                                      5.r),
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/image/state.svg",
                                                            package: 'yousentech_pos_basic_data_management',
                                                            width: 19.r,
                                                            height: 19.r,
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (_selectedOption! && (value == null ||value.isEmpty)) {
                                                            errorMessage =
                                                                'required_message_f'
                                                                    .trParams({
                                                              'field_name':
                                                                  'district'
                                                                      .tr
                                                            });
                                                            countErrors++;
                                                            return "";
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.02),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ContainerTextField(
                                                        controller: city,
                                                        height: 30.h,
                                                        labelText: 'city'.tr,
                                                        showLable: true,
                                                        hintText: 'city'.tr,
                                                        fontSize: 10.r,
                                                        fillColor:
                                                            AppColor.white,
                                                        borderColor:
                                                            AppColor.silverGray,
                                                        hintcolor: AppColor
                                                            .black
                                                            .withOpacity(0.5),
                                                        isAddOrEdit: true,
                                                        borderRadius: 5.r,
                                                        prefixIcon: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5.r,
                                                                  vertical:
                                                                      5.r),
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/image/state.svg",
                                                            package: 'yousentech_pos_basic_data_management',
                                                            width: 19.r,
                                                            height: 19.r,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.r),
                                                    Expanded(
                                                      child: ContainerTextField(
                                                        controller: postalCode,
                                                        height: 30.h,
                                                        labelText: 'postal_code'.tr,
                                                        showLable: true,
                                                        hintText:
                                                            'postal_code'.tr,
                                                        fontSize: 10.r,
                                                        fillColor:
                                                            AppColor.white,
                                                        borderColor:
                                                            AppColor.silverGray,
                                                        hintcolor: AppColor
                                                            .black
                                                            .withOpacity(0.5),
                                                        isAddOrEdit: true,
                                                        borderRadius: 5.r,
                                                        prefixIcon: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5.r,
                                                                  vertical:
                                                                      5.r),
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/image/build.svg",
                                                            package: 'yousentech_pos_basic_data_management',
                                                            width: 19.r,
                                                            height: 19.r,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.02),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ContainerTextField(
                                                        controller: building,
                                                        height: 30.h,
                                                        labelText: 'building_no'.tr,
                                                        showLable: true,
                                                        hintText:
                                                            'building_no'.tr,
                                                        fontSize: 10.r,
                                                        fillColor:
                                                            AppColor.white,
                                                        borderColor:
                                                            AppColor.silverGray,
                                                        hintcolor: AppColor
                                                            .black
                                                            .withOpacity(0.5),
                                                        isAddOrEdit: true,
                                                        borderRadius: 5.r,
                                                        prefixIcon: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5.r,
                                                                  vertical:
                                                                      5.r),
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/image/build.svg",
                                                            package: 'yousentech_pos_basic_data_management',
                                                            width: 19.r,
                                                            height: 19.r,
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (_selectedOption! && (value == null ||value.isEmpty)) {
                                                            errorMessage =
                                                                'required_message_f'
                                                                    .trParams({
                                                              'field_name':
                                                                  'building_no'
                                                                      .tr
                                                            });
                                                            countErrors++;
                                                            return "";
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.r),
                                                  
                                                    Expanded(
                                                      child: ContainerTextField(
                                                        controller: l10nSaEdiPlotIdentification,
                                                        height: 30.h,
                                                        labelText: 'l10n_sa_edi_plot_identification'.tr,
                                                        showLable: true,
                                                        hintText:'l10n_sa_edi_plot_identification'.tr,
                                                        fontSize: 10.r,
                                                        fillColor:
                                                            AppColor.white,
                                                        borderColor:
                                                            AppColor.silverGray,
                                                        hintcolor: AppColor
                                                            .black
                                                            .withOpacity(0.5),
                                                        isAddOrEdit: true,
                                                        borderRadius: 5.r,
                                                        prefixIcon: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5.r,
                                                                  vertical:
                                                                      5.r),
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/image/build.svg",
                                                            package: 'yousentech_pos_basic_data_management',
                                                            width: 19.r,
                                                            height: 19.r,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  
                                                  
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.02),
                                                    ContainerTextField(
                                                      controller:
                                                          additionalNo,
                                                      height: 30.h,
                                                      labelText: 'additional_no'.tr,
                                                      showLable: true,
                                                      hintText:
                                                          'additional_no'.tr,
                                                      fontSize: 10.r,
                                                      fillColor:
                                                          AppColor.white,
                                                      borderColor:
                                                          AppColor.silverGray,
                                                      hintcolor: AppColor
                                                          .black
                                                          .withOpacity(0.5),
                                                      isAddOrEdit: true,
                                                      borderRadius: 5.r,
                                                      prefixIcon: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    5.r,
                                                                vertical:
                                                                    5.r),
                                                        child:
                                                            SvgPicture.asset(
                                                          "assets/image/build.svg",
                                                          package: 'yousentech_pos_basic_data_management',
                                                          width: 19.r,
                                                          height: 19.r,
                                                        ),
                                                      ),
                                                    ),
                                                  
                                                 SizedBox(height: Get.height * 0.02), 
                                                if (_selectedOption != null &&
                                                    _selectedOption!) ...[
                                                  ContainerTextField(
                                                    controller: taxNumber,
                                                    height: 30.h,
                                                    labelText: 'tax_number'.tr,
                                                    showLable: true,
                                                    hintText: 'tax_number'.tr,
                                                    fontSize: 10.r,
                                                    fillColor: AppColor.white,
                                                    borderColor:
                                                        AppColor.silverGray,
                                                    hintcolor: AppColor.black
                                                        .withOpacity(0.5),
                                                    isAddOrEdit: true,
                                                    borderRadius: 5.r,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                              RegExp('[0-9]')),
                                                    ],
                                                    prefixIcon: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.r,
                                                              vertical: 5.r),
                                                      child: SvgPicture.asset(
                                                        "assets/image/product_tax_menu_icon.svg",
                                                        package: 'yousentech_pos_basic_data_management',
                                                        width: 19.r,
                                                        height: 19.r,
                                                        color: AppColor.amber
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          Get.height * 0.02),
                                                  ContainerTextField(
                                                    controller: otherSelleId,
                                                    height: 30.h,
                                                    labelText: 'other_selleId'.tr,
                                                    showLable: true,
                                                    hintText:
                                                        'other_selleId'.tr,
                                                    fontSize: 10.r,
                                                    fillColor: AppColor.white,
                                                    borderColor:
                                                        AppColor.silverGray,
                                                    hintcolor: AppColor.black
                                                        .withOpacity(0.5),
                                                    isAddOrEdit: true,
                                                    borderRadius: 5.r,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                              RegExp('[0-9]')),
                                                    ],
                                                    prefixIcon: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.r,
                                                              vertical: 5.r),
                                                      child: SvgPicture.asset(
                                                        "assets/image/product_tax_menu_icon.svg",
                                                        package: 'yousentech_pos_basic_data_management',
                                                        width: 19.r,
                                                        height: 19.r,
                                                        color: AppColor.amber
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.r,
                                          ),
                                          Expanded(
                                              child: Padding(
                                            padding: SharedPr.lang == "ar"
                                                ? const EdgeInsets.only(
                                                    left: 20)
                                                : const EdgeInsets.only(
                                                    right: 20),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  // color: AppColor.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    height: 250.h,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(9),
                                                        border: Border.all(
                                                            color: AppColor
                                                                .silverGray
                                                                .withOpacity(
                                                                    0.6))),
                                                    child: customer == null ||
                                                            customer!.image ==
                                                                null ||
                                                            customer!.image ==
                                                                ''
                                                        ? SvgPicture.asset(
                                                            "assets/image/default_people.svg",
                                                            color: AppColor
                                                                .silverGray,
                                                            fit: BoxFit.contain,
                                                          )
                                                        : isSvg(customer!.image!
                                                                .toString())
                                                            ? SvgPicture.memory(
                                                                base64.decode(
                                                                    customer!
                                                                        .image!
                                                                        .toString()),
                                                                fit:
                                                                    BoxFit.fill,
                                                              )
                                                            : Image.memory(

                                                                // repeat: ImageRepeat.repeatY,
                                                                base64Decode(
                                                                    customer!
                                                                        .image!
                                                                        .toString()),
                                                                fit:
                                                                    BoxFit.fill,
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .high),
                                                  ),
                                                  Positioned(
                                                      left: 10,
                                                      top: 20,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          final ImagePicker
                                                              picker =
                                                              ImagePicker();
                                                          final XFile? image =
                                                              await picker.pickImage(
                                                                  source: ImageSource
                                                                      .gallery);
                                                          if (image != null) {
                                                            String imagePath =
                                                                image.path;
                                                            File imageFile =
                                                                File(imagePath);
                                                            Uint8List bytes =
                                                                await imageFile
                                                                    .readAsBytes();

                                                            String
                                                                base64String =
                                                                base64.encode(
                                                                    bytes);
                                                            customer!.image =
                                                                base64String;
                                                            setState(() {});
                                                          }
                                                        },
                                                        child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: AppColor
                                                                      .cyanTeal,
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: SvgPicture.asset(
                                                                "assets/image/edit.svg",
                                                                package: 'yousentech_pos_basic_data_management',
                                                                color: AppColor
                                                                    .white),
                                                          ),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ))
                                        ],
                                      ),
                                      SizedBox(height: Get.height * 0.05),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: ButtonElevated(
                                                  text: (customer?.id != null
                                                          ? 'edit_customer'
                                                          : 'add_new_customer')
                                                      .tr,
                                                  borderRadius: 9,
                                                  backgroundColor:
                                                      AppColor.cyanTeal,
                                                  showBoxShadow: false,
                                                  textStyle: AppStyle.textStyle(
                                                      color: Colors.white,
                                                      fontSize: 3.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  onPressed: _onPressed),
                                            ),
                                            SizedBox(width: Get.width * 0.01),
                                            Expanded(
                                              child: ButtonElevated(
                                                  text: 'back'.tr,
                                                  borderRadius: 9,
                                                  borderColor:
                                                      AppColor.paleAqua,
                                                  textStyle: AppStyle.textStyle(
                                                      color: AppColor.slateGray,
                                                      fontSize: 3.sp,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  onPressed: () async {
                                                    customerController
                                                        .searchResults
                                                        .clear();
                                                    customerController.update();
                                                    await customerController
                                                        .resetPagingList(
                                                            selectedpag: 0);

                                                    back();

                                                    // Get.back();
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: Get.height * 0.02),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  customerController.isLoading.value
                      ? const LoadingWidget()
                      : Container(),
                ],
              ),
            ),
          );
        });
  }

  _onPressed() async {
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
              id: customer!.id!.toInt(), customer: customer!)
          : await customerController.createCustomerRemotAndLocal(
              customer: customer!);

      await customerController.loadingDataController.getitems();
      pagesNumber = (customerController.loadingDataController
                  .itemdata[Loaddata.customers.name.toString()]['local'] ~/
              customerController.limit) +
          (customerController.loadingDataController.itemdata[Loaddata.customers.name.toString()]
                          ['local'] %
                      customerController.limit !=
                  0
              ? 1
              : 0);
      if (func.status) {
        if (widget.objectToEdit == null && pagesNumber == 1) {
          customerController.customerpagingList.add(func.data);
        }
        var customerIndex = customerController.customerpagingList
            .indexWhere((item) => item.id == widget.objectToEdit?.id);
        if (customerIndex != -1) {
          customerController.customerpagingList[customerIndex] = customer!;
        }
        customerController.update();
        customer = null;
        customerController.isLoading.value = false;
        customerController.update();
        appSnackBar(
          messageType: MessageTypes.success,
          message: func.message,
        );
        back();
        await customerController.resetPagingList(selectedpag: 0);
      } else {
        customerController.isLoading.value = false;
        customerController.update();
        appSnackBar(
          message: func.message,
        );
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
  }
}
