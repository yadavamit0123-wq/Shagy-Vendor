import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/controllers/custom_service_controller.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/screens/custom_service_offer_screen.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/widgets/custom_service_request_header_widget.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/widgets/other_provider_offer_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/widgets/shimmer/custom_service_request_details_shimmer_widget.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class CustomServiceRequestDetailsScreen extends StatefulWidget {
  final int requestId;
  const CustomServiceRequestDetailsScreen({super.key, required this.requestId});

  @override
  State<CustomServiceRequestDetailsScreen> createState() => _CustomServiceRequestDetailsScreenState();
}

class _CustomServiceRequestDetailsScreenState extends State<CustomServiceRequestDetailsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return const SizedBox();
  }

}
