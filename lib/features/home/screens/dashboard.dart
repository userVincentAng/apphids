import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.bug_report, color: Colors.green),
            SizedBox(width: 10),
            Text(
              'APP-HIDS',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Chemigation Level", style: TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 10),
              SfRadialGauge(
                axes: [
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    showLabels: false,
                    showTicks: false,
                    axisLineStyle: AxisLineStyle(
                      thickness: 0.2,
                      cornerStyle: CornerStyle.bothFlat,
                      color: Colors.grey[800],
                      thicknessUnit: GaugeSizeUnit.factor,
                    ),
                    pointers: const [
                      RangePointer(
                        value: 65,
                        width: 0.2,
                        color: Colors.green,
                        cornerStyle: CornerStyle.bothCurve,
                        sizeUnit: GaugeSizeUnit.factor,
                      )
                    ],
                    annotations: const [
                      GaugeAnnotation(
                        widget: Text(
                          '65.00',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        angle: 90,
                        positionFactor: 0.1,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: StatCard(title: "Bugs Detected", value: "20", time: "10 min ago")),
                  SizedBox(width: 10),
                  Expanded(child: StatCard(title: "Humidity", value: "62%", time: "10 min ago")),
                ],
              ),
              const SizedBox(height: 30),
              const Text("Chemigation Trend", style: TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 10),
              SizedBox(
                height: 220,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: LineChart(
                    LineChartData(
                      minY: 50,
                      maxY: 90,
                      backgroundColor: const Color(0xFF1E1E1E),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 10,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            interval: 1,
                            getTitlesWidget: (value, _) {
                              final labels = {
                                0: 'Apr 1',
                                1: 'Apr 5',
                                2: 'Apr 10',
                                3: 'Apr 15',
                                4: 'Apr 20',
                                5: 'Apr 25',
                                6: 'Apr 30',
                              };
                              return Text(
                                labels[value.toInt()] ?? '',
                                style: const TextStyle(fontSize: 10, color: Colors.white),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 10,
                            reservedSize: 30,
                            getTitlesWidget: (value, _) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10, color: Colors.white),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 70),
                            FlSpot(1, 72),
                            FlSpot(2, 74),
                            FlSpot(3, 76),
                            FlSpot(4, 74),
                            FlSpot(5, 72),
                            FlSpot(6, 70),
                          ],
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "APHIDS DETECTED",
                style: TextStyle(
                  color: Color(0xFFB5FF70),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2E2E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(child: TableText("Date", bold: true)),
                        Expanded(child: TableText("No. Aphids", bold: true)),
                        Expanded(child: TableText("Status", bold: true)),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    ...List.generate(
                      3,
                          (index) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(child: TableText("Mar 1")),
                            Expanded(child: TableText("20")),
                            Expanded(child: TableText("Mild")),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String time;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 28, color: Colors.green, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(time, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }
}

class TableText extends StatelessWidget {
  final String text;
  final bool bold;

  const TableText(this.text, {this.bold = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: bold ? const Color(0xFFB5FF70) : Colors.white,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontSize: 14,
      ),
    );
  }
}
