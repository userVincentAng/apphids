// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../services/database_service.dart';
import '../../../features/data/models/detection_model.dart';
import '../../../features/data/models/chemigation_model.dart';
import '../../../features/data/models/moisture_model.dart';
import '../../../features/detection/screens/full_screen_alert.dart';
import '../../../features/data/screens/apphid_data.dart';
import '../widgets/stat_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseService _databaseService = DatabaseService();
  List<DetectionModel> _detections = [];
  List<ChemigationLevel> _chemigationLevels = [];
  MoistureLevel? _latestMoistureLevel;
  bool _isLoading = true;
  String _error = '';
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _loadDetectionData();
    _loadChemigationData();
    _loadMoistureData();
    _updateCurrentTime();
  }

  void _updateCurrentTime() {
    if (!mounted) return;
    setState(() {
      _currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
    });
    // Update time every second
    Future.delayed(const Duration(seconds: 1), _updateCurrentTime);
  }

  void _showFullScreenAlert(List<Map<String, dynamic>> alerts) {
    if (mounted) {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) {
            final totalAphids = alerts.fold<int>(
              0,
              (sum, alert) => sum + (alert['count'] as int),
            );

            return FullScreenAlert(
              aphidCount: totalAphids,
              onShowDetails: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AphidTableScreen(),
                  ),
                );
              },
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  Future<void> _loadDetectionData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final detections = await _databaseService.getDetectionData();
      final severeAlerts = await _databaseService.getSevereAlerts();

      if (severeAlerts.isNotEmpty && mounted) {
        _showFullScreenAlert(severeAlerts);
      }

      setState(() {
        _detections = detections;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadChemigationData() async {
    try {
      final levels = await _databaseService.getChemigationLevels();
      setState(() {
        _chemigationLevels = levels;
      });
    } catch (e) {
      print('Error loading chemigation data: $e');
    }
  }

  Future<void> _loadMoistureData() async {
    try {
      final moistureLevel = await _databaseService.getLatestMoistureLevel();
      setState(() {
        _latestMoistureLevel = moistureLevel;
      });
    } catch (e) {
      print('Error loading moisture data: $e');
    }
  }

  void showDetectionAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detection Alert'),
          content: const Text('A new pest has been detected!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _testSevereAlert() {
    _showFullScreenAlert([
      {'count': 5, 'location': 'Test Location'}
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
            leading: isDesktop
                ? null
                : IconButton(
                    icon: const Icon(Icons.menu, color: Colors.green),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
            actions: [
              if (isDesktop) ...[
                _buildNavItem(Icons.dashboard, 'Dashboard', isSelected: true),
                _buildNavItem(Icons.bug_report, 'Pest Detection'),
                _buildNavItem(Icons.water_drop, 'Irrigation'),
                _buildNavItem(Icons.track_changes, 'Monitoring'),
                _buildNavItem(Icons.history, 'History'),
                _buildNavItem(Icons.settings, 'Settings'),
              ],
              IconButton(
                icon: const Icon(Icons.warning, color: Colors.amber),
                onPressed: _testSevereAlert,
                tooltip: 'Test Alert',
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.green),
                onPressed: _loadDetectionData,
                tooltip: 'Reload Data',
              ),
            ],
          ),
          drawer: isDesktop ? null : _buildDrawer(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildDashboardContent(),
            ),
          ),
        );
      },
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
    if (MediaQuery.of(context).size.width > 600) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextButton.icon(
          icon: Icon(icon, color: isSelected ? Colors.green : Colors.grey),
          label: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.green : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onPressed: () {
            // Navigation logic would go here
          },
        ),
      );
    } else {
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
          Navigator.pop(context); // Close drawer after selection
        },
      );
    }
  }

  Widget _buildDashboardContent() {
    final now = DateTime.now();

    // Group detections by date and get the latest for each day
    final Map<String, DetectionModel> latestDetectionsByDay = {};
    for (var detection in _detections) {
      final dateKey = DateFormat('yyyy-MM-dd').format(detection.date);
      if (!latestDetectionsByDay.containsKey(dateKey) ||
          detection.date.isAfter(latestDetectionsByDay[dateKey]!.date)) {
        latestDetectionsByDay[dateKey] = detection;
      }
    }

    // Get this month's detections
    final thisMonthDetections = latestDetectionsByDay.values
        .where((detection) =>
            detection.date.year == now.year &&
            detection.date.month == now.month)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort by date descending

    final latestDetection =
        thisMonthDetections.isNotEmpty ? thisMonthDetections.first : null;
    double chemigationLevel = 10.0;

    if (latestDetection != null) {
      switch (latestDetection.status.toLowerCase()) {
        case 'severe':
          chemigationLevel = 60.0;
          break;
        case 'moderate':
          chemigationLevel = 30.0;
          break;
        case 'normal':
        default:
          chemigationLevel = 10.0;
          break;
      }
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Chemigation Level",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF252525),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _currentTime,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
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
                  pointers: [
                    RangePointer(
                      value: chemigationLevel,
                      width: 0.2,
                      color: Colors.green,
                      cornerStyle: CornerStyle.bothCurve,
                      sizeUnit: GaugeSizeUnit.factor,
                    )
                  ],
                  annotations: [
                    GaugeAnnotation(
                      widget: Text(
                        '${chemigationLevel.toStringAsFixed(0)}%',
                        style: const TextStyle(
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
            Row(
              children: [
                Expanded(
                    child: StatCard(
                        title: "Aphids Detected",
                        value: thisMonthDetections.isNotEmpty
                            ? "${thisMonthDetections.first.numberOfAphids} aphids"
                            : "No data",
                        time: thisMonthDetections.isNotEmpty
                            ? _getTimeAgo(thisMonthDetections.first.date)
                            : "No data")),
                const SizedBox(width: 10),
                Expanded(
                    child: StatCard(
                        title: "Moisture Level",
                        value: _latestMoistureLevel != null
                            ? "${_latestMoistureLevel!.level}%"
                            : "No data",
                        time: _latestMoistureLevel != null
                            ? _getTimeAgo(_latestMoistureLevel!.date)
                            : "No data")),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Chemigation Trend",
              style: TextStyle(
                color: Color(0xFFB5FF70),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            _buildChemigationTrend(),
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error.isNotEmpty
                      ? Center(
                          child: Text(_error,
                              style: const TextStyle(color: Colors.red)))
                      : thisMonthDetections.isEmpty
                          ? const Center(
                              child: Text(
                                "There are no aphids detected currently",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                        child: TableText("Date", bold: true)),
                                    Expanded(
                                        child: TableText("Time", bold: true)),
                                    Expanded(
                                        child: TableText("No. Aphids",
                                            bold: true)),
                                    Expanded(
                                        child: TableText("Status", bold: true)),
                                  ],
                                ),
                                const Divider(color: Colors.grey),
                                ...thisMonthDetections.map((detection) =>
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: TableText(
                                                  DateFormat('MMMM d')
                                                      .format(detection.date))),
                                          Expanded(
                                              child: TableText(
                                                  DateFormat('HH:mm:ss')
                                                      .format(detection.date))),
                                          Expanded(
                                              child: TableText(detection
                                                  .numberOfAphids
                                                  .toString())),
                                          Expanded(
                                              child: TableText(
                                            detection.status,
                                            style: TextStyle(
                                              color: detection.status
                                                          .toLowerCase() ==
                                                      'detected'
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          )),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChemigationTrend() {
    if (_chemigationLevels.isEmpty) {
      return const Center(
        child: Text(
          'No chemigation data available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    // Get the last 7 days of data
    final lastSevenDays = _chemigationLevels
        .take(7)
        .toList()
        .reversed
        .toList(); // Reverse to show oldest to newest

    return SizedBox(
      height: 220,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 100,
            backgroundColor: const Color(0xFF1E1E1E),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 20,
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
                    if (value.toInt() >= 0 &&
                        value.toInt() < lastSevenDays.length) {
                      final date = lastSevenDays[value.toInt()].date;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat('MMM d').format(date),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 20,
                  reservedSize: 30,
                  getTitlesWidget: (value, _) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  lastSevenDays.length,
                  (index) => FlSpot(
                    index.toDouble(),
                    lastSevenDays[index].level.toDouble(),
                  ),
                ),
                isCurved: true,
                color: Colors.green,
                barWidth: 2,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.green.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final localDate = date.toLocal();
    final difference = now.difference(localDate);

    // If it's the same day, just show the hours and minutes
    if (now.year == localDate.year &&
        now.month == localDate.month &&
        now.day == localDate.day) {
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;

      if (hours > 0) {
        return "$hours hours $minutes minutes ago";
      } else if (minutes > 0) {
        return "$minutes minutes ago";
      } else {
        return "Just now";
      }
    } else {
      // If it's a different day
      final days = difference.inDays;
      return "$days days ago";
    }
  }
}

class TableText extends StatelessWidget {
  final String text;
  final bool bold;
  final TextStyle? style;

  const TableText(this.text, {this.bold = false, this.style, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ??
          TextStyle(
            color: bold ? const Color(0xFFB5FF70) : Colors.white,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
    );
  }
}
