import 'package:sixam_mart_store/common/widgets/custom_ink_well_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_tool_tip_widget.dart';
import 'package:sixam_mart_store/features/service_module/order/domain/models/booking_model.dart';
import 'package:sixam_mart_store/features/service_module/order/helper/booking_status_helper.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingCardWidget extends StatelessWidget {
  final BookingModel bookingModel;
  final bool hasDivider;
  const BookingCardWidget({super.key, required this.bookingModel, required this.hasDivider});

  @override
  Widget build(BuildContext context) {
    bool isRepeatBooking = bookingModel.bookingType == 'repeat';
    Color statusColor = BookingStatusHelper.color(isRepeatBooking ? bookingModel.activeBookingStatus : bookingModel.bookingStatus);

    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: Colors.white.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: CustomInkWellWidget(
        onTap: () => Get.toNamed(RouteHelper.getBookingDetailsRoute(bookingModel.id!)),
        radius: Dimensions.radiusDefault,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Row(children: [
                      Text('booking'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                      Text(' # ${bookingModel.id}', style: robotoBold),
                      if (bookingModel.bookingType == 'repeat') Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                        child: CustomToolTip(
                          message: 'repeat_booking'.tr,
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.repeat_rounded, size: 14, color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      if (bookingModel.isCampaign == true) Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                        child: CustomToolTip(
                          message: 'campaign'.tr,
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.info_outline, size: 14, color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      if (bookingModel.detailsCount != null) Text(
                        ' (${bookingModel.detailsCount} ${bookingModel.detailsCount! < 2 ? 'service'.tr : 'services'.tr})',
                        style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ])),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isRepeatBooking
                            ? (bookingModel.activeStatusLabel ?? bookingModel.activeBookingStatus?.tr ?? '')
                            : (bookingModel.statusLabel ?? bookingModel.bookingStatus?.tr ?? ''),
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: statusColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text(
                  DateConverterHelper.utcToDateTime(bookingModel.createdAt ?? ''),
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5)),
                ),
              ],
            ),
            const Divider(height: Dimensions.paddingSizeDefault),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('services'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Text(
                  (bookingModel.services != null && bookingModel.services!.isNotEmpty) ? bookingModel.services!.map((s) => s.name).join(', ') : '',
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              ])),

              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(
                  bookingModel.paymentMethod == 'cash_after_service' ? 'cash'.tr
                      : bookingModel.paymentMethod == 'wallet' ? 'wallet_payment'.tr
                      : bookingModel.paymentMethod == 'digital_payment' ? 'digital_payment'.tr
                      : bookingModel.paymentMethod?.replaceAll('_', ' ') ?? '',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Text(PriceConverterHelper.convertPrice(bookingModel.bookingAmount ?? 0), style: robotoBold),
              ]),

            ]),

          ]),
        ),
      ),
    );
  }
}
