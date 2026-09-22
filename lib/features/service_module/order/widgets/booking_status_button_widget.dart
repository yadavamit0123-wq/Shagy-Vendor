import 'package:sixam_mart_store/common/widgets/custom_ink_well_widget.dart';
import 'package:sixam_mart_store/features/service_module/order/controllers/booking_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';

class BookingStatusButtonWidget extends StatelessWidget {
  final String title;
  final int index;
  final BookingController bookingController;
  final bool fromHistory;
  const BookingStatusButtonWidget({super.key, required this.title, required this.index, required this.bookingController, required this.fromHistory});

  @override
  Widget build(BuildContext context) {
    int selectedIndex = fromHistory ? bookingController.historyIndex : bookingController.runningIndex;
    bool isSelected = selectedIndex == index;
    int? length = (!fromHistory && bookingController.runningBookings != null)
        ? (bookingController.runningBookings![index].totalSize ?? bookingController.runningBookings![index].bookingList.length)
        : null;

    return Padding(
      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
      child: CustomInkWellWidget(
        radius: Dimensions.radiusDefault,
        onTap: () => fromHistory ? bookingController.setHistoryIndex(index) : bookingController.setRunningIndex(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(bottom: BorderSide(color: isSelected ? Theme.of(context).primaryColor : Colors.transparent, width: 1)),
          ),
          alignment: Alignment.center,
          child: Row(children: [
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
            ),

            length != null ? Container(
              margin: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 2),
              child: Text('($length)', maxLines: 1, overflow: TextOverflow.ellipsis,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
              ),
            ) : const SizedBox(),
          ]),
        ),
      ),
    );
  }
}
