import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/features/service_module/order/domain/models/booking_details_model.dart';
import 'package:sixam_mart_store/features/service_module/order/screens/reschedule_booking_screen.dart';
import 'package:sixam_mart_store/features/service_module/order/widgets/scheduled_booking_banner_widget.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

String _formatScheduleDate(String? scheduleAt) {
  return (scheduleAt == null || scheduleAt.isEmpty) ? '' : DateConverterHelper.dateTimeStringToShortDate(scheduleAt);
}

String _formatScheduleTime(String? scheduleAt) {
  return (scheduleAt == null || scheduleAt.isEmpty) ? '' : DateConverterHelper.dateTimeStringToTimeOnly(scheduleAt);
}

class ServiceScheduleSectionWidget extends StatelessWidget {
  final BookingDetailsModel booking;

  const ServiceScheduleSectionWidget({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final bool isRepeat = booking.bookingType == 'repeat';
    final bool isRepeatParent = booking.isRepeatParent == true;
    final bool showRepeatScheduleCard = isRepeat && isRepeatParent;
    final bool showSingleSchedule = (isRepeat && !isRepeatParent) || (!isRepeat && booking.scheduled == 1);
    final List<BookingRepeatLogModel> repeatLog = booking.repeatLog ?? [];

    if (!showRepeatScheduleCard && !showSingleSchedule) return const SizedBox.shrink();
    if (showRepeatScheduleCard && repeatLog.isEmpty) return const SizedBox.shrink();

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
          Expanded(child: Text('service_schedule'.tr, style: robotoBold)),
          if (showSingleSchedule && booking.bookingStatus == 'pending' && !isRepeatParent) InkWell(
            onTap: () => RescheduleBookingScreen.show(bookingId: booking.id!),
            child: Icon(Icons.edit_calendar_outlined, size: 18, color: Theme.of(context).primaryColor),
          ),
        ]),
        Divider(thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
        showRepeatScheduleCard ? _RepeatScheduleCard(repeatLog: repeatLog) : ScheduledBookingBannerWidget(booking: booking),
      ]),
    );
  }
}

class _RepeatScheduleCard extends StatelessWidget {
  final List<BookingRepeatLogModel> repeatLog;

  const _RepeatScheduleCard({required this.repeatLog});

  @override
  Widget build(BuildContext context) {
    final Color disabled = Theme.of(context).disabledColor;
    final Color? bodyColor = Theme.of(context).textTheme.bodyLarge?.color;
    final String fromDate = _formatScheduleDate(repeatLog.first.scheduleAt);
    final String toDate = _formatScheduleDate(repeatLog.last.scheduleAt);
    final int totalTimes = repeatLog.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Column(children: [
        Text('this_booking_will_be_continued'.tr, textAlign: TextAlign.center, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: bodyColor)),
        const SizedBox(height: 2),
        Text('within_the_selected_days'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: disabled)),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        RichText(textAlign: TextAlign.center, text: TextSpan(
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: bodyColor),
          children: [
            TextSpan(text: '${'from'.tr} '),
            TextSpan(text: fromDate, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
            TextSpan(text: '  ${'to'.tr}  '),
            TextSpan(text: toDate, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
          ],
        )),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        RichText(textAlign: TextAlign.center, text: TextSpan(
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: bodyColor),
          children: [
            TextSpan(text: '${'you_will_receive_this_services_total'.tr} '),
            TextSpan(text: '$totalTimes ', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: bodyColor)),
            TextSpan(text: 'times'.tr),
          ],
        )),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        CustomButtonWidget(
          buttonText: 'view_schedules'.tr, height: 40, width: 150, radius: Dimensions.radiusDefault,
          color: Theme.of(context).primaryColor, textColor: Theme.of(context).cardColor,
          fontSize: Dimensions.fontSizeDefault,
          onPressed: () => showModalBottomSheet(
            context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
            builder: (_) => _ScheduledListSheet(repeatLog: repeatLog),
          ),
        ),
      ]),
    );
  }
}

class _ScheduledListSheet extends StatelessWidget {
  final List<BookingRepeatLogModel> repeatLog;

  const _ScheduledListSheet({required this.repeatLog});

  @override
  Widget build(BuildContext context) {
    final Color disabled = Theme.of(context).disabledColor;

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge))),
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeLarge),
      child: SafeArea(
        top: false,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Center(
            child: Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(color: disabled.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)),
            ),
          ),

          Text('scheduled_list'.tr, textAlign: TextAlign.center, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          const SizedBox(height: 4),
          Text('you_will_receive_your_service_in_the_days_bellow'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: disabled)),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          for (int i = 0; i < repeatLog.length; i++) ...[
            _ScheduleListRow(entry: repeatLog[i]),
            if (i != repeatLog.length - 1) const SizedBox(height: Dimensions.paddingSizeSmall),
          ],
        ]),
      ),
    );
  }
}

class _ScheduleListRow extends StatelessWidget {
  final BookingRepeatLogModel entry;

  const _ScheduleListRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final Color disabled = Theme.of(context).disabledColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: disabled.withAlpha(20), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(_formatScheduleDate(entry.scheduleAt), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
        Row(children: [
          Text(_formatScheduleTime(entry.scheduleAt), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: disabled)),
          const SizedBox(width: 4),
          Icon(Icons.access_time_rounded, size: 16, color: disabled),
        ]),
      ]),
    );
  }
}
