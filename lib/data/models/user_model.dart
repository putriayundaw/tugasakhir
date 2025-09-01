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
  DateTime? createdAt;            
  DateTime? updatedAt;            

  
  UserModel({
    this.id,
    required this.email,
    this.name = '',
    this.phoneNumber = '',
    this.profilePicture = '',
    this.role = AppRole.user,     
    this.createdAt,
    this.updatedAt,

  });
/// Format tanggal dibuat (dengan bantuan TFormatter)
String get formattedDate => TFormatter.formatDate(createdAt);

/// Format tanggal diupdate
String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

/// Format nomor HP
String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

/// Fungsi statis untuk membuat user kosong (kosongan)
static UserModel empty() => UserModel(email: '');

/// Mengubah UserModel menjadi Map<String, dynamic> (struktur JSON)
Map<String, dynamic> toJson() {
  return {
    'name'      : name,
    'Email'          : email,
    'PhoneNumber'    : phoneNumber,
    'ProfilePicture' : profilePicture,
    'Role'           : role.name.toString(),
    'CreatedAt'      : createdAt,
    'UpdatedAt'      : DateTime.now(),
    
      // Diisi saat ini
  };
}
factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
  // Cek apakah dokumen punya data
  if (document.data() != null) {
    final data = document.data()!;

    return UserModel(
      id: document.id,
      name     : data.containsKey('name')      ? data['name']      ?? '' : '',
      email         : data.containsKey('Email')          ? data['Email']          ?? '' : '',
      phoneNumber   : data.containsKey('PhoneNumber')    ? data['PhoneNumber']    ?? '' : '',
      profilePicture: data.containsKey('ProfilePicture') ? data['ProfilePicture'] ?? '' : '',

      // Cek apakah key 'Role' ada dan cocokkan dengan enum AppRole
      role: data.containsKey('Role') && data['Role'] == AppRole.admin.name
          ? AppRole.admin
          : AppRole.user,

      // Parsing Timestamp ke DateTime (Firestore menyimpan waktu sebagai Timestamp)
      createdAt: data.containsKey('CreatedAt')
          ? data['CreatedAt']?.toDate()
          : DateTime.now(),

      updatedAt: data.containsKey('UpdatedAt')
          ? data['UpdatedAt']?.toDate()
          : DateTime.now(),
    );
  } else {
    // Jika data kosong, kembalikan UserModel kosong
    return empty();
  }
}


  }