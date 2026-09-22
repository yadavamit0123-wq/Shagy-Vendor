import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/text_field_widget.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/controllers/custom_service_controller.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/domain/models/custom_service_request_model.dart';
import 'package:sixam_mart_store/features/service_module/custom_service/widgets/custom_service_request_header_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class CustomServiceOfferScreen extends StatefulWidget {
  final int requestId;
  final CustomServiceBidModel? existingBid;
  const CustomServiceOfferScreen({super.key, required this.requestId, this.existingBid});

  @override
  State<CustomServiceOfferScreen> createState() => _CustomServiceOfferScreenState();
}

class _CustomServiceOfferScreenState extends State<CustomServiceOfferScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
