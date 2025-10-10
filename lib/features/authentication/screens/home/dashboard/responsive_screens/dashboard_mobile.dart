import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/home/dashboard_controller.dart';
import 'package:absensi/features/authentication/controller/home/login_controller.dart';
import 'package:absensi/features/authentication/screens/home/dashboard/table/data_table.dart';
import 'package:absensi/features/authentication/screens/home/dashboard/widgets/dashboard_card.dart';
import 'package:absensi/features/authentication/screens/home/dashboard/widgets/order/order_status_graph.dart';
import 'package:absensi/features/authentication/screens/home/dashboard/widgets/weekly_sales.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class DashboardMobileScreen extends StatelessWidget {
   DashboardMobileScreen({super.key});
   
  final loginController = Get.find<LoginController>();
  final DashboardController dashboardController = Get.find<DashboardController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text('Dashboard', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Cards
               TDashboardCard(
                      stats: dashboardController.totalStockIn.value,
                      title: 'Stock In',
                      subTitle: '${dashboardController.totalStockIn.value} '),
              
              const SizedBox(height: TSizes.spaceBtwItems),
              const TDashboardCard(stats: 15, title: 'Average Order Value', subTitle: '\$25'),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TDashboardCard(stats: 44, title: 'Total Orders', subTitle: '36'),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TDashboardCard(stats: 2, title: 'Visitors', subTitle: '25,035'),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Bar Graph
              const TWeeklyProductAdditionsGraph(),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Orders
             TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Recent Orders', style: Theme.of(context).textTheme.headlineSmall),
                                const SizedBox(height:TSizes.spaceBtwItems),
                              const  DashboardUserTable(),
                            ],
                          ),
                        ),
              // Pie Chart
              const OrderStatusPieChart(),
            ],
          ),
        ),
      ),
    );
  }
}
