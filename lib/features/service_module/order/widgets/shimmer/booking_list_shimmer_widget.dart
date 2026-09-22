import 'package:flutter/material.dart';
import 'package:sixam_mart_store/common/widgets/custom_shimmer_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class BookingListShimmerWidget extends StatelessWidget {
  const BookingListShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const CustomShimmerWidget(height: 14, width: 150),
                  ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), child: const CustomShimmerWidget(height: 20, width: 60)),
                ]),
              ),

              Divider(color: Theme.of(context).primaryColor.withValues(alpha: 0.2), height: 1),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const CustomShimmerWidget(height: 12, width: 120),
                  const CustomShimmerWidget(height: 14, width: 60),
                ]),
              ),
            ]),
          ),
        );
      },
    );
  }
}
