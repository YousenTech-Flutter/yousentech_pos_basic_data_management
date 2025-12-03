// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pos_shared_preferences/models/customer_model.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/domain/customer_viewmodel.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/customer/presentation/views/create_edit_customer.dart';
import 'package:yousentech_pos_invoice/invoices/domain/invoice_operations/invoice_operations_viewmodel.dart';
import 'package:yousentech_pos_invoice/invoices/domain/invoice_operations/pending_invoice_viewmodel.dart';
import 'package:yousentech_pos_invoice/invoices/domain/invoice_viewmodel.dart';

void showSearchableCustomerDialog({
  bool filterInvoices = false,
  bool ispending = false,
  bool skipInternet = false,
  bool isFilterInvoice = false,
}) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SearchableCustomerDialog(
        filterInvoices: filterInvoices,
        ispending: ispending,
      );
    },
  ).then((onValue) {
    // if (isFilterInvoice &&
    //     (Get.find<InvoiceOperationsController>()).customerIdFilter.text != '') {
    //   (Get.find<InvoiceOperationsController>()).applyFilters(
    //     skipInternet: skipInternet,
    //   );
    // }
  });
}

class SearchableCustomerDialog extends StatefulWidget {
  final bool filterInvoices;
  final bool ispending;
  const SearchableCustomerDialog({
    super.key,
    required this.filterInvoices,
    required this.ispending,
  });

  @override
  _SearchableProductDialogState createState() =>
      _SearchableProductDialogState();
}

class _SearchableProductDialogState extends State<SearchableCustomerDialog> {
  final InvoiceController _invoiceController = Get.find<InvoiceController>();

  int _selectedIndex = 0;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool ignoring = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invoiceController.searchItemsFocus.requestFocus();
      _invoiceController.isDialogOpen = true;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _invoiceController.isDialogOpen = false;
    _invoiceController.searchCustomerTextController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceController>(
      builder: (controller) {
        return AbsorbPointer(
          absorbing: ignoring,
          child: AlertDialog(
            backgroundColor:
                SharedPr.isDarkMode!
                    ? const Color(0xFF1B1B1B)
                    : const Color(0xFFE3E3E3),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(width: 10),
                Text(
                  'customers'.tr,
                  style: TextStyle(
                    color:
                        SharedPr.isDarkMode!
                            ? Colors.white
                            : const Color(0xFF2E2E2E),
                    fontSize: context.setSp(20.03),
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            content: KeyboardListener(
              focusNode: _focusNode,
              onKeyEvent: (KeyEvent event) {
                if (event is KeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                    setState(() {
                      if (_selectedIndex <
                          _invoiceController
                                  .pagingCustomerController
                                  .itemList!
                                  .length -
                              1) {
                        _selectedIndex++;
                        _scrollToIndex();
                      }
                    });
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                    setState(() {
                      if (_selectedIndex > 0) {
                        _selectedIndex--;
                        _scrollToIndex();
                      }
                    });
                  } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                    if (_invoiceController
                        .pagingCustomerController
                        .itemList!
                        .isNotEmpty) {
                      final selectedcustomer =
                          _invoiceController
                              .pagingCustomerController
                              .itemList![_selectedIndex];
                      widget.ispending
                          ? (Get.find<InvoicePendingController>())
                              .selectCustomerPending(selectedcustomer)
                          : widget.filterInvoices
                          ? (Get.find<InvoiceOperationsController>())
                              .customerIdFilter
                              .text = selectedcustomer.name.toString()
                          : _invoiceController.changeSelection(
                            selectedcustomer.id!,
                            selectedcustomer.name,
                            selectedcustomer.phone,
                            selectedcustomer.email,
                          );

                      _invoiceController.barcodeFocus.requestFocus();
                      _invoiceController.isDialogOpen = false;
                      Get.back();
                    }
                  }
                }
              },
              child: SizedBox(
                width: context.setWidth(470),
                height: context.setHeight(350),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ContainerTextField(
                      borderColor:
                          !SharedPr.isDarkMode! ? Color(0xFFC2C3CB) : null,
                      fillColor:
                          !SharedPr.isDarkMode!
                              ? Colors.white.withValues(alpha: 0.43)
                              : const Color(0xFF2B2B2B),
                      hintcolor:
                          !SharedPr.isDarkMode!
                              ? Color(0xFFC2C3CB)
                              : const Color(0xFFC2C3CB),
                      color:
                          !SharedPr.isDarkMode!
                              ? Color(0xFFC2C3CB)
                              : const Color(0xFFC2C3CB),
                      focusNode: _invoiceController.searchItemsFocus,
                      isAddOrEdit: true,
                      borderRadius: context.setMinSize(8.01),
                      height: context.setHeight(51.28),
                      fontSize: context.setSp(14),
                      labelText: '',
                      hintText: 'search_customers'.tr,
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.setWidth(9.96),
                          vertical: context.setHeight(5.95),
                        ),
                        child: SvgPicture.asset(
                          AppImages.search,
                          package: 'shared_widgets',
                          ),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(
                        context.setWidth(14.82),
                        context.setHeight(15.22),
                        context.setWidth(14.82),
                        context.setHeight(15.22),
                      ),
                      onChanged: (qu) {
                        _invoiceController.pagingCustomerController.refresh();
                      },
                      controller:
                          _invoiceController.searchCustomerTextController,
                    ),
                    SizedBox(
                      height: context.setHeight(10),
                    ),
                    Expanded(
                      child: PagedListView<int, Customer>(
                        padding: EdgeInsets.zero,
                        pagingController:
                            _invoiceController.pagingCustomerController,
                        builderDelegate: PagedChildBuilderDelegate<Customer>(
                          noItemsFoundIndicatorBuilder: (BuildContext context) {
                            return !widget.ispending && !widget.filterInvoices
                                ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        CustomerController customerController =
                                            Get.put(
                                              CustomerController(),
                                              tag: 'customerControllerMain',
                                            );
                                        var func = await customerController
                                            .createCustomerRemotAndLocal(
                                              customer: Customer(
                                                name:
                                                    _invoiceController
                                                        .searchCustomerTextController
                                                        .text,
                                              ),
                                            );
                                        if (func.status) {
                                          customerController.customerpagingList
                                              .add(func.data);
                                          _invoiceController.changeSelection(
                                            func.data.id!,
                                            _invoiceController
                                                .searchCustomerTextController
                                                .text,
                                            null,
                                            null,
                                          );
                                          _invoiceController.isDialogOpen =
                                              false;
                                          Get.back();
                                        } else {
                                          appSnackBar(message: func.message);
                                        }
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: const Color(0xFF16A6B7),
                                            fontSize: context.setSp(16),
                                            fontFamily: 'Tajawal',
                                            fontWeight: FontWeight.w700,
                                          ), // النمط العام
                                          children: [
                                            TextSpan(text: 'create'.tr),
                                            const TextSpan(text: '  '),
                                            TextSpan(
                                              text:
                                                  _invoiceController
                                                      .searchCustomerTextController
                                                      .text,
                                              style: TextStyle(
                                                color:
                                                    SharedPr.isDarkMode!
                                                        ? Colors.white
                                                        : Colors.black,
                                                fontSize: context.setSp(16),
                                                fontFamily: 'Tajawal',
                                                fontWeight: FontWeight.w700,
                                              ), // تنسيق خاص للنص المدخل
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(height:context.setHeight(10)),
                                    InkWell(
                                      onTap: () {
                                        Get.back(closeOverlays: true);
                                        createEditeCustomer(
                                          context: context,
                                          customerName:
                                              _invoiceController
                                                  .searchCustomerTextController
                                                  .text,
                                        );
                                      },
                                      child: Text(
                                        'create_edit'.tr,
                                        style: TextStyle(
                                      color:const Color(0xFF16A6B7),
                                      fontSize: context.setSp(16),
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w700,
                                    ),
                                      ),
                                    ),
                                  ],
                                )
                                : Text("empty_filter".tr);
                          },
                          itemBuilder: (context, customer, index) {
                            bool isSelected = _selectedIndex == index;
                            return InkWell(
                              onTap: () async {
                                ignoring = true;
                                controller.update();
                                _selectedIndex = index;
                                widget.ispending
                                    ? (Get.find<InvoicePendingController>())
                                        .selectCustomerPending(customer)
                                    : widget.filterInvoices
                                    ? (Get.find<InvoiceOperationsController>())
                                        .customerIdFilter
                                        .text = customer.name.toString()
                                    : _invoiceController.changeSelection(
                                      customer.id!,
                                      customer.name,
                                      customer.phone,
                                      customer.email,
                                    );
                                _invoiceController.isDialogOpen = false;
                                _invoiceController.barcodeFocus.requestFocus();
                                ignoring = false;
                                controller.update();
                                Get.back();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    context.setMinSize(8.0),
                                  ),
                                  color:
                                      isSelected
                                          ? const Color(0xFF16A6B7)
                                          : null,
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: context.setWidth(8.0),
                                    vertical: context.setHeight(0.0),
                                  ),
                                  tileColor:
                                      _selectedIndex == index
                                          ? Colors.blue[100]
                                          : null,
                                  selected: _selectedIndex == index,
                                  title: Text(
                                    customer.name!,
                                    style: TextStyle(
                                      color:
                                          SharedPr.isDarkMode!
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: context.setSp(16),
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  leading: SvgPicture.asset(
                                    AppImages.partner,
                                    package: 'shared_widgets',
                                    clipBehavior: Clip.antiAlias,
                                    color: isSelected ? Colors.white : null,
                                  ),
                                  // ],
                                ),
                              ),
                            );
                          },
                        ),
                        scrollController: _scrollController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _scrollToIndex() {
    const itemHeight = 65.0;
    final scrollOffset = _scrollController.offset;
    final viewportHeight = _scrollController.position.viewportDimension;
    final itemTop = _selectedIndex * itemHeight;
    final itemBottom = itemTop + itemHeight;

    if (itemTop < scrollOffset) {
      _scrollController.animateTo(
        itemTop,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else if (itemBottom > scrollOffset + viewportHeight) {
      _scrollController.animateTo(
        itemBottom - viewportHeight,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }
}
