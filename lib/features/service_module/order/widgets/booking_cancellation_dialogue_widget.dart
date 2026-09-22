import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/service_module/order/controllers/booking_controller.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class BookingCancellationDialogueWidget extends StatelessWidget {
  final int bookingId;
  const BookingCancellationDialogueWidget({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    Get.find<BookingController>().getBookingCancelReasons();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GetBuilder<BookingController>(
        builder: (bookingController) {
          return SizedBox(
            width: 500, height: MediaQuery.of(context).size.height * 0.6,
            child: Column(children: [

              Container(
                width: 500,
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[200]!, spreadRadius: 1, blurRadius: 5)],
                ),
                child: Column(children: [
                  Text('select_cancellation_reasons'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                ]),
              ),

              Expanded(
                child: bookingController.bookingCancelReasons != null ? bookingController.bookingCancelReasons!.isNotEmpty ? ListView.builder(
                  itemCount: bookingController.bookingCancelReasons!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: ListTile(
                      onTap: (){
                        bookingController.setBookingCancelReason(bookingController.bookingCancelReasons![index].reason);
                      },
                      title: Row(
                        children: [
                          Icon(bookingController.bookingCancelReasons![index].reason == bookingController.cancelReason ? Icons.radio_button_checked : Icons.radio_button_off, color: Theme.of(context).primaryColor, size: 18),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Flexible(child: Text(bookingController.bookingCancelReasons![index].reason!, style: robotoRegular, maxLines: 3, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  );
                }) : Center(child: Text('no_reasons_available'.tr)) : const Center(child: CircularProgressIndicator()),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeDefault, vertical: Dimensions.paddingSizeSmall),
                child: !bookingController.isLoading ? Row(children: [
                  Expanded(child: CustomButtonWidget(
                    buttonText: 'cancel'.tr, color: Theme.of(context).disabledColor, radius: 50,
                    onPressed: () => Get.back(),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(child: CustomButtonWidget(
                    buttonText: 'submit'.tr,  radius: 50,
                    onPressed: (){
                      if(bookingController.cancelReason != '' && bookingController.cancelReason != null){
                        bookingController.updateBookingStatus(bookingId, AppConstants.canceled, cancellationReason: bookingController.cancelReason, back: true);
                      }else{
                        if(Get.isDialogOpen!){
                          Get.back();
                        }

                        showCustomSnackBar('you_did_not_select_any_reason'.tr);
                      }
                    },
                  )),
                ]) : const Center(child: CircularProgressIndicator()),
              ),
            ]),
          );
        }
      ),
    );
  }
}
