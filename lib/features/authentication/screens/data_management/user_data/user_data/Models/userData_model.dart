class UserModel {
  final String id;      // Numeric ID dari database
  final String role;
  final String school;
  final String name;
  final String address;
  final String gender;
  final String phoneNumber;
  final String email;
  final DateTime? inputDate;

  UserModel({
    required this.id,
    required this.role,
    required this.school,
    required this.name,
    required this.address,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    this.inputDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      role: json['role'] ?? '',
      school: json['school'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      inputDate: json['input_date'] != null
          ? DateTime.parse(json['input_date'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'school': school,
      'name': name,
      'address': address,
      'gender': gender,
      'phone_number': phoneNumber,
      'email': email,
    };
  }

  UserModel copyWith({
    String? id,
    String? role,
    String? school,
    String? name,
    String? address,
    String? gender,
    String? phoneNumber,
    String? email,
    DateTime? inputDate,
  }) {
    
    return UserModel(
      id: id ?? this.id,
      role: role ?? this.role,
      school: school ?? this.school,
      name: name ?? this.name,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      inputDate: inputDate ?? this.inputDate,
    );
  }
}
