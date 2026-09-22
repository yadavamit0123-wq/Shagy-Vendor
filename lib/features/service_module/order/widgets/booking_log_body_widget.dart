import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_ink_well_widget.dart';
import 'package:sixam_mart_store/features/service_module/order/domain/models/booking_details_model.dart';
import 'package:sixam_mart_store/features/service_module/order/helper/booking_status_helper.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class BookingLogBodyWidget extends StatelessWidget {
  final int bookingId;
  final List<BookingRepeatLogModel> repeatLog;
  const BookingLogBodyWidget({super.key, required this.bookingId, required this.repeatLog});

  @override
  Widget build(BuildContext context) {
    if (repeatLog.isEmpty) {
      return Center(child: Text('no_data_found'.tr, style: robotoRegular));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      itemCount: repeatLog.length,
      itemBuilder: (context, index) {
        BookingRepeatLogModel log = repeatLog[index];
        bool isCurrent = log.id == bookingId;

        return Container(
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).cardColor,
            border: Border.all(color: isCurrent ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.3)),
          ),
          child: CustomInkWellWidget(
            onTap: isCurrent ? () {} : () => Get.offNamed(RouteHelper.getBookingDetailsRoute(log.id!)),
            radius: Dimensions.radiusDefault,
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${'booking'.tr} # ${log.displayId ?? log.id}', style: robotoBold),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  if ((log.scheduleAt ?? '').isNotEmpty)
                    Text(
                      DateConverterHelper.utcToDateTime(log.scheduleAt!),
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                    ),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                  color: BookingStatusHelper.color(log.bookingStatus).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Text(
                  log.bookingStatus?.tr ?? '',
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: BookingStatusHelper.color(log.bookingStatus)),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
