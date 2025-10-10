import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/home/dashboard_controller.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderStatusPieChart extends StatelessWidget {
  const OrderStatusPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController.instance;
    return TRoundedContainer(
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status Produk', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height:TSizes.spaceBtwSections),

          //grap
          Builder(builder: (_) {
            final stockInCount = controller.totalStockIn.value.toDouble();
            final stockOutCount = controller.totalStockOut.value.toDouble();
            final borrowedCount = controller.totalBorrowed.value.toDouble();
            final returnedCount = controller.totalReturned.value.toDouble();
            final total = stockInCount + stockOutCount + borrowedCount + returnedCount;
            if (total == 0) {
              return SizedBox(
                height: 400,
                child: Center(child: Text('No data available')),
              );
            }
            return SizedBox(
              height: 300, // Pastikan ini cukup besar untuk menampilkan chart dengan jelas
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0, // Mengurangi jarak antar bagian agar lebih rapat
                  centerSpaceRadius: 40, // Menambahkan ruang kosong di tengah untuk gaya
                  sections: [
                    PieChartSectionData(
                      radius: 80,
                      title: stockInCount.toInt().toString(),
                      value: stockInCount,
                      color: Colors.green,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      radius: 80,
                      title: stockOutCount.toInt().toString(),
                      value: stockOutCount,
                      color: Colors.red,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      radius: 80,
                      title: borrowedCount.toInt().toString(),
                      value: borrowedCount,
                      color: Colors.orange,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      radius: 80,
                      title: returnedCount.toInt().toString(),
                      value: returnedCount,
                      color: Colors.blue,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                    enabled: true,
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: TSizes.spaceBtwSections),

          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem(Colors.green, 'Stock In', controller.totalStockIn.value),
              _buildLegendItem(Colors.red, 'Stock Out', controller.totalStockOut.value),
              _buildLegendItem(Colors.orange, 'Borrowed', controller.totalBorrowed.value),
              _buildLegendItem(Colors.blue, 'Returned', controller.totalReturned.value),
            ],
          ),
        ],
      
      )),
    );
  }

  Widget _buildLegendItem(Color color, String title, int count) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text('$title: $count'),
      ],
    );
  }
}
