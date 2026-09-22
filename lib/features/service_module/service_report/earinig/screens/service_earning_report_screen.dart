import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/features/service_module/service_report/controllers/service_report_controller.dart';
import 'package:sixam_mart_store/features/service_module/service_report/domain/enum/filter_type.dart';
import 'package:sixam_mart_store/features/service_module/service_report/domain/models/service_earning_report_model.dart';
import 'package:sixam_mart_store/features/service_module/service_report/earinig/widgets/earning_card_widget.dart';
import 'package:sixam_mart_store/features/service_module/service_report/earinig/widgets/earning_sources_bottom_sheet.dart';
import 'package:sixam_mart_store/features/service_module/service_report/earinig/widgets/earning_trend_chart.dart';
import 'package:sixam_mart_store/features/service_module/service_report/earinig/widgets/transaction_menu_button_widget.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';


class ServiceEarningReportScreen extends StatefulWidget {
  const ServiceEarningReportScreen({super.key});

  @override
  State<ServiceEarningReportScreen> createState() => _ServiceEarningReportScreenState();
}

class _ServiceEarningReportScreenState extends State<ServiceEarningReportScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
