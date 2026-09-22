import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/service_module/service_report/controllers/service_report_controller.dart';
import 'package:sixam_mart_store/features/service_module/service_report/domain/models/service_earning_report_model.dart';
import 'package:sixam_mart_store/features/service_module/service_report/earinig/screens/service_earning_report_screen.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';


class EarningSourcesBottomSheet extends StatelessWidget {
  final int index;
  EarningSourcesBottomSheet({super.key, required this.index});
  final ServiceReportController serviceReportController = Get.find<ServiceReportController>();

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
