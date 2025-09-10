import 'package:absensi/common/widgets/containers/circular_container.dart';
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/dashboard_controller.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/helpers/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OrderStatusPieChart extends StatelessWidget {
  const OrderStatusPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController.instance;
    return TRoundedContainer(
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Orders Status', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height:TSizes.spaceBtwSections),

          //grap
          SizedBox(
  height: 400, // Pastikan ini cukup besar untuk menampilkan chart dengan jelas
  child: PieChart(
    PieChartData(
      sectionsSpace: 0, // Mengurangi jarak antar bagian agar lebih rapat
      centerSpaceRadius: 40, // Menambahkan ruang kosong di tengah untuk gaya
      sections: controller.orderStatusData.entries.map((entry) {
        final status = entry.key;
        final count = entry.value;
        
        return PieChartSectionData(
          radius: 80,
          title: count.toString(),
          value: count.toDouble(),
          color: THelperFunctions.getOrderStatusColor(status),
          titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      }).toList(),
      pieTouchData: PieTouchData(
        touchCallback: (FlTouchEvent event, pieTouchResponse) {},
        enabled: true,
      ),
    ),
  ),
),

          //show status and color mate
          SizedBox(
            width:double.infinity ,
            child: DataTable(
              columns:const[
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Orders')),
                  DataColumn(label: Text('Total')),
              ] ,
              rows: controller.orderStatusData.entries.map((entry){
                final OrderStatus status = entry.key;
                final int count = entry.value;
                final totalAmount = controller.totalAmounts[status]??0;
                return DataRow(cells: [
                  DataCell(
                    Row(children: [
                      TCircularContainer(width:20, height:20, backgroundColor: THelperFunctions.getOrderStatusColor(status)),
                      Expanded(child: Text('${controller.getDisplayStatusName(status)}'))
                    ],
                    ),
                  ),
                  DataCell(Text(count.toString())),
                  DataCell(Text('\$${totalAmount.toStringAsFixed(2)}'))
                ]);
              }).toList(),
              ),
          )
        ],
      
      ),
    );
  }
}