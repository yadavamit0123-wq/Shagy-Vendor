import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProviderTemporarilyClosedWidget extends StatelessWidget {
  const ProviderTemporarilyClosedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(offset: const Offset(0, 3), color: Colors.grey[Get.isDarkMode ? 700 : 200]!, blurRadius: 8, spreadRadius: 0)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Text('provider_temporarily_closed'.tr, style: robotoMedium),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Text('provider_availability_status_notice'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          profileController.modulePermission != null && profileController.modulePermission!.storeSetup! ? Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall - 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.3), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Row(children: [
                Expanded(child: Text(
                  'status'.tr,
                  style: robotoMedium,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                )),

                Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: !profileController.isStoreActive,
                    activeTrackColor: Theme.of(context).primaryColor,
                    inactiveTrackColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                    onChanged: (bool isActive) {
                      Get.dialog(ConfirmationDialogWidget(
                        icon: Images.warning,
                        description: isActive ? 'are_you_sure_to_close_store'.tr : 'are_you_sure_to_open_store'.tr,
                        onYesPressed: () {
                          Get.back();
                          profileController.setStoreStatus(!isActive);
                          Get.find<AuthController>().toggleStoreClosedStatus();
                        },
                      ));
                    },
                  ),
                ),
              ]),
            ),
          ) : const SizedBox(),

        ]),
      );
    });
  }
}
