// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pos_shared_preferences/models/product_data/product.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/domain/product_viewmodel.dart';
import 'package:yousentech_pos_basic_data_management/basic_data_management/src/products/utils/filter_product_by_category.dart';
import 'package:yousentech_pos_invoice/invoices/domain/invoice_viewmodel.dart';

void showSearchableProductDialog() {
  showDialog(
    context: Get.context!,
    builder: (BuildContext dialogContext) {
      return SearchableProductDialog(dialogContext: dialogContext);
    },
  );
}

class SearchableProductDialog extends StatefulWidget {
  final BuildContext dialogContext;
  const SearchableProductDialog({super.key, required this.dialogContext});

  @override
  _SearchableProductDialogState createState() =>
      _SearchableProductDialogState();
}

class _SearchableProductDialogState extends State<SearchableProductDialog> {
  final InvoiceController _invoiceController = Get.find<InvoiceController>();
  late final ProductController productController;
  int _selectedIndex = 0;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool ignoring = false;
  @override
  void initState() {
    super.initState();
    productController = Get.put(
      ProductController(),
      tag: 'productControllerMain',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invoiceController.searchItemsFocus.requestFocus();
      _invoiceController.isDialogOpen = true;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose(); // Dispose the ScrollController
    _invoiceController.isDialogOpen = false;
    _invoiceController.searchItemsTextController.clear();
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
                const SizedBox(width: 10),
                Text(
                  'search_products'.tr,
                  style: TextStyle(
                    fontSize: context.setSp(14),
                    fontFamily: 'Tajawal',
                    color: SharedPr.isDarkMode! ? Colors.white : Colors.black,
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
                          _invoiceController.pagingController.itemList!.length -
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
                        .pagingController
                        .itemList!
                        .isNotEmpty) {
                      final selectedProduct =
                          _invoiceController
                              .pagingController
                              .itemList![_selectedIndex];
                      _invoiceController.onSelectSearchItem(
                        selectedProduct: selectedProduct,
                      );
                      _invoiceController.barcodeFocus.requestFocus();
                      _invoiceController.isDialogOpen = false;
                      Navigator.pop(widget.dialogContext);
                    }
                  }
                }
              },
              child: SizedBox(
                width: context.setWidth(400),
                height: context.setHeight(300),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ContainerTextField(
                      controller: _invoiceController.searchItemsTextController,
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
                      height: context.setHeight(40),
                      fontSize: context.setSp(14),
                      contentPadding: EdgeInsets.fromLTRB(
                        context.setWidth(9.36),
                        context.setHeight(10.29),
                        context.setWidth(7.86),
                        context.setHeight(4.71),
                      ),
                      showLable: false,
                      borderRadius: context.setMinSize(8.01),
                      labelText: 'search'.tr,
                      hintText: 'search'.tr,
                      keyboardType: TextInputType.text,
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.setWidth(9.96),
                          vertical: context.setHeight(5.95),
                        ),
                        child: SvgPicture.asset(
                          AppImages.search,
                                                            package: 'shared_widgets',

                          color:
                              !SharedPr.isDarkMode!
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF9CA3AF),
                        ),
                      ),
                      suffixIcon: Builder(
                        builder: (iconContext) {
                          return InkWell(
                            onTap: () async {
                              filtterProductByCategory(
                                context: iconContext,
                                productController: productController,
                                isProductPage: false,
                                invoiceController: _invoiceController,
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.setWidth(9.96),
                                vertical: context.setHeight(5.95),
                              ),
                              child: SvgPicture.asset(
                                AppImages.filter,
                                                            package: 'shared_widgets',
                               
                              ),
                            ),
                          );
                        },
                      ),
                      onChanged: (qu) {
                        _invoiceController.pagingController.refresh();
                      },
                      onFieldSubmitted: (String query) async {
                        _invoiceController.getSuggestions(query);
                        _invoiceController.pagingController.refresh();
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: PagedListView<int, Product>(
                        padding: EdgeInsets.zero,
                        pagingController: _invoiceController.pagingController,
                        builderDelegate: PagedChildBuilderDelegate<Product>(
                          noItemsFoundIndicatorBuilder: (BuildContext context) {
                            return Center(
                              child: Text(
                                "empty_filter".tr,
                                style: TextStyle(
                                  fontSize: context.setSp(14),
                                  fontFamily: 'Tajawal',
                                  color:
                                      SharedPr.isDarkMode!
                                          ? Colors.white
                                          : Colors.black,
                                ),
                              ),
                            );
                          },
                          itemBuilder: (context, product, index) {
                            bool isSelected = _selectedIndex == index;
                            return InkWell(
                              onTap: () async {
                                ignoring = true;
                                controller.update();
                                _selectedIndex = index;
                                await _invoiceController.onSelectSearchItem(
                                  selectedProduct: product,
                                );
                                _invoiceController.isDialogOpen = false;
                                _invoiceController.barcodeFocus.requestFocus();
                                ignoring = false;
                                controller.update();
                                Navigator.pop(widget.dialogContext);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    context.setMinSize(8.0),
                                  ),
                                  color:
                                      isSelected
                                          ? AppColor.cyanTeal.withOpacity(0.15)
                                          : null,
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 0.0,
                                  ),
                                  tileColor:
                                      _selectedIndex == index
                                          ? Colors.blue[100]
                                          : null,
                                  selected: _selectedIndex == index,
                                  title: Text(
                                    product.getProductNameBasedOnLang.trim(),
                                    style: TextStyle(
                                      color:
                                          SharedPr.isDarkMode!
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: context.setSp(12),
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    spacing: context.setWidth(10),
                                    children: [
                                      SvgPicture.asset(
                                        AppImages.price,
                                                            package: 'shared_widgets',
                                        
                                        width: context.setMinSize(15),
                                        height: context.setMinSize(15),
                                        color: Colors.white,
                                      ),

                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: const Color(0xFF16A6B7),
                                            fontSize: context.setSp(11),
                                            fontFamily: 'Tajawal',
                                            fontWeight: FontWeight.w700,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: '${product.unitPrice}',
                                            ),
                                            TextSpan(text: " ${"S.R".tr}"),
                                          ],
                                        ),
                                        softWrap: true,
                                      ),
                                      if (product.barcode != null &&
                                          product.barcode != '')
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          spacing: context.setWidth(10),
                                          children: [
                                            SvgPicture.asset(AppImages.barcode,
                                                            package: 'shared_widgets',
                                             
                                              color: Color(0xffCFCBC5),
                                              width: context.setMinSize(15),
                                              height: context.setMinSize(15),
                                            ),
                                            Text(
                                              product.barcode!,
                                              style: TextStyle(
                                                color: const Color(0xFF16A6B7),
                                                fontSize: context.setSp(11),
                                                fontFamily: 'Tajawal',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (product.defaultCode != null &&
                                          product.defaultCode != '')
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          spacing: context.setWidth(10),
                                          children: [
                                            SvgPicture.asset(
                                              AppImages.barcode,
                                                            package: 'shared_widgets',
                                              
                                              color: Color(0xffCFCBC5),
                                              width: context.setMinSize(15),
                                              height: context.setMinSize(15),
                                            ),
                                            Text(
                                              product.defaultCode!,
                                              style: TextStyle(
                                                color: const Color(0xFF16A6B7),
                                                fontSize: context.setSp(11),
                                                fontFamily: 'Tajawal',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
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
