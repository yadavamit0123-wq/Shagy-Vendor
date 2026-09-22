import 'package:flutter/material.dart';
import 'package:sixam_mart_store/common/widgets/custom_shimmer_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class CustomServiceRequestListShimmerWidget extends StatelessWidget {
  const CustomServiceRequestListShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.15)),
            ),
            child: Column(children: [

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const ClipRRect(borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusSmall)), child: CustomShimmerWidget(height: 40, width: 40)),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                      CustomShimmerWidget(height: 16, width: 140),
                      SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      CustomShimmerWidget(height: 12, width: 100),
                    ]),
                  ),
                ]),
              ),

              Divider(color: Theme.of(context).primaryColor.withValues(alpha: 0.2), height: 1),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                child: CustomShimmerWidget(height: 12, width: 120),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const ClipRRect(borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusSmall)), child: CustomShimmerWidget(height: 30, width: 30)),
                  const SizedBox(width: Dimensions.paddingSizeDefault),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                      CustomShimmerWidget(height: 14, width: 110),
                      SizedBox(height: 2),
                      CustomShimmerWidget(height: 10, width: 80),
                    ]),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  const CustomShimmerWidget(height: 30, width: 80),
                ]),
              ),
            ]),
          ),
        );
      },
    );
  }
}
