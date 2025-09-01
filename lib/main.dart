import 'package:absensi/app.dart';
import 'package:absensi/data/repositories/authentication/authentication_repository.dart';
import 'package:absensi/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_strategy/url_strategy.dart';

// Titik masuk utama aplikasi Flutter
Future<void> main() async {
  // Memastikan bahwa widget telah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi penyimpanan lokal GetZX
  await GetStorage.init();

  // Hapus tanda dari URL
  setPathUrlStrategy();

  // Inisialisasi Firebase & repositori autentikasi
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
  .then((value) => Get.put(AuthenticationRepository()));

  
  //then((value) => Get.put(AuthenticationRepository()));

  // Aplikasi utama dimulai
  runApp(const App());
}
