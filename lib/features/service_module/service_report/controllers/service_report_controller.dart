import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/service_module/service_report/domain/enum/filter_type.dart';
import 'package:sixam_mart_store/features/service_module/service_report/domain/models/service_earning_report_model.dart';
import 'package:sixam_mart_store/features/service_module/service_report/domain/models/service_expense_model.dart';
import 'package:sixam_mart_store/features/service_module/service_report/domain/models/service_tax_report_model.dart';
import 'package:sixam_mart_store/features/service_module/service_report/domain/services/service_report_service_interface.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';

class ServiceReportController extends GetxController implements GetxService {
  final ServiceReportServiceInterface serviceReportServiceInterface;
  ServiceReportController({required this.serviceReportServiceInterface});

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];

  bool _setCustom = false;
  bool get setCustom => _setCustom;

  int _offset = 1;
  int get offset => _offset;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Expense>? _expenses;
  List<Expense>? get expenses => _expenses;

  String _type = 'earning';
  String get type => _type;

  ServiceEarningReportModel? _earningReportModel;
  ServiceEarningReportModel? get getEarningReportModel => _earningReportModel;

  String filterType = FilterType.all.name;

  late DateTimeRange _selectedDateRange;

  String? _from;
  String? get from => _from;

  String? _to;
  String? get to => _to;

  String? _searchText;
  String? get searchText => _searchText;

  bool _searchMode = false;
  bool get searchMode => _searchMode;

  ServiceTaxReportModel? _taxReportModel;
  ServiceTaxReportModel? get taxReportModel => _taxReportModel;

  List<Orders>? _orders;
  List<Orders>? get orders => _orders;

  int? get _storeId => Get.find<ProfileController>().profileModel?.id;
  int? get _moduleId => Get.find<ProfileController>().profileModel?.stores?[0].module?.id;

  void setType(String type) {
    _type = type;
  }

  void setEarningReportModelTransactions({RecentTransactions? value}) {
    _earningReportModel?.recentTransactions = value;
    update();
  }

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

  void initSetDate() {
    _from = DateConverterHelper.dateTimeForCoupon(DateTime.now().subtract(const Duration(days: 2000)));
    _to = DateConverterHelper.dateTimeForCoupon(DateTime.now());
    _searchText = '';
    _setCustom = false;
    filterType = FilterType.all.name;
  }

  void initEarningReportFilter() {
    _from = null;
    _to = null;
    _setCustom = false;
    filterType = FilterType.all.name;
  }

  void initTaxReportDate() {
    _from = DateConverterHelper.dateTimeForTax(DateTime.now().subtract(const Duration(days: 2000)));
    _to = DateConverterHelper.dateTimeForTax(DateTime.now());
    _setCustom = false;
  }

  void setSearchText({required String offset, required String? from, required String? to, required String searchText}) {
    _searchText = searchText;
    _searchMode = !_searchMode;
    getExpenseList(offset: offset.toString(), from: from, to: to, searchText: searchText);
  }

  Future<void> getExpenseList({required String offset, required String? from, required String? to, required String? searchText}) async {

    if (offset == '1') {
      _offsetList = [];
      _offset = 1;
      _expenses = null;
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      ServiceExpenseModel? expenseModel = await serviceReportServiceInterface.getExpenseList(
        offset: int.parse(offset), storeId: _storeId, from: from, to: to, searchText: searchText,
      );
      if (expenseModel != null) {
        if (offset == '1') {
          _expenses = [];
        }
        _expenses!.addAll(expenseModel.expense!);
        _pageSize = expenseModel.totalSize;
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

  Future<void> getEarningReport({required String offset, required String? from, required String? to, required String type, bool onlyTransaction = false}) async {

    if (offset == '1') {
      _offsetList = [];
      _offset = 1;
      _pageSize = null;
      if (!onlyTransaction) {
        _earningReportModel = null;
      } else {
        _earningReportModel?.recentTransactions = null;
      }
      update();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      ServiceEarningReportModel? earningReportModel = await serviceReportServiceInterface.getEarningReport(
        offset: int.parse(offset), storeId: _storeId, moduleId: _moduleId, filter: _filterToken(filterType), from: from, to: to, type: type,
      );
      if (earningReportModel != null) {
        if (getEarningReportModel != null) {
          _earningReportModel!.recentTransactions ??= RecentTransactions(
            earning: Transaction(data: []),
            expense: Transaction(data: []),
            subscription: Transaction(data: []),
          );
          _earningReportModel!.recentTransactions!.earning ??= Transaction(data: []);
          _earningReportModel!.recentTransactions!.earning!.data!.addAll(earningReportModel.recentTransactions?.earning?.data ?? []);
          _earningReportModel!.recentTransactions!.expense ??= Transaction(data: []);
          _earningReportModel!.recentTransactions!.expense!.data!.addAll(earningReportModel.recentTransactions?.expense?.data ?? []);
          _earningReportModel!.recentTransactions!.subscription ??= Transaction(data: []);
          _earningReportModel!.recentTransactions!.subscription!.data!.addAll(earningReportModel.recentTransactions?.subscription?.data ?? []);
          _isLoading = false;
          _pageSize = earningReportModel.totalSize;
        } else {
          _earningReportModel = earningReportModel;
          _isLoading = false;
          _pageSize = earningReportModel.totalSize;
        }
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

  List<Map<String, Object>> getEarningData() {
    return [
      {
        'label': "booking_store_earning",
        'value': getEarningReportModel?.earningBreakdown?.bookingStoreEarning ?? 0.0,
      },
      {
        'label': "tax_amount",
        'value': getEarningReportModel?.earningBreakdown?.taxAmount ?? 0.0,
      },
    ];
  }

  List<Map<String, Object>> getExpenseData() {
    return [
      {
        'label': "booking_commission_paid",
        'value': getEarningReportModel?.expenseBreakdown?.bookingCommission ?? 0.0,
      },
      {
        'label': "subscription_amount",
        'value': getEarningReportModel?.expenseBreakdown?.subscriptionAmount ?? 0.0,
      },
      {
        'label': "discount_on_booking",
        'value': getEarningReportModel?.expenseBreakdown?.discountOnBooking ?? 0.0,
      },
      {
        'label': "coupon_discount",
        'value': getEarningReportModel?.expenseBreakdown?.couponDiscount ?? 0.0,
      },
    ];
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setFilter(String filterText, {bool isTaxReport = false, bool isEarningReport = false}) {
    filterType = filterText;
    update();

    if (isEarningReport) {
      _setCustom = false;
      _from = null;
      _to = null;
      getEarningReport(offset: '1', from: _from, to: _to, type: type);
      return;
    }

    if (filterText == FilterType.all.name) {
      _from = DateConverterHelper.dateTimeForCoupon(DateTime.now().subtract(const Duration(days: 2000)));
      _to = DateConverterHelper.dateTimeForCoupon(DateTime.now());
      _setCustom = false;
    } else if (filterText == FilterType.thisYear.name) {
      _from = DateConverterHelper.dateTimeForCoupon(DateTime.now().subtract(const Duration(days: 365)));
      _to = DateConverterHelper.dateTimeForCoupon(DateTime.now());
      _setCustom = false;
    } else if (filterText == FilterType.previousYear.name) {
      DateTime now = DateTime.now();
      _from = DateConverterHelper.dateTimeForCoupon(DateTime(now.year - 1, 1, 1));
      _to = DateConverterHelper.dateTimeForCoupon(DateTime(now.year - 1, 12, 31));
      _setCustom = false;
    } else if (filterText == FilterType.thisMonth.name) {
      DateTime now = DateTime.now();
      _from = DateConverterHelper.dateTimeForCoupon(DateTime(now.year, now.month, 1));
      _to = DateConverterHelper.dateTimeForCoupon(DateTime.now());
      _setCustom = false;
    } else if (filterText == FilterType.thisWeek.name) {
      DateTime now = DateTime.now();
      int currentWeekday = now.weekday;
      _from = DateConverterHelper.dateTimeForCoupon(now.subtract(Duration(days: currentWeekday - 1)));
      _to = DateConverterHelper.dateTimeForCoupon(DateTime.now());
      _setCustom = false;
    }

    if (isTaxReport) {
      getTaxReport(offset: '1', from: _from, to: _to);
    } else {
      getExpenseList(offset: '1', from: _from, to: _to, searchText: searchText);
    }
  }

  void showDatePicker(BuildContext context, {bool? isTaxReport, bool? isEarningReport}) async {
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

      if (isTaxReport ?? false) {
        _from = DateConverterHelper.dateTimeForTax(_selectedDateRange.start);
        _to = DateConverterHelper.dateTimeForTax(_selectedDateRange.end);
      } else {
        _from = DateConverterHelper.dateTimeForCoupon(_selectedDateRange.start);
        _to = DateConverterHelper.dateTimeForCoupon(_selectedDateRange.end);
      }

      update();

      if (isTaxReport ?? false) {
        getTaxReport(offset: '1', from: _from, to: _to);
      } else if (isEarningReport ?? false) {
        getEarningReport(offset: '1', from: _from, to: _to, type: type);
      } else {
        getExpenseList(offset: '1', from: _from, to: _to, searchText: searchText);
      }
    }
  }

  Future<void> getTaxReport({required String offset, required String? from, required String? to}) async {

    if (offset == '1') {
      _offsetList = [];
      _offset = 1;
      _orders = null;
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      ServiceTaxReportModel? taxReportModel = await serviceReportServiceInterface.getTaxReport(offset: int.parse(offset), from: from, to: to);
      if (taxReportModel != null) {
        if (offset == '1') {
          _orders = [];
        }
        _taxReportModel = taxReportModel;
        _orders!.addAll(taxReportModel.orders!);
        _pageSize = taxReportModel.totalSize;
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
}
