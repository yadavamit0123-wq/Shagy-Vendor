import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/domain/models/custom_service_request_model.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/screens/custom_service_request_details_screen.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class CustomServiceNotificationDialogWidget extends StatelessWidget {
  final CustomServiceRequestModel request;
  const CustomServiceNotificationDialogWidget({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 30),
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
            GestureDetector(
              onTap: () {
                Get.back();
                Get.to(() => CustomServiceRequestDetailsScreen(requestId: request.id!));
              },
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

                    InkWell(
                      onTap: () => Get.back(),
                      child: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [Icon(Icons.highlight_remove, size: 20)]),
                    ),

                    Center(
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge),
                          child: Text('new_booking_request_from'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          child: CustomImageWidget(height: 60, width: 60, fit: BoxFit.cover, image: request.customerImageFullUrl ?? ''),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeExtraSmall),
                          child: Text(request.customerName ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                        ),
                        if ((request.customerAddress ?? '').isNotEmpty)
                          Text(request.customerAddress!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                      ]),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                    Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: CustomImageWidget(image: request.categoryImageFullUrl ?? '', height: 40, width: 40),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeLarge),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(request.categoryName ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(request.subCategoryName ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ]),
                      ),
                    ]),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
