import 'dart:convert';

class PermissionModel {
  final int? id;
  final String name;
  final String school;
  final String day;
  final DateTime? date; 
  final String information;
  final List<String> images; 
  final DateTime? createdAt;

  PermissionModel({
    this.id,
    required this.name,
    required this.school,
    required this.day,
    this.date,
    required this.information,
    this.images = const [],
    this.createdAt,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      name: json['name']?.toString() ?? '',
      school: json['school']?.toString() ?? '',
      day: json['day']?.toString() ?? '',
      date: json['date'] != null && json['date'].toString().isNotEmpty
          ? DateTime.tryParse(json['date'].toString())
          : null,
      information: json['information']?.toString() ?? '',
      images: List<String>.from(json['images'] ?? []),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'school': school,
      'day': day,
      'date': date != null ? date!.toIso8601String().split('T').first : null, // YYYY-MM-DD
      'information': information,
      'images': images, 
      'created_at': createdAt?.toIso8601String(),
    };
  }

  static List<String> _parseImages(dynamic raw) {
    if (raw == null) return [];
    if (raw is String) {
      try {
        final decoded = raw.startsWith('[') ? jsonDecode(raw) : null;
        if (decoded is List) return decoded.map((e) => e.toString()).toList();
      } catch (_) {}
      return [raw];
    }
    if (raw is List) return raw.map((e) => e.toString()).toList();
    return [];
  }
}
