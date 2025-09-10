import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/dashboard_controller.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/device/device_utility.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class TWeeklySalesGraph extends StatelessWidget {
  const TWeeklySalesGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Sales',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwSections),
          //GGraphh
          SizedBox(
            height: 400,
            child: BarChart(
              BarChartData(
                titlesData: buildFlTitlesData(),
                borderData: FlBorderData(
                    show: false,
                    border: const Border(
                        top: BorderSide.none, right: BorderSide.none)),
                gridData: const FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: 200,
                ),
                barGroups: controller.weeklySales
                    .asMap()
                    .entries
                    .map(
                      (entry) => BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            width: 30,
                            toY: entry.value,
                            color: TColors.primary,
                            borderRadius: BorderRadius.circular(TSizes.sm),
                          ),
                        ],
                      ),
                    )
                    .toList(),
                groupsSpace: TSizes.spaceBtwItems,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(),
                  touchCallback: TDeviceUtils.isDesktopScreen(context)
                      ? (barTouchEvent, BarTouchResponse) {}
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FlTitlesData buildFlTitlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            final index = value.toInt() % days.length;
            final day = days[index];

            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: Text(day),
            );
          },
        ),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 200,
          reservedSize: 50,
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }
}
