import 'package:absensi/utils/constans/enums.dart';  // Mengimpor OrderStatus
import 'package:absensi/utils/helpers/helper_functions.dart';  // Mengimpor HelperFunctions

class OrderModel {
  final String id;
  final OrderStatus status;
  final int totalAmount;
  final DateTime orderDate;
  final DateTime deliveryDate;

  // Konstruktor OrderModel
  OrderModel({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.orderDate,
    required this.deliveryDate,
  });

  // Getter untuk mendapatkan tanggal pesanan yang diformat
String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  // Getter untuk mendapatkan tanggal pengiriman yang diformat
  String get formattedDeliveryDate => THelperFunctions.getFormattedDate(deliveryDate);

  // Fungsi untuk mendapatkan status pesanan dalam bentuk teks
  String get orderStatusText {
    switch (status) {
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.shipped:
        return 'Shipment on the way';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Processing';
    }
  }

  // Fungsi untuk mengonversi OrderModel ke format JSON untuk API atau penyimpanan
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.toString().split('.').last, // Mengonversi enum ke string
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate.toIso8601String(),
    };
  }

  // Static function untuk membuat OrderModel kosong
  static OrderModel empty() {
    return OrderModel(
      id: '',
      status: OrderStatus.pending,  // Status default adalah pending
      totalAmount: 0,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now(),
    );
  }
}
