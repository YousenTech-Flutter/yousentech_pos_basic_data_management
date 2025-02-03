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
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pos_shared_preferences/models/customer_model.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_enum.dart';
import 'package:shared_widgets/config/app_styles.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
import 'package:shared_widgets/utils/validator_helper.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/domain/customer_viewmodel.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/presentation/widget/tital.dart';
import 'package:yousentech_pos_loading_synchronizing_data/config/app_enums.dart';
import 'package:yousentech_pos_loading_synchronizing_data/utils/fetch_date.dart';

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
  Country? country;
  // List<ProductUnit> productUnitList = [];
  final TextEditingController name = TextEditingController(),
      email = TextEditingController(),
      taxNumber = TextEditingController(),
      street = TextEditingController(),
      district = TextEditingController(),
      building = TextEditingController(),
      phone = TextEditingController();

  CustomerController customerController =
      Get.put(CustomerController(), tag: 'customerControllerMain');
  back() async {
    customerController.updateHideMenu(false);
    customerController.object = null;
  }

  getCountryCode(String phoneNumber) {
    if (phoneNumber.startsWith("+")) {
      // int firstDigitIndex = phoneNumber.indexOf(RegExp(r'[0-9]'));
      int firstDigitIndex = phoneNumber.indexOf("-");
      String phonePeur = phoneNumber
          .substring((firstDigitIndex < 0 ? 4 : firstDigitIndex + 1));

      // country = countries.firstWhere((element) => phonePeur.startsWith(element.dialCode));
      if (firstDigitIndex < 0) {
        country = countries.firstWhere((element) => element.dialCode == "966");
      } else {
        country = countries.firstWhere((element) =>
            phoneNumber.substring(1, firstDigitIndex) == element.dialCode);
      }

      // phone.text = phonePeur.substring(0 + country!.dialCode.length);
      phone.text = phonePeur;
    } else {
      phone.text = phoneNumber;
      country = countries.firstWhere((element) => element.dialCode == "966");
    }
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
      getCountryCode(customer!.phone ?? '');
      //
      taxNumber.text = customer!.buildingNo ?? "";

      street.text = customer!.street ?? "";
      district.text = customer!.district ?? "";
      building.text = customer!.buildingNo ?? "";
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
                          // Container(
                          //   margin: SharedPr.lang == "ar"
                          //       ? EdgeInsets.only(top: 20.r, right: 4)
                          //       : EdgeInsets.only(top: 20.r, left: 4),
                          //   height: 50.h,
                          //   width: 50.w,
                          //   decoration: BoxDecoration(
                          //       color: AppColor.white,
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(5.r))),
                          //   child: Row(
                          //     children: [
                          //       Container(
                          //         height: 50.h,
                          //         width: 4.w,
                          //         decoration: BoxDecoration(
                          //             color: AppColor.cyanTeal,
                          //             borderRadius:
                          //                 BorderRadiusDirectional.only(
                          //                     topStart: Radius.circular(5.r),
                          //                     bottomStart:
                          //                         Radius.circular(5.r))),
                          //       ),
                          //       SizedBox(
                          //         width: 10.r,
                          //       ),
                          //       Align(
                          //         alignment: Alignment.center,
                          //         child: Text(
                          //           " ${(customer?.id == null) ? 'add_new_customer'.tr : 'edit_customer'.tr} ",
                          //           style: TextStyle(
                          //               fontSize: 4.sp,
                          //               color: AppColor.slateGray,
                          //               fontWeight: FontWeight.bold,
                          //               fontFamily: 'Tajawal'),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Row(
                          //   children: [
                          //     TextButton(
                          //         onPressed: () {
                          //           back();
                          //         },
                          //         child: Text("${"customers".tr} ")),
                          //     Text(
                          //         "/ ${(customer?.id == null) ? 'add_new_customer'.tr : 'edit_customer'.tr} "),
                          //   ],
                          // ),

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
                                              children: [
                                                ContainerTextField(
                                                  controller: name,
                                                  height: 30.h,
                                                  labelText: '',
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
                                                      package:
                                                          'yousentech_pos_basic_data_management',
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
                                                        labelText: '',
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
                                                            package:
                                                                'yousentech_pos_basic_data_management',
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
                                                    // Expanded(
                                                    //   child: ContainerTextField(
                                                    //     controller: phone,
                                                    //     height: 30.h,
                                                    //     labelText: '',
                                                    //     hintText: 'phone'.tr,
                                                    //     fontSize: 10.r,
                                                    //     maxLength: 12,
                                                    //     fillColor:
                                                    //         AppColor.white,
                                                    //     borderColor:
                                                    //         AppColor.silverGray,
                                                    //     hintcolor: AppColor
                                                    //         .black
                                                    //         .withOpacity(0.5),
                                                    //     isAddOrEdit: true,
                                                    //     borderRadius: 5.r,
                                                    //     prefixIcon: Padding(
                                                    //       padding: EdgeInsets
                                                    //           .symmetric(
                                                    //               horizontal:
                                                    //                   5.r,
                                                    //               vertical:
                                                    //                   5.r),
                                                    //       child:
                                                    //           SvgPicture.asset(
                                                    //         "assets/image/phone.svg",
                                                    //         width: 19.r,
                                                    //         height: 19.r,
                                                    //       ),
                                                    //     ),
                                                    //     inputFormatters: [
                                                    //       FilteringTextInputFormatter
                                                    //           .allow(RegExp(
                                                    //               r'[0-9]+')),
                                                    //     ],
                                                    //   ),
                                                    // ),

                                                    Expanded(
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width /
                                                                2.7,
                                                        height: 30.h,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: AppColor
                                                                      .silverGray,
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5.r))),
                                                        child: SizedBox(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width /
                                                                  2.7,
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.07,
                                                          child: IntlPhoneField(
                                                            dropdownIcon: Icon(
                                                              Icons
                                                                  .local_phone_sharp,
                                                              color: AppColor
                                                                  .amber
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            // dropdownIcon: Padding(
                                                            //   padding:  EdgeInsets
                                                            //     .symmetric(
                                                            //         horizontal:
                                                            //             5.r,
                                                            //         vertical:
                                                            //             5.r),
                                                            //   child: SvgPicture
                                                            //       .asset(
                                                            //     "assets/image/phone.svg",
                                                            //     width: 19.r,
                                                            //     height: 19.r,
                                                            //   ),
                                                            // ),
                                                            controller: phone,
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      '[0-9\$]+')),
                                                            ],

                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              color: AppColor
                                                                  .black,
                                                              fontSize: 10.r,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            decoration:
                                                                InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        'phone'
                                                                            .tr,
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: AppColor
                                                                          .black
                                                                          .withOpacity(
                                                                              0.5),
                                                                      fontSize:
                                                                          10.r,
                                                                    )),
                                                            onChanged: (value) {
                                                              completeNumber =
                                                                  "${value.countryCode}-${value.number}";
                                                            },
                                                            onCountryChanged:
                                                                (countryselect) {
                                                              country =
                                                                  countryselect;
                                                              setState(() {});

                                                              completeNumber =
                                                                  "+${countryselect.dialCode}-${phone.text}";
                                                            },
                                                            initialCountryCode:
                                                                country?.code,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.02),
                                                ContainerTextField(
                                                  controller: street,
                                                  height: 30.h,
                                                  labelText: '',
                                                  hintText: 'street'.tr,
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
                                                      "assets/image/location.svg",
                                                      package:
                                                          'yousentech_pos_basic_data_management',
                                                      width: 19.r,
                                                      height: 19.r,
                                                    ),
                                                  ),
                                                  // validator: (value) {
                                                  //   if (value == null ||
                                                  //       value.isEmpty) {
                                                  //     errorMessage =
                                                  //         'required_message_f'
                                                  //             .trParams({
                                                  //       'field_name': 'street'.tr
                                                  //     });
                                                  //     countErrors++;
                                                  //     return "";
                                                  //   } else {
                                                  //     return null;
                                                  //   }
                                                  // },
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.02),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ContainerTextField(
                                                        controller: district,
                                                        height: 30.h,
                                                        labelText: '',
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
                                                            package:
                                                                'yousentech_pos_basic_data_management',
                                                            width: 19.r,
                                                            height: 19.r,
                                                          ),
                                                        ),
                                                        // validator: (value) {
                                                        //   var message = ValidatorHelper
                                                        //       .emailValidation(
                                                        //           value: value!,
                                                        //           field:
                                                        //               'district'
                                                        //                   .tr);
                                                        //   if (message == "") {
                                                        //     return null;
                                                        //   }
                                                        //   errorMessage =
                                                        //       message;
                                                        //   countErrors++;
                                                        //   return "";
                                                        // },
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.r),
                                                    Expanded(
                                                      child: ContainerTextField(
                                                        controller: building,
                                                        height: 30.h,
                                                        labelText: '',
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
                                                            package:
                                                                'yousentech_pos_basic_data_management',
                                                            width: 19.r,
                                                            height: 19.r,
                                                          ),
                                                        ),
                                                        // validator: (value) {
                                                        //   var message = ValidatorHelper
                                                        //       .emailValidation(
                                                        //           value: value!,
                                                        //           field:
                                                        //               'building_no'
                                                        //                   .tr);
                                                        //   if (message == "") {
                                                        //     return null;
                                                        //   }
                                                        //   errorMessage =
                                                        //       message;
                                                        //   countErrors++;
                                                        //   return "";
                                                        // },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.02),
                                                ContainerTextField(
                                                  controller: taxNumber,
                                                  height: 30.h,
                                                  labelText: '',
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
                                                        .allow(RegExp('[0-9]')),
                                                  ],
                                                  prefixIcon: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.r,
                                                            vertical: 5.r),
                                                    child: SvgPicture.asset(
                                                      "assets/image/product_tax_menu_icon.svg",
                                                      package:
                                                          'yousentech_pos_basic_data_management',
                                                      width: 19.r,
                                                      height: 19.r,
                                                      color: AppColor.amber
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                  // validator: (value) {
                                                  //   if (value == null ||
                                                  //       value.isEmpty) {
                                                  //     errorMessage =
                                                  //         'required_message_f'
                                                  //             .trParams({
                                                  //       'field_name': 'taxNumber'.tr
                                                  //     });
                                                  //     countErrors++;
                                                  //     return "";
                                                  //   } else {
                                                  //     return null;
                                                  //   }
                                                  // },
                                                ),
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
                                                            package:
                                                                'yousentech_pos_basic_data_management',
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
                                                                package:
                                                                    'yousentech_pos_basic_data_management',
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
                                            // ButtonElevated(
                                            //     width: Get.width * 0.15,
                                            //     text: 'cancel'.tr,
                                            //     backgroundColor:
                                            //         AppColor.shadepurple,
                                            //     onPressed: () {
                                            //       back();
                                            //     }),

                                            // ButtonElevated(
                                            //     width: Get.width * 0.15,
                                            //     text: (customer?.id != null
                                            //             ? 'edit_customer'
                                            //             : 'add_new_customer')
                                            //         .tr,
                                            //     backgroundColor:
                                            //         AppColor.shadepurple,
                                            //     onPressed: _onPressed)
                                            //   }
                                            // }),
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
      if (phone.text == '' || phone.text != '') {
        var message = ValidatorHelper.phoneNumberValidation(
            value: phone.text, field: 'phone'.tr, country: country);
        if (message != "") {
          appSnackBar(
            message: message,
          );
        } else {
          customer?.name = name.text.trim();
          customer?.email = email.text == '' ? null : email.text;
          customer?.phone = phone.text == ''
              ? phone.text
              : (completeNumber == '' ? phone.text : completeNumber);
          customer?.street = street.text;
          customer?.district = district.text;
          customer?.buildingNo = building.text;
          customer?.vat = taxNumber.text;

          customer?.customerRank = 1;
          var func = customer?.id != null
              ? await customerController.updateCustomerRemotAndLocal(
                  id: customer!.id!.toInt(), customer: customer!)
              : await customerController.createCustomerRemotAndLocal(
                  customer: customer!);

          await loadingDataController.getitems();
          pagesNumber = (loadingDataController
                      .itemdata[Loaddata.customers.name.toString()]['local'] ~/
                  customerController.limit) +
              (loadingDataController
                                  .itemdata[Loaddata.customers.name.toString()]
                              ['local'] %
                          customerController.limit !=
                      0
                  ? 1
                  : 0);
          if (func.status) {
            if (widget.objectToEdit == null && pagesNumber == 1) {
              // customerController.customerList.add(func.data);
              customerController.customerpagingList.add(func.data);
            }
            // var customerIndex = customerController.customerpagingList.indexOf(widget.objectToEdit);
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

            //  print("customerController.customerpagingList[customerIndex] ${customerController.customerpagingList[customerIndex].name}");
            back();
            await customerController.resetPagingList(selectedpag: 0);
            // customerController.update(['update_customer']);
          } else {
            customerController.isLoading.value = false;
            customerController.update();
            appSnackBar(
              message: func.message,
            );
          }
          // if (func.status) {
          //   // Get.back();
          //   back();
          //   // if (kDebugMode) {
          //   //   print("func.status=========ddd========${func.status}=============");
          //   // }
          //   appSnackBar(
          //       message: func.message, messageType: MessageTypes.success);
          // } else {
          //   appSnackBar(
          //     message: func.message!,
          //   );
          // }
        }
        customerController.isLoading.value = false;
        customerController.update();
      }
    } else {
      // if (kDebugMode) {
      //   print("errorMessage $errorMessage");
      //   print("countErrors $countErrors");
      // }
      // customerController.isLoading.value = false;
      appSnackBar(
        message: countErrors == 3 ? 'enter_required_info'.tr : errorMessage,
      );
      customerController.isLoading.value = false;
      customerController.update();
    }
  }
}
