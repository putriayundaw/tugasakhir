class DashboardData {
  final int totalPeminjaman;
  final int totalPengembalian;
  final int totalStockMasuk;
  final int totalStockKeluar;
  final double persentasePeminjaman;
  final double persentasePengembalian;
  final double persentaseStockMasuk;
  final double persentaseStockKeluar;

  DashboardData({
    required this.totalPeminjaman,
    required this.totalPengembalian,
    required this.totalStockMasuk,
    required this.totalStockKeluar,
    required this.persentasePeminjaman,
    required this.persentasePengembalian,
    required this.persentaseStockMasuk,
    required this.persentaseStockKeluar,
  });
}