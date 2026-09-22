import 'dart:async';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/service_module/booking_edit/domain/models/booking_edit_catalog_model.dart';
import 'package:sixam_mart_store/features/service_module/booking_edit/domain/models/booking_edit_preview_model.dart';
import 'package:sixam_mart_store/features/service_module/booking_edit/domain/models/booking_edit_working_line_model.dart';
import 'package:sixam_mart_store/features/service_module/booking_edit/domain/services/booking_edit_service_interface.dart';
import 'package:sixam_mart_store/features/service_module/order/controllers/booking_controller.dart';

class BookingEditController extends GetxController implements GetxService {
  final BookingEditServiceInterface bookingEditServiceInterface;
  BookingEditController({required this.bookingEditServiceInterface});

  int? _bookingId;

  bool? _isEditable;
  bool? get isEditable => _isEditable;

  String? _reason;
  String? get reason => _reason;

  List<BookingEditCatalogService>? _catalog;
  List<BookingEditCatalogService>? get catalog => _catalog;

  List<BookingEditWorkingLine>? _workingLines;
  List<BookingEditWorkingLine>? get workingLines => _workingLines;

  BookingEditPreviewModel? _preview;
  BookingEditPreviewModel? get preview => _preview;

  String? _previewError;
  String? get previewError => _previewError;

  bool _isCatalogLoading = false;
  bool get isCatalogLoading => _isCatalogLoading;

  bool _isPreviewLoading = false;
  bool get isPreviewLoading => _isPreviewLoading;

  bool _isUpdateLoading = false;
  bool get isUpdateLoading => _isUpdateLoading;

  Timer? _previewDebounce;

  Future<bool> initializeFromCatalog(int bookingId) async {
    _bookingId = bookingId;
    _isCatalogLoading = true;
    _preview = null;
    _previewError = null;
    update();

    BookingEditCatalogResponseModel? response = await bookingEditServiceInterface.getEditCatalog(bookingId);

    if (response == null) {
      _isEditable = false;
      _reason = 'this_booking_can_not_be_edited'.tr;
      _catalog = null;
      _workingLines = null;
      _isCatalogLoading = false;
      update();
      return false;
    }

    _isEditable = response.isEditable ?? false;
    _reason = response.reason;
    _catalog = response.catalog ?? [];
    _workingLines = bookingEditServiceInterface.prepareWorkingList(response.lines);
    _isCatalogLoading = false;
    update();

    if (_isEditable == true) {
      await refreshPreview();
    }
    return _isEditable ?? false;
  }

  int? findMatchingLineIndex(int serviceId, String? variantKey) {
    return bookingEditServiceInterface.findMatchingLineIndex(_workingLines ?? [], serviceId, variantKey);
  }

  void addCatalogEntry(BookingEditCatalogService service, {BookingEditCatalogVariant? variant, int quantity = 1}) {
    _workingLines ??= [];
    int? matchIndex = bookingEditServiceInterface.findMatchingLineIndex(_workingLines!, service.id ?? 0, variant?.key);
    if (matchIndex != null) {
      _workingLines![matchIndex].quantity += quantity;
    } else {
      _workingLines!.add(bookingEditServiceInterface.buildLineFromCatalogEntry(service, variant: variant, quantity: quantity));
    }
    update();
    refreshPreview(debounce: true);
  }

  void updateWorkingLine(int index, {String? variantKey, String? variantName, double? unitPrice, double? grossPrice, double? discount, required int quantity}) {
    if (_workingLines == null || index < 0 || index >= _workingLines!.length) return;
    final BookingEditWorkingLine line = _workingLines![index];
    line.variantKey = variantKey;
    line.variantName = variantName;
    if (unitPrice != null) line.unitPrice = unitPrice;
    line.grossPrice = grossPrice;
    line.discount = discount;
    line.quantity = quantity;
    update();
    refreshPreview(debounce: true);
  }

  void increaseLine(int index) {
    if (_workingLines == null || index >= _workingLines!.length || _workingLines![index].missing) return;
    _workingLines![index].quantity += 1;
    update();
    refreshPreview(debounce: true);
  }

  void decreaseLine(int index) {
    if (_workingLines == null || index >= _workingLines!.length || _workingLines![index].missing) return;
    if (_workingLines![index].quantity > 1) {
      _workingLines![index].quantity -= 1;
      update();
      refreshPreview(debounce: true);
    }
  }

  bool removeLine(int index) {
    if (_workingLines == null || index >= _workingLines!.length) return false;
    if (_workingLines!.length <= 1) return false;
    _workingLines!.removeAt(index);
    update();
    refreshPreview(debounce: true);
    return true;
  }

  Future<void> refreshPreview({bool debounce = false}) async {

  }

  Future<bool> submitUpdate() async {
    if (_bookingId == null || _workingLines == null || _workingLines!.isEmpty) {
      showCustomSnackBar('booking_must_contain_at_least_one_service'.tr);
      return false;
    }
    for (final line in _workingLines!) {
      if (line.quantity < 1) {
        showCustomSnackBar('quantity_can_not_be_0'.tr);
        return false;
      }
    }

    _isUpdateLoading = true;
    update();

    final body = bookingEditServiceInterface.buildEditBody(_workingLines!).toJson();
    ResponseModel responseModel = await bookingEditServiceInterface.updateEdit(_bookingId!, body);
    _isUpdateLoading = false;
    update();
    return responseModel.isSuccess;
  }
}
