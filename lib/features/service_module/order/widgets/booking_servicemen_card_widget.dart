import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/service_module/order/domain/models/booking_details_model.dart';
import 'package:sixam_mart_store/features/service_module/order/screens/assign_serviceman_screen.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BookingServicemenCardWidget extends StatelessWidget {
  final BookingDetailsModel booking;
  const BookingServicemenCardWidget({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    List<BookingServiceManModel> servicemen = booking.servicemen ?? [];
    bool canManage = booking.canManageBookingStatus;

    if (servicemen.isEmpty && !canManage) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: [BoxShadow(offset: const Offset(0, 3), color: Colors.grey[Get.isDarkMode ? 700 : 200]!, blurRadius: 8, spreadRadius: 0)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Row(children: [
          Expanded(child: Text('assigned_servicemen'.tr, style: robotoBold)),
          if (servicemen.isNotEmpty && canManage) InkWell(
            onTap: () => AssignServicemanScreen.show(bookingId: booking.id!),
            child: Icon(Icons.edit, size: 18, color: Theme.of(context).primaryColor),
          ),
        ]),
        Divider(thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.1)),

        if (servicemen.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            child: CustomButtonWidget(
              buttonText: 'assign_serviceman'.tr,
              transparent: true,
              isBorder: true,
              height: 40,
              onPressed: () => AssignServicemanScreen.show(bookingId: booking.id!),
            ),
          )
        else
          ...servicemen.map((serviceman) => Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            child: Row(children: [
              ClipOval(child: CustomImageWidget(image: serviceman.imageFullUrl ?? '', height: 45, width: 45, fit: BoxFit.cover)),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(serviceman.name ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoMedium),
                  if ((serviceman.phone ?? '').isNotEmpty)
                    Text(serviceman.phone!, maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                ]),
              ),
              if ((serviceman.phone ?? '').isNotEmpty)
                IconButton(
                  onPressed: () async {
                    String url = 'tel:${serviceman.phone}';
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url, mode: LaunchMode.externalApplication);
                    } else {
                      showCustomSnackBar('unable_to_make_call'.tr);
                    }
                  },
                  icon: const Icon(Icons.call),
                ),
            ]),
          )),

      ]),
    );
  }
}
