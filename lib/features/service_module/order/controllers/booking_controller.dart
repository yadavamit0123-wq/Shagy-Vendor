import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_cancellation_body_model.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/service_module/order/domain/models/assignable_service_man_model.dart';
import 'package:sixam_mart_store/features/service_module/order/domain/models/booking_details_model.dart';
import 'package:sixam_mart_store/features/service_module/order/domain/models/booking_model.dart';
import 'package:sixam_mart_store/features/service_module/order/domain/models/running_booking_model.dart';
import 'package:sixam_mart_store/features/service_module/order/domain/services/booking_service_interface.dart';

class BookingController extends GetxController implements GetxService {
  final BookingServiceInterface bookingServiceInterface;
  BookingController({required this.bookingServiceInterface});

  static const int _runningLimit = 50;

  final List<String> runningStatusList = ['pending', 'confirmed', 'ongoing'];
  final List<String> historyStatusList = ['all', 'completed', 'canceled'];

  int _runningIndex = 0;
  int get runningIndex => _runningIndex;
  void setRunningIndex(int index) {
    _runningIndex = index;
    update();
  }

  int _historyIndex = 0;
  int get historyIndex => _historyIndex;
  void setHistoryIndex(int index) {
    _historyIndex = index;
    getPaginatedBookings(1, true);
  }

  List<RunningBookingModel>? _runningBookings;
  List<RunningBookingModel>? get runningBookings => _runningBookings;

  bool _isRunningBookingLoading = false;
  bool get isRunningBookingLoading => _isRunningBookingLoading;

  bool _campaignOnly = false;
  bool get campaignOnly => _campaignOnly;
  void toggleCampaignOnly() {
    _campaignOnly = !_campaignOnly;
    update();
  }

  List<BookingModel> getFilteredBookingList(List<BookingModel> bookingList) {
    return _campaignOnly ? bookingList.where((booking) => booking.isCampaign == true).toList() : bookingList;
  }

  Future<void> getRunningBookings() async {
    _isRunningBookingLoading = true;
    _runningBookings = runningStatusList.map((status) => RunningBookingModel(status: status, bookingList: [])).toList();
    update();

    for (int i = 0; i < runningStatusList.length; i++) {
      BookingListModel? model = await bookingServiceInterface.getBookingList(
        limit: _runningLimit, offset: 1, status: runningStatusList[i],
      );
      if (model != null) {
        _runningBookings![i].bookingList = model.bookings ?? [];
        _runningBookings![i].totalSize = model.totalSize;
      }
      update();
    }

    _isRunningBookingLoading = false;
    update();
  }

  List<BookingModel>? _historyBookingList;
  List<BookingModel>? get historyBookingList => _historyBookingList;
  int? _historyTotalSize;
  int? get historyTotalSize => _historyTotalSize;
  final List<int> _historyOffsetList = [];
  int _historyOffset = 1;
  int get historyOffset => _historyOffset;
  bool _paginate = false;
  bool get paginate => _paginate;

  bool _isHistoryBookingLoading = false;
  bool get isHistoryBookingLoading => _isHistoryBookingLoading;

  Future<void> getPaginatedBookings(int offset, bool reload) async {
    if (offset == 1) {
      _historyOffsetList.clear();
      _historyOffset = 1;
      if (reload) {
        _historyBookingList = null;
        _isHistoryBookingLoading = true;
      }
      update();
    }

    if (!_historyOffsetList.contains(offset)) {
      _historyOffsetList.add(offset);
      BookingListModel? model = await bookingServiceInterface.getBookingList(
        limit: 10, offset: offset, status: historyStatusList[_historyIndex],
      );
      if (model != null) {
        if (offset == 1) {
          _historyBookingList = [];
        }
        _historyBookingList!.addAll(model.bookings ?? []);
        _historyTotalSize = model.totalSize;
        _historyOffset = offset;
      }
      _paginate = false;
      _isHistoryBookingLoading = false;
      update();
    } else if (_paginate) {
      _paginate = false;
      update();
    }
  }

  void showBottomLoader() {
    _paginate = true;
    update();
  }

  BookingDetailsModel? _bookingDetailsModel;
  BookingDetailsModel? get bookingDetailsModel => _bookingDetailsModel;

  Future<void> getBookingDetails(int id, {bool reload = true}) async {
    if (reload) {
      _bookingDetailsModel = null;
      update();
    }
    _bookingDetailsModel = await bookingServiceInterface.getBookingDetails(id);
    update();
  }

  void clearBookingDetails() {
    _bookingDetailsModel = null;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _cancelReason = '';
  String? get cancelReason => _cancelReason;
  void setBookingCancelReason(String? reason) {
    _cancelReason = reason;
    update();
  }

  List<Data>? _bookingCancelReasons;
  List<Data>? get bookingCancelReasons => _bookingCancelReasons;

  Future<void> getBookingCancelReasons() async {
    OrderCancellationBodyModel? cancellationBody = await bookingServiceInterface.getCancelReasons();
    if (cancellationBody != null) {
      _bookingCancelReasons = [];
      for (var element in cancellationBody.data ?? []) {
        _bookingCancelReasons!.add(element);
      }
    }
    update();
  }

  List<XFile> _completionEvidenceImages = [];
  List<XFile> get completionEvidenceImages => _completionEvidenceImages;

  Future<void> pickCompletionEvidenceImage() async {
    if (_completionEvidenceImages.length >= 5) {
      showCustomSnackBar('you_can_upload_a_maximum_of_5_photos'.tr);
      return;
    }
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      _completionEvidenceImages.add(image);
      update();
    }
  }

  void removeCompletionEvidenceImage(int index) {
    _completionEvidenceImages.removeAt(index);
    update();
  }

  void clearCompletionEvidenceImages() {
    _completionEvidenceImages = [];
    update();
  }

  Future<bool> updateBookingStatus(int bookingId, String status, {String? cancellationReason, String? otp, bool back = false}) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await bookingServiceInterface.updateBookingStatus(
      bookingId, status, cancellationReason: cancellationReason, otp: otp, evidenceImages: _completionEvidenceImages,
    );
    if (Get.isDialogOpen == true) {
      Get.back(result: responseModel.isSuccess);
    }
    if (responseModel.isSuccess) {
      if (back) {
        Get.back();
      }
      _completionEvidenceImages = [];
      await getBookingDetails(bookingId, reload: false);
      getRunningBookings();
      Get.find<ProfileController>().getProfile();
      showCustomSnackBar(responseModel.message, isError: false);
    } else {
      showCustomSnackBar(responseModel.message, isError: true);
    }
    _isLoading = false;
    update();
    return responseModel.isSuccess;
  }

  List<AssignableServiceManModel>? _assignableServicemen;
  List<AssignableServiceManModel>? get assignableServicemen => _assignableServicemen;

  void resetAssignableServicemen() {
    _assignableServicemen = null;
  }

  bool _isAssignSubmitLoading = false;
  bool get isAssignSubmitLoading => _isAssignSubmitLoading;

  Future<void> getAssignableServicemen(int bookingId, {String? search}) async {
    _assignableServicemen = null;
    update();
    _assignableServicemen = await bookingServiceInterface.getAssignableServicemen(bookingId, search: search);
    update();
  }

  Future<bool> assignServicemenToBooking(int bookingId, List<int> servicemanIds) async {
    _isAssignSubmitLoading = true;
    update();
    ResponseModel responseModel = await bookingServiceInterface.assignServicemen(bookingId, servicemanIds);
    if (responseModel.isSuccess) {
      await getBookingDetails(bookingId, reload: false);
      showCustomSnackBar(responseModel.message, isError: false);
    } else {
      showCustomSnackBar(responseModel.message, isError: true);
    }
    _isAssignSubmitLoading = false;
    update();
    return responseModel.isSuccess;
  }

  bool _isServiceLocationLoading = false;
  bool get isServiceLocationLoading => _isServiceLocationLoading;

  Future<bool> updateServiceLocation(int bookingId, String serviceLocationStatus) async {
    _isServiceLocationLoading = true;
    update();
    ResponseModel responseModel = await bookingServiceInterface.updateServiceLocation(bookingId, serviceLocationStatus);
    if (responseModel.isSuccess) {
      await getBookingDetails(bookingId, reload: false);
      showCustomSnackBar(responseModel.message, isError: false);
    } else {
      showCustomSnackBar(responseModel.message, isError: true);
    }
    _isServiceLocationLoading = false;
    update();
    return responseModel.isSuccess;
  }

  bool _isRescheduleLoading = false;
  bool get isRescheduleLoading => _isRescheduleLoading;

  Future<bool> rescheduleBooking(int bookingId, DateTime scheduleAt) async {
    _isRescheduleLoading = true;
    update();
    String formattedScheduleAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(scheduleAt);
    ResponseModel responseModel = await bookingServiceInterface.rescheduleBooking(bookingId, formattedScheduleAt);
    if (responseModel.isSuccess) {
      await getBookingDetails(bookingId, reload: false);
      showCustomSnackBar(responseModel.message, isError: false);
    } else {
      showCustomSnackBar(responseModel.message, isError: true);
    }
    _isRescheduleLoading = false;
    update();
    return responseModel.isSuccess;
  }

  bool _isInvoiceLoading = false;
  bool get isInvoiceLoading => _isInvoiceLoading;

  Future<void> downloadBookingInvoice(int bookingId) async {
    if (_isInvoiceLoading) return;
    _isInvoiceLoading = true;
    update();

    final List<int>? bytes = await bookingServiceInterface.getBookingInvoice(bookingId);
    if (bytes != null && bytes.isNotEmpty) {
      try {
        final Directory dir = await getTemporaryDirectory();
        final String path = '${dir.path}/ServiceBooking-Invoice-$bookingId.pdf';
        await File(path).writeAsBytes(bytes, flush: true);
        final OpenResult result = await OpenFilex.open(path, type: 'application/pdf');
        if (result.type != ResultType.done) {
          showCustomSnackBar('unable_to_open_invoice'.tr);
        }
      } catch (_) {
        showCustomSnackBar('unable_to_open_invoice'.tr);
      }
    } else {
      showCustomSnackBar('invoice_not_found'.tr);
    }

    _isInvoiceLoading = false;
    update();
  }
}
