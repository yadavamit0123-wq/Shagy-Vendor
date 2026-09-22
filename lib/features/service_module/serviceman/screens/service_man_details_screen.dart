import 'package:sixam_mart_store/common/widgets/custom_tool_tip_widget.dart';
import 'package:sixam_mart_store/common/widgets/paginated_list_widget.dart';
import 'package:sixam_mart_store/features/service_module/serviceman/controllers/service_man_controller.dart';
import 'package:sixam_mart_store/features/service_module/serviceman/domain/models/service_man_completed_booking_model.dart';
import 'package:sixam_mart_store/features/service_module/serviceman/domain/models/service_man_model.dart';
import 'package:sixam_mart_store/features/service_module/service_report/earinig/widgets/earning_trend_chart.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/service_module/serviceman/widgets/amount_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceManDetailsScreen extends StatefulWidget {
  final ServiceManModel serviceMan;
  const ServiceManDetailsScreen({super.key, required this.serviceMan});

  @override
  State<ServiceManDetailsScreen> createState() => _ServiceManDetailsScreenState();
}

class _ServiceManDetailsScreenState extends State<ServiceManDetailsScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
