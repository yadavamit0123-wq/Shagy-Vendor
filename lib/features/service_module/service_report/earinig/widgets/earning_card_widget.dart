import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';


class EarningCardWidget extends StatelessWidget {
  final Color cardColor;
  final String icon;
  final Color iconColor;
  final String title;
  final double amount;
  final List<Map<String,dynamic>>? data;
  final String? profitText;
  const EarningCardWidget({super.key, required this.cardColor, required this.icon, required this.iconColor, required this.title, this.data, this.profitText, required this.amount});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
