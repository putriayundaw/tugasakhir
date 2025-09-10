import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/screens/dashboard/table/data_table.dart';
import 'package:absensi/features/authentication/screens/dashboard/widgets/dashboard_card.dart';
import 'package:absensi/features/authentication/screens/dashboard/widgets/order/order_status_graph.dart';
import 'package:absensi/features/authentication/screens/dashboard/widgets/weekly_sales.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

class DashboardTabletScreen extends StatelessWidget {
  const DashboardTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:  Padding(
  padding: const EdgeInsets.all(TSizes.defaultSpace),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Heading
      Text('Dashboard', style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: TSizes.spaceBtwSections),

      // Cards
      const Row(
        children: [
          Expanded(child: TDashboardCard(stats: 25, title: 'Sales total', subTitle: '\$365.6')),
          SizedBox(width: TSizes.spaceBtwItems),
          Expanded(child: TDashboardCard(stats: 15, title: 'Average Order Value', subTitle: '\$25')),
        ],
      ),
      const SizedBox(height: TSizes.spaceBtwItems),

      const Row(
        children: [
          Expanded(child: TDashboardCard(stats: 44, title: 'Total Orders', subTitle: '36')),
          SizedBox(width: TSizes.spaceBtwItems),
          Expanded(child: TDashboardCard(stats: 2, title: 'Visitors', subTitle: '25,035')),
        ],
      ),
      const SizedBox(height: TSizes.spaceBtwSections),

      // Bar Graph
      const TWeeklySalesGraph(),
      const SizedBox(height: TSizes.spaceBtwSections),

      // Orders
     TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Recent Orders', style: Theme.of(context).textTheme.headlineSmall),
                                const SizedBox(height:TSizes.spaceBtwItems),
                              const  DashboardOrderTable(),
                            ],
                          ),
                        ),
      // Pie Chart
      const OrderStatusPieChart(),
    ],
  ),
)

      ),
    );
  }
}
