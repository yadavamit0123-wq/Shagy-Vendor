import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/service_module/service_report/controllers/service_disbursement_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/service_module/service_report/domain/models/service_disbursement_report_model.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/service_module/service_report/disbursement/widgets/service_disbursement_status_card_widget.dart';
import 'package:sixam_mart_store/features/service_module/service_report/disbursement/widgets/payment_information_dialog_widget.dart';

class ServiceDisbursementScreen extends StatefulWidget {
  const ServiceDisbursementScreen({super.key});

  @override
  State<ServiceDisbursementScreen> createState() => _ServiceDisbursementScreenState();
}

class _ServiceDisbursementScreenState extends State<ServiceDisbursementScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
