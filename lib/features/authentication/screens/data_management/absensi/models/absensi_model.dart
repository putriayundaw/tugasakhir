class Attendance {
  final int id;
  final int fingerprintId;
  final String name;
  final String day;
  final String date;
  final String? timeIn; 
  final String? timeOut; 
  final String status;

  Attendance({
    required this.id,
    required this.fingerprintId,
    required this.name,
    required this.day,
    required this.date,
    this.timeIn, 
    this.timeOut, 
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] ?? 0,
      fingerprintId: json['fingerprint_id'] ?? 0,
      name: json['name'] ?? '',
      day: json['day'] ?? json['hari'] ?? '', 
      date: json['date'] ?? json['tanggal'] ?? '',
      timeIn: json['time_in']?.toString(),
      timeOut: json['time_out']?.toString(),
      status: json['status'] ?? '',
    );
  }
}