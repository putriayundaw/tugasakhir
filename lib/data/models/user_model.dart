import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/formatters/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  String name;
  String email;
  String phoneNumber;
  String profilePicture;
  AppRole role;
  String? school;
  String? address;
  String? gender;
  String? password; // Optional
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    required this.email,
    this.name = '',
    this.phoneNumber = '',
    this.profilePicture = '',
    this.role = AppRole.user,
    this.school,
    this.address,
    this.gender,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  String get formattedDate => TFormatter.formatDate(createdAt);
  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  static UserModel empty() => UserModel(email: '');

  /// JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Role': role.name,
      'School': school,
      'Address': address,
      'Gender': gender,
      'CreatedAt': createdAt,
      'UpdatedAt': DateTime.now(),
    };
  }

  /// JSON untuk dikirim ke MySQL (via Node-RED / API)
  Map<String, dynamic> toMysqlJson() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'role': role.name,
      'school': school,
      'address': address,
      'gender': gender,
      'password': password, // optional, jangan pakai di production
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        name: data['name'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
        school: data['School'],
        address: data['Address'],
        gender: data['Gender'],
        role: data['Role'] == AppRole.admin.name ? AppRole.admin : AppRole.user,
        createdAt: data['CreatedAt']?.toDate(),
        updatedAt: data['UpdatedAt']?.toDate(),
      );
    } else {
      return empty();
    }
  }

  // Method copyWith untuk memperbarui nilai tanpa mengubah objek asli
  UserModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    AppRole? role,
    String? school,
    String? address,
    String? gender,
    String? password,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      role: role ?? this.role,
      school: school ?? this.school,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Validasi untuk email
  bool isValidEmail() {
    RegExp emailRegEx = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegEx.hasMatch(this.email);
  }

  /// Validasi untuk nomor telepon
  bool isValidPhoneNumber() {
    RegExp phoneRegEx = RegExp(r"^\+?[1-9]\d{1,14}$");
    return phoneRegEx.hasMatch(this.phoneNumber);
  }

  /// Memperbarui gambar profil
  void updateProfilePicture(String newProfilePicture) {
    this.profilePicture = newProfilePicture;
  }

  /// Mengubah `DateTime` menjadi string
  String getCreatedAtString() {
    return createdAt != null ? TFormatter.formatDate(createdAt!) : 'Not available';
  }

  String getUpdatedAtString() {
    return updatedAt != null ? TFormatter.formatDate(updatedAt!) : 'Not available';
  }
}
