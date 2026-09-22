import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/controllers/custom_service_controller.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/domain/models/custom_service_request_model.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/screens/custom_service_request_details_screen.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class CustomServiceRequestCardWidget extends StatelessWidget {
  final CustomServiceRequestModel request;
  final bool newRequest;
  const CustomServiceRequestCardWidget({super.key, required this.request, required this.newRequest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Dismissible(
        key: ValueKey(request.id),
        direction: newRequest ? DismissDirection.endToStart : DismissDirection.none,
        confirmDismiss: (_) => _confirmRemoval(context),
        onDismissed: (_) => Get.find<CustomServiceController>().removeNewRequestLocally(request.id!),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
        ),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImageWidget(image: request.customerImageFullUrl ?? '', height: 40, width: 40, fit: BoxFit.cover),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(request.customerName ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 1, overflow: TextOverflow.ellipsis),
                    if ((request.customerAddress ?? '').isNotEmpty) ...[
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Text(request.customerAddress!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ]),
                ),
              ]),
            ),

            Divider(color: Theme.of(context).primaryColor.withValues(alpha: 0.2), height: 1),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
              child: Row(children: [
                Icon(Icons.calendar_month_outlined, size: 18, color: Theme.of(context).hintColor),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Text(request.bookingDate ?? (request.createdAt ?? ''), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
              ]),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImageWidget(image: request.categoryImageFullUrl ?? '', height: 30, width: 30, fit: BoxFit.cover),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(request.categoryName ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(request.subCategoryName ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                  ]),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                InkWell(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  onTap: () => Get.to(() => CustomServiceRequestDetailsScreen(requestId: request.id!)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: 8),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault), color: Theme.of(context).primaryColor),
                    child: Text(
                      newRequest ? 'place_offer'.tr : 'view_details'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).cardColor),
                    ),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Future<bool> _confirmRemoval(BuildContext context) async {
    final bool? result = await Get.dialog<bool>(ConfirmationDialogWidget(
      icon: Images.cautionDialogIcon,
      title: 'ignore'.tr,
      description: 'do_you_want_to_ignore_this_request'.tr,
      onYesPressed: () => Get.back(result: true),
    ));
    return result ?? false;
  }
}
