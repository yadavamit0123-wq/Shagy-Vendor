import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/domain/models/provider_offer_model.dart' show ProviderOfferModel;
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class OtherProviderOfferCardWidget extends StatelessWidget {
  final ProviderOfferModel offer;
  const OtherProviderOfferCardWidget({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.15)),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          child: CustomImageWidget(height: 65, width: 65, fit: BoxFit.cover, image: offer.provider?.imageFullUrl ?? ''),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(offer.provider?.name ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Row(children: [
              Icon(Icons.star, color: Theme.of(context).colorScheme.primary, size: 10),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text((offer.provider?.avgRating ?? 0).toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text('${offer.provider?.reviewCount ?? 0} ${'reviews'.tr}', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
            ]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text('price_offered'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error)),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text(PriceConverterHelper.convertPrice(offer.offerPrice ?? 0), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor)),
            ]),
          ]),
        ),
      ]),
    );
  }
}
