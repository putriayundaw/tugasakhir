class ReturnedProductModels {
  final int id;
  final String namaBarang;
  final String namaPeminjam;
  final int total;
  final DateTime tanggal;
  

  ReturnedProductModels({
    required this.id,
    required this.namaBarang,
    required this.namaPeminjam,
    required this.total,
    required this.tanggal,
 
  });

  factory ReturnedProductModels.fromJson(Map<String, dynamic> json) {
    return ReturnedProductModels(
      id: json['id'] ?? 0,
      namaBarang: json['nama_barang'] ?? '',
      namaPeminjam: json['nama_peminjam'] ?? '',
      total: json['total'] ?? 0,
      tanggal: DateTime.parse(json['tanggal'] ?? DateTime.now().toString()),
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_barang': namaBarang,
      'nama_peminjam': namaPeminjam,
      'total': total,
      'tanggal': tanggal.toIso8601String(),
     
    };
  }
}