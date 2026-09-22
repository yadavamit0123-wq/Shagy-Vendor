import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/service_module/order/domain/models/booking_model.dart';
import 'package:sixam_mart_store/features/service_module/service_report/domain/enum/filter_type.dart';
import 'package:sixam_mart_store/features/service_module/service_report/domain/models/service_booking_report_model.dart';
import 'package:sixam_mart_store/features/service_module/service_report/domain/services/service_booking_report_service_interface.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';

class ServiceBookingReportController extends GetxController implements GetxService {
  final ServiceBookingReportServiceInterface serviceBookingReportServiceInterface;
  ServiceBookingReportController({required this.serviceBookingReportServiceInterface});

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];

  int _offset = 1;
  int get offset => _offset;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _setCustom = false;
  bool get setCustom => _setCustom;

  String? _from;
  String? get from => _from;

  String? _to;
  String? get to => _to;

  String? _searchText;
  String? get searchText => _searchText;

  late DateTimeRange _selectedDateRange;

  String filterType = FilterType.all.name;

  BookingReportSummary? _summary;
  BookingReportSummary? get summary => _summary;

  List<BookingModel>? _bookings;
  List<BookingModel>? get bookings => _bookings;

  String _filterToken(String filterText) {
    if (filterText == FilterType.all.name) {
      return 'all_time';
    } else if (filterText == FilterType.thisYear.name) {
      return 'this_year';
    } else if (filterText == FilterType.previousYear.name) {
      return 'previous_year';
    } else if (filterText == FilterType.thisMonth.name) {
      return 'this_month';
    } else if (filterText == FilterType.thisWeek.name) {
      return 'this_week';
    }
    return 'custom';
  }

  void initFilter() {
    _from = null;
    _to = null;
    _searchText = '';
    _setCustom = false;
    filterType = FilterType.all.name;
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  Future<void> getBookingReport({required String offset}) async {

    if (offset == '1') {
      _offsetList = [];
      _offset = 1;
      _pageSize = null;
      _summary = null;
      _bookings = null;
      update();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      ServiceBookingReportModel? bookingReportModel = await serviceBookingReportServiceInterface.getBookingReport(
        offset: int.parse(offset), filter: _filterToken(filterType), from: _from, to: _to, searchText: _searchText,
      );
      if (bookingReportModel != null) {
        if (offset == '1') {
          _bookings = [];
        }
        _summary = bookingReportModel.summary;
        _bookings!.addAll(bookingReportModel.bookings ?? []);
        _pageSize = bookingReportModel.totalSize;
        _isLoading = false;
        update();
      } else {
        _isLoading = false;
        update();
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void setFilter(String filterText) {
    filterType = filterText;
    _setCustom = false;
    _from = null;
    _to = null;
    update();

    getBookingReport(offset: '1');
  }

  void showDatePicker(BuildContext context) async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      saveText: 'done'.tr,
      confirmText: 'done'.tr,
      cancelText: 'cancel'.tr,
      fieldStartLabelText: 'start_date'.tr,
      fieldEndLabelText: 'end_date'.tr,
      errorInvalidRangeText: 'select_range'.tr,
    );

    if (result != null) {
      _selectedDateRange = result;
      _setCustom = true;
      filterType = FilterType.custom.name;
      _from = DateConverterHelper.dateTimeForCoupon(_selectedDateRange.start);
      _to = DateConverterHelper.dateTimeForCoupon(_selectedDateRange.end);
      update();

      getBookingReport(offset: '1');
    }
  }
}
