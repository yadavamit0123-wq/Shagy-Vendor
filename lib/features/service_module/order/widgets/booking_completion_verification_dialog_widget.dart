import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/service_module/order/controllers/booking_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class BookingCompletionVerificationDialogWidget extends StatefulWidget {
  final int bookingId;
  const BookingCompletionVerificationDialogWidget({super.key, required this.bookingId});

  @override
  State<BookingCompletionVerificationDialogWidget> createState() => _BookingCompletionVerificationDialogWidgetState();
}

class _BookingCompletionVerificationDialogWidgetState extends State<BookingCompletionVerificationDialogWidget> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serviceModule = Get.find<SplashController>().configModel?.serviceModule;
    final bool otpRequired = serviceModule?.otpForCompleteService ?? false;
    final bool photoRequired = serviceModule?.completePhotoEvidence ?? false;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GetBuilder<BookingController>(builder: (bookingController) {
        return SizedBox(
          width: 500,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text('complete_service'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Text(
                'you_want_to_complete_this_service'.tr,
                style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              if (otpRequired) ...[
                Text('otp'.tr, style: robotoMedium),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  style: robotoRegular,
                  decoration: InputDecoration(
                    hintText: 'enter_otp_number'.tr,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
              ],

              if (photoRequired) ...[
                Text('photo_evidence'.tr, style: robotoMedium),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: bookingController.completionEvidenceImages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == bookingController.completionEvidenceImages.length) {
                        return InkWell(
                          onTap: () => bookingController.pickCompletionEvidenceImage(),
                          child: Container(
                            height: 100, width: 100, alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                            ),
                            child: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
                          ),
                        );
                      }

                      XFile file = bookingController.completionEvidenceImages[index];
                      return Container(
                        margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                        width: 100,
                        child: Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child: GetPlatform.isWeb
                                ? Image.network(file.path, height: 100, width: 100, fit: BoxFit.cover)
                                : Image.file(File(file.path), height: 100, width: 100, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 2, right: 2,
                            child: InkWell(
                              onTap: () => bookingController.removeCompletionEvidenceImage(index),
                              child: const CircleAvatar(
                                radius: 10, backgroundColor: Colors.red,
                                child: Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
              ],

              !bookingController.isLoading ? Row(children: [
                Expanded(child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40), padding: EdgeInsets.zero,
                    backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                  ),
                  child: Text('cancel'.tr, style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodySmall!.color)),
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: CustomButtonWidget(
                  buttonText: 'submit'.tr, height: 40, radius: Dimensions.radiusSmall,
                  onPressed: () {
                    if (otpRequired && _otpController.text.trim().isEmpty) {
                      showCustomSnackBar('please_enter_otp'.tr);
                      return;
                    }
                    if (photoRequired && bookingController.completionEvidenceImages.isEmpty) {
                      showCustomSnackBar('please_add_at_least_one_photo'.tr);
                      return;
                    }
                    bookingController.updateBookingStatus(
                      widget.bookingId, AppConstants.completed,
                      otp: otpRequired ? _otpController.text.trim() : null,
                    );
                  },
                )),
              ]) : const Center(child: CircularProgressIndicator()),
            ]),
          ),
        );
      }),
    );
  }
}
