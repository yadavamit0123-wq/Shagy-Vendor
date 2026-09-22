import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/order/widgets/count_widget.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/service_module/order/controllers/booking_controller.dart';
import 'package:sixam_mart_store/features/service_module/order/widgets/booking_status_button_widget.dart';
import 'package:sixam_mart_store/features/service_module/order/widgets/booking_view_widget.dart';
import 'package:sixam_mart_store/features/service_module/order/widgets/shimmer/booking_list_shimmer_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class BookingHistoryBodyWidget extends StatelessWidget {
  const BookingHistoryBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(builder: (bookingController) {
      return (Get.find<ProfileController>().modulePermission?.order ?? false) ? Container(
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Column(children: [

          GetBuilder<ProfileController>(builder: (profileController) {
            return profileController.profileModel != null ? Container(
              margin: EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                boxShadow: [BoxShadow(
                  offset: Offset(0, 1),
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                )]
              ),
              child: Row(children: [
                CountWidget(title: 'today'.tr, count: profileController.profileModel!.todaysOrderCount),
                Container(width: 1, height: 30, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                CountWidget(title: 'this_week'.tr, count: profileController.profileModel!.thisWeekOrderCount),
                Container(width: 1, height: 30, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                CountWidget(title: 'this_month'.tr, count: profileController.profileModel!.thisMonthOrderCount),
              ]),
            ) : const SizedBox();
          }),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: bookingController.historyStatusList.length,
              itemBuilder: (context, index) {
                return BookingStatusButtonWidget(
                  title: bookingController.historyStatusList[index].tr, index: index, bookingController: bookingController, fromHistory: true,
                );
              },
            ),
          ),
          SizedBox(height: bookingController.historyBookingList != null ? Dimensions.paddingSizeSmall : 0),

          Expanded(
            child: bookingController.isHistoryBookingLoading
                ? const SingleChildScrollView(padding: EdgeInsets.only(top: Dimensions.paddingSizeSmall), child: BookingListShimmerWidget())
                : (bookingController.historyBookingList != null && bookingController.historyBookingList!.isNotEmpty)
                ? const BookingViewWidget() : Center(child: Text('no_booking_found'.tr)),
          ),

        ]),
      ) : Center(child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium));
    });
  }
}
