import 'package:get/get.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/domain/models/custom_service_request_model.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/domain/models/provider_offer_model.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/domain/services/custom_service_service_interface.dart';

class CustomServiceController extends GetxController implements GetxService {
  final CustomServiceServiceInterface customServiceServiceInterface;
  CustomServiceController({required this.customServiceServiceInterface});

  static const String typeNew = 'new';
  static const String typeMyBids = 'my-bids';

  List<CustomServiceRequestModel>? _newRequests;
  List<CustomServiceRequestModel>? get newRequests => _newRequests;
  int? _newRequestsTotalSize;
  int? get newRequestsTotalSize => _newRequestsTotalSize;
  List<String> _newRequestsOffsetList = [];
  int _newRequestsOffset = 1;
  int get newRequestsOffset => _newRequestsOffset;

  List<CustomServiceRequestModel>? _myBids;
  List<CustomServiceRequestModel>? get myBids => _myBids;
  int? _myBidsTotalSize;
  int? get myBidsTotalSize => _myBidsTotalSize;
  List<String> _myBidsOffsetList = [];
  int _myBidsOffset = 1;
  int get myBidsOffset => _myBidsOffset;

  CustomServiceRequestDetailsModel? _requestDetails;
  CustomServiceRequestDetailsModel? get requestDetails => _requestDetails;

  List<ProviderOfferModel>? _otherBids;
  List<ProviderOfferModel>? get otherBids => _otherBids;
  int? _otherBidsTotalSize;
  int? get otherBidsTotalSize => _otherBidsTotalSize;
  List<String> _otherBidsOffsetList = [];
  int _otherBidsOffset = 1;
  int get otherBidsOffset => _otherBidsOffset;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  Future<void> getRequestList({required String type, required String offset}) async {
    if (offset == '1') {
      if (type == typeNew) {
        _newRequestsOffsetList = [];
        _newRequestsOffset = 1;
        _newRequests = null;
      } else {
        _myBidsOffsetList = [];
        _myBidsOffset = 1;
        _myBids = null;
      }
      update();
    }

    List<String> offsetList = type == typeNew ? _newRequestsOffsetList : _myBidsOffsetList;
    if (!offsetList.contains(offset)) {
      offsetList.add(offset);
      CustomServiceRequestListModel? model = await customServiceServiceInterface.getRequestList(type: type, offset: offset);
      if (model != null) {
        if (type == typeNew) {
          if (offset == '1') { _newRequests = []; }
          _newRequests!.addAll(model.data ?? []);
          _newRequestsTotalSize = model.totalSize;
          _newRequestsOffset = int.parse(offset) + 1;
        } else {
          if (offset == '1') { _myBids = []; }
          _myBids!.addAll(model.data ?? []);
          _myBidsTotalSize = model.totalSize;
          _myBidsOffset = int.parse(offset) + 1;
        }
      }
      update();
    }
  }

  Future<void> getRequestDetails(int id, {bool reload = true}) async {
    if (reload) {
      _requestDetails = null;
      update();
    }
    _requestDetails = await customServiceServiceInterface.getRequestDetails(id);
    update();
  }

  Future<void> getOtherBids(int requestId, {required String offset}) async {
    if (offset == '1') {
      _otherBidsOffsetList = [];
      _otherBidsOffset = 1;
      _otherBids = null;
      update();
    }

    if (!_otherBidsOffsetList.contains(offset)) {
      _otherBidsOffsetList.add(offset);
      ProviderOfferListModel? model = await customServiceServiceInterface.getOtherBids(requestId, offset: offset);
      if (model != null) {
        if (offset == '1') { _otherBids = []; }
        _otherBids!.addAll(model.data ?? []);
        _otherBidsTotalSize = model.totalSize;
        _otherBidsOffset = int.parse(offset) + 1;
      }
      update();
    }
  }

  Future<ResponseModel> submitBid(int requestId, double offerPrice, String? note) async {
    _isActionLoading = true;
    update();
    ResponseModel responseModel = await customServiceServiceInterface.submitBid(requestId, offerPrice, note);
    if (responseModel.isSuccess) {
      await getRequestDetails(requestId, reload: false);
    }
    _isActionLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> withdrawBid(int bidId, {required int requestId}) async {
    _isActionLoading = true;
    update();
    ResponseModel responseModel = await customServiceServiceInterface.withdrawBid(bidId);
    if (responseModel.isSuccess) {
      await getRequestDetails(requestId, reload: false);
    }
    _isActionLoading = false;
    update();
    return responseModel;
  }

  void removeNewRequestLocally(int id) {
    _newRequests?.removeWhere((request) => request.id == id);
    update();
  }
}
