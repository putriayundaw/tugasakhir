class BorrowedProductModels {
  final int id;
  final String namaBarang;

  final String namaPeminjam;
  final int total;
  final DateTime tanggal;
  final String deskripsi;

  BorrowedProductModels({
    required this.id,
    required this.namaBarang,

    required this.namaPeminjam,
    required this.total,
    required this.tanggal,
    required this.deskripsi,
  });

  factory BorrowedProductModels.fromJson(Map<String, dynamic> json) {
    return BorrowedProductModels(
      id: json['id'] ?? 0,
      namaBarang: json['nama_barang'] ?? '',

      namaPeminjam: json['nama_peminjam'] ?? '',
      total: json['total'] ?? 0,
      tanggal: DateTime.parse(json['tanggal'] ?? DateTime.now().toString()),
      deskripsi: json['deskripsi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_barang': namaBarang,
   
      'nama_peminjam': namaPeminjam,
      'total': total,
      'tanggal': tanggal.toIso8601String(),
      'deskripsi': deskripsi,
    };
  }
}