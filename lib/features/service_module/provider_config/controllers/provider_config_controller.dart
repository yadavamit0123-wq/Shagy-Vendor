import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/service_module/provider_config/domain/models/store_setup_model.dart';
import 'package:sixam_mart_store/features/service_module/provider_config/domain/services/provider_config_service_interface.dart';
import 'package:get/get.dart';

class ProviderConfigController extends GetxController {
  final ProviderConfigServiceInterface providerConfigServiceInterface;
  ProviderConfigController({required this.providerConfigServiceInterface});

  static const List<Map<String, String>> serviceLocationOptions = [
    {'value': 'customer', 'labelKey': 'go_to_customer_location'},
    {'value': 'provider', 'labelKey': 'customer_will_come_to_my_location'},
  ];

  StoreSetupModel? _storeSetup;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  List<String> _selectedServiceLocations = [];
  List<String> get selectedServiceLocations => _selectedServiceLocations;

  bool _isInstantBookingEnabled = false;
  bool get isInstantBookingEnabled => _isInstantBookingEnabled;

  bool _isRepeatBookingEnabled = false;
  bool get isRepeatBookingEnabled => _isRepeatBookingEnabled;

  bool _isScheduleBookingEnabled = false;
  bool get isScheduleBookingEnabled => _isScheduleBookingEnabled;

  bool _isCanCancelBookingEnabled = false;
  bool get isCanCancelBookingEnabled => _isCanCancelBookingEnabled;

  Future<void> getStoreSetup() async {
    _isLoading = true;
    update();
    StoreSetupModel? model = await providerConfigServiceInterface.getStoreSetup();
    if (model != null) {
      _applyStoreSetup(model);
    }
    _isLoading = false;
    update();
  }

  void _applyStoreSetup(StoreSetupModel model) {
    _storeSetup = model;
    _isInstantBookingEnabled = model.bookingTypes?.instantBooking ?? false;
    _isRepeatBookingEnabled = model.bookingTypes?.repeatBooking ?? false;
    _isScheduleBookingEnabled = model.bookingTypes?.scheduleBooking ?? false;
    _selectedServiceLocations = List.from(model.serviceLocation?.chooseServiceLocation ?? ['customer']);
    _isCanCancelBookingEnabled = model.servicemanPermission?.servicemanCanCancelBooking ?? false;
  }

  void toggleServiceLocation(String value) {
    if(_selectedServiceLocations.contains(value)) {
      if(_selectedServiceLocations.length > 1) {
        _selectedServiceLocations = List.from(_selectedServiceLocations)..remove(value);
      } else {
        showCustomSnackBar('at_least_one_service_location_required'.tr);
        return;
      }
    } else {
      _selectedServiceLocations = List.from(_selectedServiceLocations)..add(value);
    }
    update();
  }

  void toggleInstantBooking() {
    if(_isInstantBookingEnabled && !_isScheduleBookingEnabled) {
      showCustomSnackBar('at_least_one_booking_type_required'.tr);
      return;
    }
    _isInstantBookingEnabled = !_isInstantBookingEnabled;
    update();
  }

  void toggleRepeatBooking() {
    _isRepeatBookingEnabled = !_isRepeatBookingEnabled;
    update();
  }

  void toggleScheduleBooking() {
    if(_isScheduleBookingEnabled && !_isInstantBookingEnabled) {
      showCustomSnackBar('at_least_one_booking_type_required'.tr);
      return;
    }
    _isScheduleBookingEnabled = !_isScheduleBookingEnabled;
    update();
  }

  void toggleCanCancelBooking() {
    _isCanCancelBookingEnabled = !_isCanCancelBookingEnabled;
    update();
  }

  void resetProviderSettings() {
    if(_storeSetup != null) {
      _applyStoreSetup(_storeSetup!);
      update();
      showCustomSnackBar('reset_successful'.tr, isError: false);
    }
  }

  Future<void> updateProviderSettings() async {
    _isUpdating = true;
    update();

    Map<String, dynamic> body = {
      'instant_booking': _isInstantBookingEnabled,
      'repeat_booking': _isRepeatBookingEnabled,
      'schedule_booking': _isScheduleBookingEnabled,
      'choose_service_location': _selectedServiceLocations,
      'serviceman_can_cancel_booking': _isCanCancelBookingEnabled,
    };

    final responseModel = await providerConfigServiceInterface.updateStoreSetup(body);
    if(responseModel.isSuccess) {
      await getStoreSetup();
      showCustomSnackBar(responseModel.message ?? 'business_setup_updated_successfully'.tr, isError: false);
    } else {
      showCustomSnackBar(responseModel.message ?? 'something_went_wrong'.tr);
    }

    _isUpdating = false;
    update();
  }
}
