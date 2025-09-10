
// ignore: unused_import
import 'package:absensi/data/models/order_model.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DashboardController extends GetxController{
  static DashboardController get instance =>Get.find();

final RxList<double> weeklySales = <double>[].obs;
final RxMap<OrderStatus, int> orderStatusData =<OrderStatus, int>{}.obs;
final RxMap<OrderStatus, double> totalAmounts =<OrderStatus, double>{}.obs;

//order
static final List<OrderModel> orders = [
  OrderModel(
    id: 'CWT0012',
    status: OrderStatus.processing,
    totalAmount: 265,
    orderDate: DateTime(2025, 9, 4),
    deliveryDate: DateTime(2025, 9, 4),
  ), // OrderModel

  OrderModel(
    id: 'CWT0025',
    status: OrderStatus.shipped,
    totalAmount: 139,
     orderDate: DateTime(2025, 9, 3),
    deliveryDate: DateTime(2025, 9, 3),
  ), // OrderModel

  OrderModel(
    id: 'CWT0152',
    status: OrderStatus.processing,
    totalAmount: 225,
     orderDate: DateTime(2025, 9, 2),
    deliveryDate: DateTime(2025, 9, 2),
  ), // OrderModel

  OrderModel(
    id: 'CWT0265',
    status: OrderStatus.delivered,
    totalAmount: 135,
    orderDate: DateTime(2025, 9, 1),
    deliveryDate: DateTime(2025, 9,1),
  ), // OrderModel

  OrderModel(
    id: 'CWT1536',
    status: OrderStatus.delivered,
    totalAmount: 115,
     orderDate: DateTime(2025, 9, 4),
    deliveryDate: DateTime(2025, 9, 4),
  ), // OrderModel
];

@override  
void onInit(){
  _calculateWeeklySales();
  _calculateOrderStatusData();
  super.onInit();
}
// Calculate weekly sales
void _calculateWeeklySales() {
  // Reset weeklySales to zeros
  weeklySales.value = List<double>.filled(7, 0.0);

  for (var order in orders) {
    final DateTime orderWeekStart = THelperFunctions.getStartOfWeek(order.orderDate);

    // Check if the order is within the current week
    if (orderWeekStart.isBefore(DateTime.now()) &&
        orderWeekStart.add(const Duration(days: 7)).isAfter(DateTime.now())) {

      int index = (order.orderDate.weekday - 1) % 7;

      // Ensure the index is non-negative
      index = index < 0 ? index + 7 : index;

      weeklySales[index] += order.totalAmount;

      print('OrderDate: ${order.orderDate}, CurrentWeekDay: $orderWeekStart, Index: $index');
    }
  }

  print('Weekly Sales: $weeklySales');
}

  void _calculateOrderStatusData() {
    orderStatusData.clear();

    totalAmounts.value={for(var status in OrderStatus.values) status:0.0};

    for(var order in orders){
      //count orders
      final status = order.status;
      orderStatusData[status] = (orderStatusData[status]?? 0) +1;

      ///calculate toal amounts for each status
      totalAmounts[status]=(totalAmounts[status]?? 0)+order.totalAmount;
    }
  }
  String getDisplayStatusName(OrderStatus status){
    switch (status){
      case OrderStatus.pending:
      return'Pending';
     case OrderStatus.processing:
     return 'Processing';
     case OrderStatus.shipped:
     return 'Shipped';
     case OrderStatus.cancelled:
     return 'Cancelled';
     default:
     return'Unknown';


    }  }

}