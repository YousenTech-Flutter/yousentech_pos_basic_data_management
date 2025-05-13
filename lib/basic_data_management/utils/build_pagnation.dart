import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/config/app_enums.dart';
import 'package:yousentech_pos_loading_synchronizing_data/loading_sync/src/domain/loading_synchronizing_data_viewmodel.dart';

class PagnationWidget extends StatefulWidget {
  final TextEditingController searchBarController;
  final TextEditingController pagnationController;
  final dynamic controller;
  bool isPrpduct;
  PagnationWidget(
      {super.key,
      required this.searchBarController,
      required this.pagnationController,
      required this.controller,
      this.isPrpduct = true});

  @override
  State<PagnationWidget> createState() => _PagnationWidgetState();
}

class _PagnationWidgetState extends State<PagnationWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoadingDataController>(
        id: "pagin",
        builder: (loadingDataController) {
          dynamic dataResultLenght;
          if (widget.isPrpduct) {
            dataResultLenght = widget.controller.isHaveCheck.value &&
                        widget.controller.filtterResults.isEmpty ||
                    (widget.searchBarController.text != "" &&
                        widget.controller.searchResults.isEmpty)
                ? 0
                : widget.controller.filtterResults.isNotEmpty &&
                        widget.controller.searchResults.isEmpty
                    ? widget.controller.filtterResults.length
                    : widget.controller.searchResults.isNotEmpty
                        ? widget.controller.searchResults.length
                        : widget.searchBarController.text != "" &&
                                widget.controller.searchResults.isEmpty
                            ? 0
                            : loadingDataController.itemdata[
                                        Loaddata.products.name.toString()] ==
                                    null
                                ? 0
                                : loadingDataController.itemdata[
                                    Loaddata.products.name.toString()]['local'];
          } else {
            dataResultLenght = widget.controller.searchResults.isNotEmpty
                ? widget.controller.searchResults.length
                : widget.searchBarController.text != "" &&
                        widget.controller.searchResults.isEmpty
                    ? 0
                    : loadingDataController
                                .itemdata[Loaddata.customers.name.toString()] ==
                            null
                        ? 0
                        : loadingDataController
                                .itemdata[Loaddata.customers.name.toString()]
                            ['local'];
          }

          widget.controller.pagnationpagesNumber =
              (dataResultLenght ~/ widget.controller.limit) +
                  (dataResultLenght % widget.controller.limit != 0 ? 1 : 0);
          int dataStart = widget.pagnationController.text.isEmpty
              ? (widget.controller.limit *
                      (widget.controller.selectedPagnation + 1)) -
                  (widget.controller.limit - 1)
              : int.parse(widget.pagnationController.text);
          widget.pagnationController.text = dataStart.toString();
          var datadisplayLenght = (int.parse(widget.pagnationController.text) +
                      widget.controller.limit) <
                  dataResultLenght
              ? ((int.parse(widget.pagnationController.text) +
                      widget.controller.limit) -
                  1)
              : dataResultLenght;
          return dataResultLenght != 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: (Get.height * 0.2),
                    height: Get.height * 0.03,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.silverGray),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5.r),
                      child: Row(
                        // mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: dataStart > 1
                                ? () async {
                                    if (dataStart <= widget.controller.limit) {
                                      if (widget.isPrpduct) {
                                        await widget.controller
                                            .displayProductList(
                                                paging: true,
                                                type: "prefix",
                                                countSkip: 0);
                                      } else {
                                        await widget.controller
                                            .getAllCustomerLocal(
                                                paging: true,
                                                type: "prefix",
                                                countSkip: 0);
                                      }

                                      widget.controller.selectedPagnation = 0;
                                      widget.pagnationController.text = "1";
                                    } else {
                                      if (widget.isPrpduct) {
                                        await widget.controller
                                            .displayProductList(
                                                paging: true, type: "prefix");
                                      } else {
                                        await widget.controller
                                            .getAllCustomerLocal(
                                                paging: true, type: "prefix");
                                      }

                                      widget.controller.selectedPagnation--;
                                      widget.pagnationController.text = ((widget
                                                      .controller.limit *
                                                  (widget.controller
                                                          .selectedPagnation +
                                                      1)) -
                                              (widget.controller.limit - 1))
                                          .toString();
                                    }
                                  }
                                : null,
                            child: SvgPicture.asset(
                              SharedPr.lang == "ar"
                                  ? "assets/image/arrow_right.svg"
                                  : "assets/image/arrow_left.svg",
                              package:'yousentech_pos_basic_data_management',
                              color:
                                  dataStart <= 1 ? AppColor.silverGray : null,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 10.r,
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  // Lenght data in DB
                                  TextSpan(
                                    text: "$dataResultLenght / ",
                                    style: TextStyle(
                                        fontSize: 10.r,
                                        color: AppColor.lavenderGray,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Tajawal'),
                                  ),
                                  // Lenght show in screen in
                                  TextSpan(
                                    text: "$datadisplayLenght -",
                                    style: TextStyle(
                                        fontSize:   10.r,
                                        color: AppColor.black.withOpacity(0.5),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Tajawal',
                                        package:'yousentech_pos_basic_data_management',
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 10.r,
                              width: 40.r,
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 6.5.r,
                                  overflow: TextOverflow.ellipsis,
                                  // fontWeight: FontWeight.bold
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // Only digits allowed
                                ],
                                decoration: InputDecoration(
                                  isDense:
                                      true, // Reduces the padding inside the TextField
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical:
                                          2.r), // Set padding to zero or adjust
                                  border: InputBorder
                                      .none, // Remove the border if not needed
                                ),
                                controller: widget.pagnationController,
                                onSubmitted: (value) async {
                                  int? countSkip;
                                  if (value.isEmpty) {
                                    widget.pagnationController.text =
                                        (1).toString();
                                    countSkip = 0;
                                    widget.controller.selectedPagnation = 0;
                                  } else if (value.isNotEmpty) {
                                    var pageselecteed = (int.parse(value) /
                                            widget.controller.limit)
                                        .ceilToDouble();
                                    widget.controller.selectedPagnation =
                                        pageselecteed.toInt() - 1;
                                    if (int.parse(value) > dataResultLenght) {
                                      widget.pagnationController.text =
                                          (1).toString();
                                      countSkip = 0;
                                      widget.controller.selectedPagnation = 0;
                                    } else if (int.parse(value) <= 1) {
                                      widget.pagnationController.text =
                                          (1).toString();
                                      countSkip = 0;
                                      widget.controller.selectedPagnation = 0;
                                    } else {
                                      countSkip = int.parse(value) - 1;
                                    }
                                  }

                                  widget.controller.update();
                                  if (widget.isPrpduct) {
                                    await widget.controller.displayProductList(
                                        paging: true,
                                        type: "",
                                        countSkip: countSkip,
                                        pageselecteed: widget
                                            .controller.selectedPagnation);
                                  } else {
                                    await widget.controller.getAllCustomerLocal(
                                        paging: true,
                                        type: "",
                                        countSkip: countSkip,
                                        pageselecteed: widget
                                            .controller.selectedPagnation);
                                  }
                                },
                              ),
                            ),
                          ),
                          //التالي
                          InkWell(
                            onTap: widget.controller.pagnationpagesNumber >
                                    (widget.controller.selectedPagnation + 1)
                                ? () async {
                                    int prefixData = int.parse(
                                        widget.pagnationController.text);
                                    widget.controller.skip = (prefixData +
                                        (widget.controller.limit - 1));
                                    widget.pagnationController.text =
                                        (widget.controller.skip + 1).toString();
                                    if (widget.isPrpduct) {
                                      await widget.controller
                                          .displayProductList(
                                              paging: true,
                                              type: "suffix",
                                              countSkip:
                                                  widget.controller.skip);
                                    } else {
                                      await widget.controller
                                          .getAllCustomerLocal(
                                              paging: true,
                                              type: "suffix",
                                              countSkip:
                                                  widget.controller.skip);
                                    }

                                    widget.controller.selectedPagnation++;
                                  }
                                : null,
                            child: SvgPicture.asset(
                              SharedPr.lang == "ar"
                                  ? "assets/image/arrow_left.svg"
                                  : "assets/image/arrow_right.svg",
                              package:'yousentech_pos_basic_data_management',
                              color: widget.controller.pagnationpagesNumber >
                                      (widget.controller.selectedPagnation + 1)
                                  ? null
                                  : AppColor.silverGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink();
        });
  }
}
