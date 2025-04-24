import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  // Define scaffoldKey as a class field
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void showDetectionAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Don't allow dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'DETECTION ALERT!',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bug icon in red glow
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.redAccent.withOpacity(0.9),
                          Colors.red.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        stops: const [0.3, 0.6, 1.0],
                      ),
                    ),
                    child: Image.asset(
                      'assets/icons/app_icon.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close dialog
                      // Navigate to detection result page or show bottom sheet
                    },
                    child: const Text(
                      'Show Detection Result',
                      style: TextStyle(
                        color: Colors.yellowAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Consider desktop/tablet if width is greater than 600
        final bool isDesktop = constraints.maxWidth > 600;

        return Scaffold(
          key: _scaffoldKey,
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
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // Only show hamburger menu on mobile layout
            leading: isDesktop
                ? null
                : IconButton(
                    icon: const Icon(Icons.menu, color: Colors.green),
                    onPressed: () {
                      // Use the GlobalKey to open the drawer
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
          ),
          drawer: isDesktop ? null : _buildDrawer(),
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Show sidebar for desktop layout
                if (isDesktop) _buildSidebar(),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildDashboardContent(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: const Color(0xFF252525),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.green,
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Administrator',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Center(
            child: Text('Farm Management', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ),
          const Divider(color: Colors.grey),
          const SizedBox(height: 10),
          _buildNavItem(Icons.dashboard, 'Dashboard', isSelected: true),
          _buildNavItem(Icons.bug_report, 'Pest Detection'),
          _buildNavItem(Icons.water_drop, 'Irrigation'),
          _buildNavItem(Icons.track_changes, 'Monitoring'),
          _buildNavItem(Icons.history, 'History'),
          _buildNavItem(Icons.settings, 'Settings'),
          const SizedBox(height: 20),
          const Divider(color: Colors.grey),
          _buildNavItem(Icons.logout, 'Logout'),
        ],
      ),
    );
  }


  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF252525),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF1E1E1E),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.person, size: 30, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  'Administrator',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Farm Management',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          _buildNavItem(Icons.dashboard, 'Dashboard', isSelected: true),
          _buildNavItem(Icons.bug_report, 'Pest Detection'),
          _buildNavItem(Icons.water_drop, 'Irrigation'),
          _buildNavItem(Icons.track_changes, 'Monitoring'),
          _buildNavItem(Icons.history, 'History'),
          _buildNavItem(Icons.settings, 'Settings'),
          const Divider(color: Colors.grey),
          _buildNavItem(Icons.logout, 'Logout'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, {bool isSelected = false}) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.green : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.green : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.green.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: () {
        // Navigation logic would go here
      },
    );
  }

  Widget _buildDashboardContent() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Chemigation Level",
                style: TextStyle(fontSize: 16, color: Colors.white)),
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
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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
                Expanded(
                    child: StatCard(
                        title: "Bugs Detected", value: "20", time: "10 min ago")),
                SizedBox(width: 10),
                Expanded(
                    child: StatCard(
                        title: "Humidity", value: "62%", time: "10 min ago")),
              ],
            ),
            const SizedBox(height: 30),
            const Text("Chemigation Trend",
                style: TextStyle(fontSize: 16, color: Colors.white)),
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
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.white),
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
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.white),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
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
          Text(title,
              style: const TextStyle(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
                fontSize: 28, color: Colors.green, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(time,
              style: const TextStyle(color: Colors.white38, fontSize: 12)),
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


