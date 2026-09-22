import 'package:flutter/material.dart';
import 'package:sixam_mart_store/common/widgets/custom_shimmer_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class OtherProviderOfferListShimmerWidget extends StatelessWidget {
  const OtherProviderOfferListShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.15)),
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const ClipRRect(borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusSmall)), child: CustomShimmerWidget(height: 65, width: 65)),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                CustomShimmerWidget(height: 15, width: 140),
                SizedBox(height: Dimensions.paddingSizeExtraSmall),
                CustomShimmerWidget(height: 10, width: 90),
                SizedBox(height: Dimensions.paddingSizeExtraSmall),
                CustomShimmerWidget(height: 14, width: 100),
              ]),
            ),
          ]),
        );
      },
    );
  }
}
