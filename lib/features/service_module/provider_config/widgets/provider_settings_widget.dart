import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_card.dart';
import 'package:sixam_mart_store/common/widgets/switch_button_widget.dart';
import 'package:sixam_mart_store/features/service_module/provider_config/controllers/provider_config_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProviderSettingsWidget extends StatelessWidget {
  const ProviderSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ServiceModule? serviceModule = Get.find<SplashController>().configModel?.serviceModule;
    bool showInstantBooking = serviceModule?.instantBooking ?? false;
    bool showRepeatBooking = serviceModule?.repeatBooking ?? false;
    bool showScheduleBooking = serviceModule?.scheduleBooking ?? false;
    bool showBookingTypes = showInstantBooking || showRepeatBooking || showScheduleBooking;
    bool showServicemenPermission = serviceModule?.servicemanCancelBookingReq ?? false;
    bool showProviderPlace = serviceModule?.atProviderPlace ?? false;
    List<Map<String, String>> serviceLocationOptions = ProviderConfigController.serviceLocationOptions
        .where((option) => option['value'] != 'provider' || showProviderPlace).toList();

    return GetBuilder<ProviderConfigController>(builder: (providerConfigController) {
      if(providerConfigController.isLoading) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('provider_settings'.tr, style: robotoBold),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          CustomCard(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: const Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
              child: CircularProgressIndicator(),
            )),
          ),
        ]);
      }

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Text('provider_settings'.tr, style: robotoBold),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        CustomCard(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            showInstantBooking ? SwitchButtonWidget(
              title: 'instant_booking'.tr,
              isButtonActive: providerConfigController.isInstantBookingEnabled,
              onTap: () => providerConfigController.toggleInstantBooking(),
            ) : const SizedBox(),
            SizedBox(height: showInstantBooking ? Dimensions.paddingSizeSmall : 0),

            showRepeatBooking ? SwitchButtonWidget(
              title: 'repeat_booking'.tr,
              isButtonActive: providerConfigController.isRepeatBookingEnabled,
              onTap: () => providerConfigController.toggleRepeatBooking(),
            ) : const SizedBox(),
            SizedBox(height: showRepeatBooking ? Dimensions.paddingSizeSmall : 0),

            showScheduleBooking ? SwitchButtonWidget(
              title: 'schedule_booking'.tr,
              isButtonActive: providerConfigController.isScheduleBookingEnabled,
              onTap: () => providerConfigController.toggleScheduleBooking(),
            ) : const SizedBox(),
            SizedBox(height: showBookingTypes ? Dimensions.paddingSizeDefault : 0),

            Text('choose_your_service_location'.tr, style: robotoMedium),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Text('select_service_location_notice'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            _CheckboxOptionsContainer(
              children: serviceLocationOptions.map((option) {
                bool isSelected = providerConfigController.selectedServiceLocations.contains(option['value']);
                bool isOnlyOption = serviceLocationOptions.length == 1 && isSelected;
                return _CheckboxOptionRow(
                  label: option['labelKey']!.tr,
                  isSelected: isSelected,
                  onTap: isOnlyOption ? null : () => providerConfigController.toggleServiceLocation(option['value']!),
                );
              }).toList(),
            ),
            SizedBox(height: showServicemenPermission ? Dimensions.paddingSizeDefault : 0),

            showServicemenPermission ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text('servicemen_permission'.tr, style: robotoMedium),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Text('servicemen_permission_notice'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              _CheckboxOptionsContainer(children: [
                _CheckboxOptionRow(
                  label: 'can_cancel_booking'.tr,
                  isSelected: providerConfigController.isCanCancelBookingEnabled,
                  onTap: () => providerConfigController.toggleCanCancelBooking(),
                ),
              ]),

            ]) : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Row(children: [
              Expanded(child: CustomButtonWidget(
                buttonText: 'reset'.tr,
                color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
                textColor: Theme.of(context).textTheme.bodyLarge?.color,
                onPressed: providerConfigController.isUpdating ? null : () => providerConfigController.resetProviderSettings(),
              )),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Expanded(child: CustomButtonWidget(
                buttonText: 'update'.tr,
                isLoading: providerConfigController.isUpdating,
                onPressed: () => providerConfigController.updateProviderSettings(),
              )),
            ]),

          ]),
        ),

      ]);
    });
  }
}

class _CheckboxOptionsContainer extends StatelessWidget {
  final List<Widget> children;
  const _CheckboxOptionsContainer({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(children: children),
    );
  }
}

class _CheckboxOptionRow extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  const _CheckboxOptionRow({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
        child: Row(children: [
          Checkbox(
            value: isSelected,
            activeColor: Theme.of(context).primaryColor,
            onChanged: onTap == null ? null : (_) => onTap!(),
          ),
          Expanded(child: Text(label, style: robotoRegular)),
        ]),
      ),
    );
  }
}
