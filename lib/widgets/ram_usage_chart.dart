import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:front/constants.dart';
import 'package:front/model/raw_performance_data.dart';

class AnimatedRamUsageChart extends StatefulWidget {
  final Stream<RamPerformanceData> ramUsageStream;

  const AnimatedRamUsageChart({super.key,  required this.ramUsageStream});

  @override
  AnimatedRamUsageChartState createState() => AnimatedRamUsageChartState();
}

class AnimatedRamUsageChartState extends State<AnimatedRamUsageChart> {
  final List<RamPerformanceData> _ramUsageData = [];
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription = widget.ramUsageStream.listen((RamPerformanceData data) {
      setState(() {
        _ramUsageData.add(data);

        // Conserver les N dernières données pour limiter la taille du graphique
        if (_ramUsageData.length > 60) {
          _ramUsageData.removeAt(0);
        }
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_ramUsageData.isEmpty) {
      return const Center(child: SpinKitFoldingCube(color: mainDarkColor));
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: _ramUsageData
                    .asMap()
                    .map((index, data) => MapEntry(index, FlSpot(index.toDouble(), data.ramUsage.toDouble())))
                    .values
                    .toList(),
                colors: [Colors.blue],
                dotData: FlDotData(show: false),
                isCurved: true,
                barWidth: 2,
              ),
            ],
            minX: max(0, _ramUsageData.length.toDouble() - 60),
            maxX: _ramUsageData.length.toDouble() - 1,
            titlesData: FlTitlesData(show: false),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(enabled: false),
          ),
        ),
      ),
    );
  }
}
