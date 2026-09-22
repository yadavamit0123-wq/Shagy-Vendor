import 'package:flutter/material.dart';
import 'package:sixam_mart_store/common/widgets/custom_shimmer_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class CustomServiceRequestDetailsShimmerWidget extends StatelessWidget {
  const CustomServiceRequestDetailsShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          /// Header
          Center(
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge),
                child: CustomShimmerWidget(height: 16, width: 200),
              ),
              const ClipRRect(borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusSmall)), child: CustomShimmerWidget(height: 60, width: 60)),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeExtraSmall),
                child: CustomShimmerWidget(height: 14, width: 140),
              ),
              const CustomShimmerWidget(height: 12, width: 180),
            ]),
          ),

          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const ClipRRect(borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusSmall)), child: CustomShimmerWidget(height: 40, width: 40)),
            const SizedBox(width: Dimensions.paddingSizeLarge),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                CustomShimmerWidget(height: 14, width: 160),
                SizedBox(height: Dimensions.paddingSizeExtraSmall),
                CustomShimmerWidget(height: 12, width: 100),
              ]),
            ),
          ]),

          const Padding(
            padding: EdgeInsets.fromLTRB(0, Dimensions.paddingSizeLarge, 0, Dimensions.paddingSizeExtraSmall),
            child: CustomShimmerWidget(height: 14, width: 90),
          ),
          const CustomShimmerWidget(height: 12, width: double.infinity),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          const CustomShimmerWidget(height: 12, width: double.infinity),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          const CustomShimmerWidget(height: 12, width: 220),

        ]),
      ),
    );
  }
}
