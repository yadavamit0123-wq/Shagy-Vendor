import 'package:sixam_mart_store/features/service_module/service_campaign/controllers/service_campaign_controller.dart';
import 'package:sixam_mart_store/features/service_module/service_campaign/domain/models/service_campaign_model.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceCampaignWidget extends StatelessWidget {
  final ServiceCampaignModel campaignModel;
  const ServiceCampaignWidget({super.key, required this.campaignModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getServiceCampaignDetailsRoute(id: campaignModel.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[300]!, spreadRadius: 1, blurRadius: 5)],
        ),
        child: Row(children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: CustomImageWidget(
              image: '${campaignModel.imageFullUrl}',
              height: 85, width: 100, fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

            Text(campaignModel.title ?? '', style: robotoMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(
              campaignModel.description ?? 'no_description_found'.tr, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Row(children: [

              InkWell(
                onTap: () {
                  if(campaignModel.vendorStatus == null){
                    Get.dialog(ConfirmationDialogWidget(
                      icon: Images.warning, description: campaignModel.isJoined ?? false ? 'are_you_sure_to_leave'.tr : 'are_you_sure_to_join'.tr,
                      adminText: '' ,
                      onYesPressed: () {
                        Get.find<ServiceCampaignController>().joinCampaign(campaignModel.id, false);
                      },
                    ));
                  }else if(campaignModel.vendorStatus == 'confirmed'){
                    Get.dialog(ConfirmationDialogWidget(
                      icon: Images.warning, description: campaignModel.isJoined ?? false ? 'are_you_sure_to_leave'.tr : 'are_you_sure_to_join'.tr,
                      adminText: '' ,
                      onYesPressed: () {
                        Get.find<ServiceCampaignController>().leaveCampaign(campaignModel.id, false);
                      },
                    ));
                  }

                },
                child: Container(
                  height: 25, width: 70, alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: campaignModel.vendorStatus == null ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Text(campaignModel.vendorStatus == null ? 'join_now'.tr : campaignModel.vendorStatus != 'confirmed'
                      ? campaignModel.vendorStatus!.tr : 'leave_now'.tr, textAlign: TextAlign.center, style: robotoBold.copyWith(
                    color: Theme.of(context).cardColor,
                    fontSize: Dimensions.fontSizeExtraSmall,
                  )),
                ),
              ),
              const Expanded(child: SizedBox()),

              Icon(Icons.date_range, size: 15, color: Theme.of(context).disabledColor),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Text(
                campaignModel.availableDateStarts != null ? DateConverterHelper.convertDateToDate(campaignModel.availableDateStarts!) : '',
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
              ),

            ]),

          ])),

        ]),
      ),
    );
  }
}
