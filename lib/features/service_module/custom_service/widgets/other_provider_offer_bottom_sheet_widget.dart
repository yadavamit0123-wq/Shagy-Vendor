import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/paginated_list_widget.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/controllers/custom_service_controller.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/widgets/other_provider_offer_card_widget.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/widgets/shimmer/other_provider_offer_list_shimmer_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class OtherProviderOfferBottomSheetWidget extends StatelessWidget {
  final int requestId;
  const OtherProviderOfferBottomSheetWidget({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusLarge), topRight: Radius.circular(Dimensions.radiusLarge)),
          color: Theme.of(context).cardColor,
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(children: [

          Container(
            width: 80, height: 4,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Theme.of(context).hintColor),
            margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
          ),

          Text('others_provider_offer'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Expanded(
            child: GetBuilder<CustomServiceController>(builder: (controller) {
              final offers = controller.otherBids;
              if (offers == null) {
                return const OtherProviderOfferListShimmerWidget();
              }
              if (offers.isEmpty) {
                return Center(child: Text('no_other_provider_bid_this_post'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)));
              }
              return SingleChildScrollView(
                controller: scrollController,
                child: PaginatedListWidget(
                  scrollController: scrollController,
                  onPaginate: (offset) => controller.getOtherBids(requestId, offset: offset.toString()),
                  totalSize: controller.otherBidsTotalSize,
                  offset: controller.otherBidsOffset,
                  productView: ListView.builder(
                    itemCount: offers.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => OtherProviderOfferCardWidget(offer: offers[index]),
                  ),
                ),
              );
            }),
          ),
        ]),
      ),
    );
  }
}
