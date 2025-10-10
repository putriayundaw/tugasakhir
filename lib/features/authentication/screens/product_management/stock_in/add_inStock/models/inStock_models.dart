class InStockProductModel {
  final String id;
  final String product;
  final double price;
  final int total;

  final String description;
  final String imageUrl;
  final DateTime? dateAdded;

  InStockProductModel({
    required this.id,
    required this.product,
    required this.price,
    required this.total,

    required this.description,
    required this.imageUrl,
    this.dateAdded,
  });

  factory InStockProductModel.fromJson(Map<String, dynamic> json) {
    return InStockProductModel(
      id: json['id']?.toString() ?? '',
      product: json['nama_barang']?.toString() ?? '',
      price: double.tryParse(json['harga']?.toString() ?? '0') ?? 0.0,
      total: int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      
      description: json['deskripsi']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      dateAdded: json['tanggal'] != null 
          ? DateTime.tryParse(json['tanggal'].toString()) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_barang': product,
      'harga': price.toString(),
      'total': total.toString(),
      
      'deskripsi': description,
      'image_url': imageUrl,
      'tanggal': dateAdded?.toIso8601String(),
    };
  }

  InStockProductModel copyWith({
    String? id,
    String? product,
    double? price,
    int? total,
   
    String? description,
    String? imageUrl,
    DateTime? dateAdded,
  }) {
    return InStockProductModel(
      id: id ?? this.id,
      product: product ?? this.product,
      price: price ?? this.price,
      total: total ?? this.total,
      
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}