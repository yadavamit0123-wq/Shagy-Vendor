import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final int index;
  final String month;
  final double value;
  const ChartData(this.index, this.month, this.value);
}

class TrendChart extends StatefulWidget {
  final List<ChartData> data;
  const TrendChart({super.key, required this.data});

  @override
  State<TrendChart> createState() => _ChartDemoState();
}

class _ChartDemoState extends State<TrendChart> {

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
