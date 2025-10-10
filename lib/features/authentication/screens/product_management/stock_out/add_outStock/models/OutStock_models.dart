// lib/features/authentication/screens/product_management/stock_in/add_inStock/models/in_stock_product_model.dart

class OutStockProductModel {
  final String id;
  final String product;
  final double price;
  final int total;
  final String parentProduct;
  final String description;
  final String imageUrl;
  final DateTime dateCreated;

  OutStockProductModel({
    required this.id,
    required this.product,
    required this.price,
    required this.total,
    required this.parentProduct,
    required this.description,
    required this.imageUrl,
    required this.dateCreated,
  });

  // Factory constructor to create an instance from JSON
  factory OutStockProductModel.fromJson(Map<String, dynamic> json) {
    return OutStockProductModel(
      id: json['id']?.toString() ?? '',
      product: json['nama_barang']?.toString() ?? '',
      price: double.tryParse(json['harga']?.toString() ?? '0') ?? 0.0,
      total: int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      parentProduct: json['parent_addproduct']?.toString() ?? '',
      description: json['deskripsi']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      dateCreated: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_barang': product,
      'harga': price.toString(),
      'total': total.toString(),
      'parent_addproduct': parentProduct,
      'deskripsi': description,
      'image_url': imageUrl,
      'created_at': dateCreated.toIso8601String(),
    };
  }
   OutStockProductModel copyWith({
    String? id,
    String? product,
    double? price,
    int? total,
    String? parentProduct,
    String? description,
    String? imageUrl,
    DateTime? dateAdded,
  }) {
    return OutStockProductModel(
      id: id ?? this.id,
      product: product ?? this.product,
      price: price ?? this.price,
      total: total ?? this.total,
      parentProduct: parentProduct ?? this.parentProduct,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      dateCreated: dateAdded ?? this.dateCreated,
    );
  }

}