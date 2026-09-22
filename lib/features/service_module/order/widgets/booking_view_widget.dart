import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/paginated_list_widget.dart';
import 'package:sixam_mart_store/features/service_module/order/controllers/booking_controller.dart';
import 'package:sixam_mart_store/features/service_module/order/domain/models/booking_model.dart';
import 'package:sixam_mart_store/features/service_module/order/widgets/booking_card_widget.dart';

class BookingViewWidget extends StatefulWidget {
  const BookingViewWidget({super.key});

  @override
  State<BookingViewWidget> createState() => _BookingViewWidgetState();
}

class _BookingViewWidgetState extends State<BookingViewWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(builder: (bookingController) {
      List<BookingModel> bookingList = bookingController.historyBookingList!;

      return RefreshIndicator(
        onRefresh: () => bookingController.getPaginatedBookings(1, true),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: PaginatedListWidget(
            scrollController: _scrollController,
            onPaginate: (offset) => bookingController.getPaginatedBookings(offset!, false),
            totalSize: bookingController.historyTotalSize,
            offset: bookingController.historyOffset,
            productView: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bookingList.length,
              itemBuilder: (context, index) => BookingCardWidget(
                bookingModel: bookingList[index],
                hasDivider: index != bookingList.length - 1,
              ),
            ),
          ),
        ),
      );
    });
  }
}
