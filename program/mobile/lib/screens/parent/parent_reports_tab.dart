import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:edu_smart_assistant/providers/parent_provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/diyaa_top_bar.dart';
import 'package:edu_smart_assistant/widgets/loading_widget.dart';

class ParentReportsTab extends StatefulWidget {
  const ParentReportsTab({super.key});

  @override
  State<ParentReportsTab> createState() => _ParentReportsTabState();
}

class _ParentReportsTabState extends State<ParentReportsTab> {
  String _selectedPeriod = 'weekly';

  @override
  void initState() {
    super.initState();
    final parentProvider = context.read<ParentProvider>();
    if (parentProvider.selectedChild != null) {
      Future.microtask(() => parentProvider.fetchReport(
          parentProvider.selectedChild!.id, _selectedPeriod));
    }
  }

  void _switchPeriod(String period) {
    setState(() => _selectedPeriod = period);
    final parentProvider = context.read<ParentProvider>();
    if (parentProvider.selectedChild != null) {
      parentProvider.fetchReport(parentProvider.selectedChild!.id, period);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DiyaaTopBar(
          greeting: '📊 التقارير',
          name: '',
          subtitle: 'متابعة تقدم الطالب',
        ),
        Expanded(
          child: Consumer<ParentProvider>(
            builder: (_, parentProvider, __) {
              if (parentProvider.selectedChild == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'أضف طفلاً لعرض التقارير',
                      style: GoogleFonts.tajawal(
                          fontSize: 16, color: AppTheme.text200),
                    ),
                  ),
                );
              }

              if (parentProvider.isLoading) {
                return const Center(
                  child: LoadingWidget(message: 'جاري تحميل التقارير...'),
                );
              }

              final report = _selectedPeriod == 'weekly'
                  ? parentProvider.weeklyReport
                  : parentProvider.monthlyReport;

              if (report == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'لا توجد بيانات بعد — ابدأ التعلم لظهور التقارير',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                          fontSize: 16, color: AppTheme.text200),
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildPeriodToggle(),
                    const SizedBox(height: 20),
                    _buildChartCard(
                      title: 'درجات الاختبارات',
                      child: SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 100,
                            barTouchData: BarTouchData(enabled: true),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final labels = [
                                      'قراءة',
                                      'كتابة',
                                      'استيعاب'
                                    ];
                                    if (value.toInt() < labels.length) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8),
                                        child: Text(
                                          labels[value.toInt()],
                                          style: GoogleFonts.tajawal(
                                              fontSize: 12),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) => Text(
                                    '${value.toInt()}',
                                    style:
                                        GoogleFonts.tajawal(fontSize: 10),
                                  ),
                                ),
                              ),
                              topTitles: const AxisTitles(
                                  sideTitles:
                                      SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(
                                  sideTitles:
                                      SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: [
                              _makeBarGroup(0, report.averageQuizScore,
                                  AppTheme.primary200),
                              _makeBarGroup(1, report.averageQuizScore * 0.9,
                                  AppTheme.successColor),
                              _makeBarGroup(2, report.averageQuizScore * 0.85,
                                  AppTheme.accent200),
                            ],
                            gridData: const FlGridData(show: true),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildChartCard(
                      title: 'التقدم عبر الزمن',
                      child: SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final labels =
                                        _selectedPeriod == 'weekly'
                                            ? [
                                                'سبت',
                                                'أحد',
                                                'اثنين',
                                                'ثلاثاء',
                                                'أربعاء',
                                                'خميس',
                                                'جمعة'
                                              ]
                                            : [
                                                'أسبوع 1',
                                                'أسبوع 2',
                                                'أسبوع 3',
                                                'أسبوع 4'
                                              ];
                                    if (value.toInt() < labels.length) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8),
                                        child: Text(
                                          labels[value.toInt()],
                                          style: GoogleFonts.tajawal(
                                              fontSize: 10),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) => Text(
                                    '${value.toInt()}',
                                    style:
                                        GoogleFonts.tajawal(fontSize: 10),
                                  ),
                                ),
                              ),
                              topTitles: const AxisTitles(
                                  sideTitles:
                                      SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(
                                  sideTitles:
                                      SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            minX: 0,
                            maxX: _selectedPeriod == 'weekly' ? 6 : 3,
                            minY: 0,
                            maxY: 100,
                            lineBarsData: [
                              LineChartBarData(
                                spots: _generateProgressSpots(
                                    report.progressScore),
                                isCurved: true,
                                color: AppTheme.primary200,
                                barWidth: 3,
                                dotData: const FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: AppTheme.primary200
                                      .withValues(alpha: 0.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (report.recentActivities.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'لا توجد نشاطات بعد',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            color: AppTheme.text200,
                          ),
                        ),
                      )
                    else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        child: Text(
                          'تفاصيل النشاطات',
                          style: GoogleFonts.tajawal(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.text100,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: report.recentActivities.length,
                        itemBuilder: (_, index) {
                          final activity = report.recentActivities[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusSm),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x148B5FBF),
                                  blurRadius: 12,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary100
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _getActivityIcon(activity['quiz_type']
                                          ?.toString() ??
                                      ''),
                                  color: AppTheme.primary200,
                                ),
                              ),
                              title: Text(
                                activity['lesson_name']?.toString() ??
                                    'نشاط',
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold),
                                textDirection: TextDirection.rtl,
                              ),
                              subtitle: Text(
                                '${activity['quiz_type'] ?? ''} - ${activity['score'] ?? ''}%',
                                style: GoogleFonts.tajawal(
                                    color: AppTheme.text200),
                                textDirection: TextDirection.rtl,
                              ),
                              trailing: Text(
                                activity['date']?.toString() ?? '',
                                style: GoogleFonts.tajawal(
                                  fontSize: 12,
                                  color: AppTheme.text200,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        boxShadow: const [
          BoxShadow(
            color: Color(0x148B5FBF),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _switchPeriod('weekly'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedPeriod == 'weekly'
                      ? AppTheme.primary200
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Text(
                  'أسبوعي',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _selectedPeriod == 'weekly'
                        ? Colors.white
                        : AppTheme.text200,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _switchPeriod('monthly'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedPeriod == 'monthly'
                      ? AppTheme.primary200
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Text(
                  'شهري',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _selectedPeriod == 'monthly'
                        ? Colors.white
                        : AppTheme.text200,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x148B5FBF),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.tajawal(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.text100,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.clamp(0, 100),
          color: color,
          width: 24,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _generateProgressSpots(double baseScore) {
    final count = _selectedPeriod == 'weekly' ? 7 : 4;
    return List.generate(count, (i) {
      final variation = (i * 5.0) - 10;
      final value = (baseScore + variation).clamp(0.0, 100.0);
      return FlSpot(i.toDouble(), value);
    });
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'reading':
        return Icons.menu_book;
      case 'writing':
        return Icons.edit_note;
      case 'comprehension':
        return Icons.psychology;
      default:
        return Icons.assignment;
    }
  }
}
