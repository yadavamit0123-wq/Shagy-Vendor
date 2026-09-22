import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/service_module/order/controllers/booking_controller.dart';
import 'package:sixam_mart_store/features/service_module/order/domain/models/booking_model.dart';
import 'package:sixam_mart_store/features/service_module/order/widgets/booking_card_widget.dart';
import 'package:sixam_mart_store/features/service_module/order/widgets/booking_status_button_widget.dart';
import 'package:sixam_mart_store/features/service_module/order/widgets/shimmer/booking_list_shimmer_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class RunningBookingBodyWidget extends StatelessWidget {
  const RunningBookingBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(builder: (bookingController) {
      List<BookingModel> bookingList = [];
      if (bookingController.runningBookings != null) {
        bookingList = bookingController.getFilteredBookingList(bookingController.runningBookings![bookingController.runningIndex].bookingList);
      }

      return (Get.find<ProfileController>().modulePermission?.order ?? false) ? Container(
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeSmall), child: InkWell(
                onTap: () => bookingController.toggleCampaignOnly(),
                child: Row(children: [
                  SizedBox(height: 24, width: 24, child: Checkbox(
                    side: BorderSide(color: Theme.of(context).disabledColor, width: 1),
                    activeColor: Theme.of(context).primaryColor,
                    value: bookingController.campaignOnly,
                    onChanged: (isActive) => bookingController.toggleCampaignOnly(),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Text('campaign_orders_only'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                ]),
              )),
            )),

            if (bookingController.runningBookings != null)
              SliverPersistentHeader(pinned: true, delegate: _RunningBookingSliverDelegate(height: 50,
                child: Container(height: 40, color: Theme.of(context).cardColor, child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  scrollDirection: Axis.horizontal,
                  itemCount: bookingController.runningBookings!.length,
                  itemBuilder: (context, index) => BookingStatusButtonWidget(
                    title: bookingController.runningBookings![index].status.tr,
                    index: index,
                    bookingController: bookingController,
                    fromHistory: false,
                  ),
                )),
              )),

            if (bookingController.isRunningBookingLoading)
              const SliverToBoxAdapter(child: BookingListShimmerWidget())
            else
              bookingList.isNotEmpty ? SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return BookingCardWidget(bookingModel: bookingList[index], hasDivider: index != bookingList.length - 1);
                }, childCount: bookingList.length),
              ) : SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 100),
                  child: Center(child: Text('no_booking_found'.tr)),
                ),
              ),
          ],
        ),
      ) : Center(child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium));
    });
  }
}

class _RunningBookingSliverDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _RunningBookingSliverDelegate({required this.child, required this.height});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(height: height, child: child);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_RunningBookingSliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height || oldDelegate.minExtent != height || child != oldDelegate.child;
  }
}
