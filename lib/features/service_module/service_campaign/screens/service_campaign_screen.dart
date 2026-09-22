import 'package:sixam_mart_store/features/service_module/service_campaign/controllers/service_campaign_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceCampaignScreen extends StatelessWidget {
  const ServiceCampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<ServiceCampaignController>().getCampaignList();

    return const SizedBox();
  }
}
