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

class DashboardDesktopScreen extends StatelessWidget {
  DashboardDesktopScreen({super.key});
  
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
              //heading
              Text('Dashboard',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: TSizes.spaceBtwSections),
              
              //cards
              Obx(() => Row(
                children: [
                  Expanded(
                    child: TDashboardCard(
                      stats: dashboardController.totalStockIn.value,
                      title: 'Stock In',
                      subTitle: '${dashboardController.totalStockIn.value} '),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: TDashboardCard(
                      stats: dashboardController.totalStockOut.value,
                      title: 'Stock Out',
                      subTitle: '${dashboardController.totalStockOut.value} '),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: TDashboardCard(
                      stats: dashboardController.totalBorrowed.value,
                      title: 'Borrowed',
                      subTitle: '${dashboardController.totalBorrowed.value} '),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: TDashboardCard(
                      stats: dashboardController.totalReturned.value,
                      title: 'Returned',
                      subTitle: '${dashboardController.totalReturned.value} '),
                  ),
                ],
              )),

              const SizedBox(height: TSizes.spaceBtwSections),
              
              // Grafik dalam satu baris
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weekly Graph
                  Expanded(
                    flex: 2,
                    child: TWeeklyProductAdditionsGraph(),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  
                  // Pie Chart
                  Expanded(
                    flex: 1,
                    child: OrderStatusPieChart(),
                  ),
                ],
              ),
              
              const SizedBox(height: TSizes.spaceBtwSections),

              // Tabel Users Full Width - hanya untuk admin
              Obx(() {
                final userRole = loginController.getUserRole().toLowerCase();
                
                if (userRole == 'admin') {
                  return TRoundedContainer(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Users', 
                          style: Theme.of(context).textTheme.headlineSmall
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        const SizedBox(
                          width: double.infinity, // Full width
                          child: DashboardUserTable(),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}