import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:sixam_mart_store/features/service_module/order/domain/models/booking_details_model.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class ScheduledBookingBannerWidget extends StatelessWidget {
  final BookingDetailsModel booking;

  const ScheduledBookingBannerWidget({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final String scheduledTime = booking.scheduleAt != null ? DateConverterHelper.dateTimeStringToDateTime(booking.scheduleAt!) : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
      child: Row(children: [
        Container(
          height: 30, width: 30,
          decoration: BoxDecoration(color: Theme.of(context).disabledColor.withValues(alpha: 0.10), shape: BoxShape.circle),
          child: Icon(Icons.event_available_rounded, color: Theme.of(context).disabledColor, size: 16),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('scheduled_booking'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
          const SizedBox(height: 1),

          Row(children: [
            Icon(Icons.access_time_rounded, size: 12, color: Theme.of(context).disabledColor),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Flexible(child: Text(scheduledTime, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor))),
          ]),
        ])),
      ]),
    );
  }
}
