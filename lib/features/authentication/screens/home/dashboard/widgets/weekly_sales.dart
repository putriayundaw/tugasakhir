import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/home/dashboard_controller.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/device/device_utility.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TWeeklyProductAdditionsGraph extends StatelessWidget {
  const TWeeklyProductAdditionsGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weekly Product Additions',
                  style: Theme.of(context).textTheme.headlineSmall),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  print('🔄 Refresh button pressed');
                  controller.refreshProductData();
                },
                tooltip: 'Refresh Data',
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          
          // Product Stats Summary - REACTIVE
          Obx(() => _buildProductStats(controller)),
          const SizedBox(height: TSizes.spaceBtwItems),
          
          // Graph - REACTIVE
          Obx(() {
            print('📊 Rebuilding graph with data: ${controller.weeklyProductAdditions}');
            return SizedBox(
              height: 400,
              child: BarChart(
                BarChartData(
                  titlesData: _buildFlTitlesData(),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                  ),
                  barGroups: controller.weeklyProductAdditions
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              width: 25,
                              toY: entry.value,
                              color: TColors.primary,
                              borderRadius: BorderRadius.circular(TSizes.sm),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                  groupsSpace: 20,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()} products added\n${_getDayName(group.x)}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  minY: 0,
                  maxY: _calculateMaxY(controller.weeklyProductAdditions),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProductStats(DashboardController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          'Total Products',
          controller.productStats['total_products']?.toString() ?? '0',
          TColors.primary,
        ),
        _buildStatItem(
          'Low Stock',
          controller.productStats['low_stock_products']?.toString() ?? '0',
          TColors.warning,
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12, 
            color: TColors.darkGrey,
          ),
        ),
      ],
    );
  }

  double _calculateMaxY(List<double> data) {
    if (data.isEmpty) return 5;
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    return maxValue < 3 ? 5 : maxValue + 2;
  }

  String _getDayName(int index) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[index % days.length];
  }

  FlTitlesData _buildFlTitlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            final index = value.toInt();
            if (index >= 0 && index < days.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  days[index],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
          interval: 1,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }
}