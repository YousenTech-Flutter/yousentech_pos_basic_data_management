import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_colors.dart';

class TitalWidget extends StatelessWidget {
  TitalWidget({super.key, required this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.r, left: 20.r, right: 20.r),
      height: 30.h,
      width: 50.w,
      decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.all(Radius.circular(5.r))),
      child: Row(
        // mainAxisAlignment:
        //     MainAxisAlignment.spaceBetween,
        children: [
          // GetBuilder<InvoiceController>(builder: (controller) {
          // if (SharedPr.isTouchFeatureAvailable! &&!Get.find<SessionController>().isopenMenu && Get.currentRoute=="/SessionScreen") {
          //   return  Row(
          //     children: [
          //       buildIconButtonWithLabel(
          //         icon: iconButtonInvoice[0].icon,
          //         label: iconButtonInvoice[0].text.tr +
          //             iconButtonInvoice[0].shortcut.tr,
          //         isEnabled: true,
          //         index: 0,
          //         onPressed: () async {
          //           InvoiceController invoiceController =
          //               Get.isRegistered<InvoiceController>()
          //                   ? Get.find<InvoiceController>()
          //                   : Get.put(InvoiceController());
          //           await invoiceController.getIconOnPressedFunction(
          //               invoice: iconButtonInvoice[0]);
          //         },
          //       ),
          //       SizedBox(
          //     width: 20.r,
          //   ),
          //     ],
          //   );
          // }
          // return Container();

          // }),

          Container(
            height: 50.h,
            width: 4.w,
            decoration: BoxDecoration(
                color: AppColor.cyanTeal,
                borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(5.r),
                    bottomStart: Radius.circular(5.r))),
          ),
          SizedBox(
            width: 10.r,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              title.tr,
              style: TextStyle(
                  fontSize: 4.sp,
                  color: AppColor.slateGray,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal'),
            ),
          ),
        ],
      ),
    );
  }
}
