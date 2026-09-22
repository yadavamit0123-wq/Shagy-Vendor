import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/service_module/order/domain/models/booking_details_model.dart';
import 'package:sixam_mart_store/features/service_module/order/screens/change_service_location_screen.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class BookingServiceLocationSectionWidget extends StatelessWidget {
  final BookingDetailsModel booking;

  const BookingServiceLocationSectionWidget({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final bool atProviderLocation = booking.serviceLocation?.getServiceAt == 'provider';

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
          Expanded(child: Text('service_location'.tr, style: robotoBold)),
          if (booking.canManageBookingStatus) InkWell(
            onTap: () => ChangeServiceLocationScreen.show(
              bookingId: booking.id!,
              currentLocation: booking.serviceLocation?.getServiceAt,
              availableLocations: booking.provider?.serviceLocation,
            ),
            child: Icon(Icons.edit, size: 18, color: Theme.of(context).primaryColor),
          ),
        ]),
        Divider(thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.1)),

        _ServiceLocationHintBanner(atProviderLocation: atProviderLocation),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withAlpha(20),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${'service_location'.tr} :', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
            const SizedBox(height: 2),

            Text(booking.serviceLocation?.address ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
          ]),
        ),
      ]),
    );
  }
}

class _ServiceLocationHintBanner extends StatelessWidget {
  final bool atProviderLocation;

  const _ServiceLocationHintBanner({required this.atProviderLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: Colors.amber.shade100.withAlpha(120), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: RichText(text: TextSpan(
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black87),
        children: atProviderLocation ? [
          TextSpan(text: '${'customer_will_come_to'.tr} '),
          TextSpan(text: 'your_location'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black87)),
        ] : [
          TextSpan(text: '${'you_have_to_go_to'.tr} '),
          TextSpan(text: 'customer_location'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black87)),
        ],
      )),
    );
  }
}
