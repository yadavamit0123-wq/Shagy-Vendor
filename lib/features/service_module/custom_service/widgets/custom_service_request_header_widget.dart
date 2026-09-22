import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class CustomServiceRequestHeaderWidget extends StatelessWidget {
  final String? customerName;
  final String? customerImage;
  final String? subtitle;
  final bool showInfoTooltip;
  final VoidCallback onToggleInfo;
  const CustomServiceRequestHeaderWidget({
    super.key, required this.customerName, required this.customerImage, required this.subtitle,
    required this.showInfoTooltip, required this.onToggleInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge),
            child: Text('new_booking_request_from'.tr,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 1, overflow: TextOverflow.ellipsis)
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: CustomImageWidget(height: 60, width: 60, fit: BoxFit.cover, image: customerImage ?? ''),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeExtraSmall),
            child: Text(customerName ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
          ),
          if ((subtitle ?? '').isNotEmpty)
            Text(subtitle!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor), maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
        ]),
      ),
      if (showInfoTooltip)
        Positioned(
          top: 30, left: 20, right: 20,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusLarge), color: Theme.of(context).primaryColorDark.withValues(alpha: 0.95)),
            width: Get.width * .85,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
            child: Text('accept_service_request_instruction'.tr, style: robotoRegular.copyWith(color: Colors.white.withValues(alpha: 0.8), fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),
          ),
        ),
    ]);
  }
}
