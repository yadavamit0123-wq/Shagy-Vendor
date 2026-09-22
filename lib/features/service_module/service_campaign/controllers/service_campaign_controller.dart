import 'package:sixam_mart_store/features/service_module/service_campaign/domain/models/service_campaign_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/service_module/service_campaign/domain/services/service_campaign_service_interface.dart';

class ServiceCampaignController extends GetxController implements GetxService {
  final ServiceCampaignServiceInterface serviceCampaignServiceInterface;
  ServiceCampaignController({required this.serviceCampaignServiceInterface});

  List<ServiceCampaignModel>? _campaignList;
  List<ServiceCampaignModel>? get campaignList => _campaignList;

  late List<ServiceCampaignModel> _allCampaignList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getCampaignList() async {
    List<ServiceCampaignModel>? campaignList = await serviceCampaignServiceInterface.getCampaignList();
    if(campaignList != null) {
      _campaignList = [];
      _allCampaignList = [];
      _campaignList!.addAll(campaignList);
      _allCampaignList.addAll(campaignList);
    }
    update();
  }

  void filterCampaign(String status) {
    _campaignList = serviceCampaignServiceInterface.filterCampaign(status, _allCampaignList);
    update();
  }

  Future<void> joinCampaign(int? campaignID, bool fromDetails) async {
    _isLoading = true;
    update();
    bool isSuccess = await serviceCampaignServiceInterface.joinCampaign(campaignID);
    Get.back();
    if(isSuccess) {
      if(fromDetails) {
        Get.back();
      }
      showCustomSnackBar('successfully_joined'.tr, isError: false);
      getCampaignList();
    }
    _isLoading = false;
    update();
  }

  Future<void> leaveCampaign(int? campaignID, bool fromDetails) async {
    _isLoading = true;
    update();
    bool isSuccess = await serviceCampaignServiceInterface.leaveCampaign(campaignID);
    Get.back();
    if(isSuccess) {
      if(fromDetails) {
        Get.back();
      }
      showCustomSnackBar('successfully_leave'.tr, isError: false);
      getCampaignList();
    }
    _isLoading = false;
    update();
  }

}
