// ignore: unused_import
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/device/device_utility.dart';
import 'package:get/get.dart';

class SidebarController extends GetxController {
  final activeItem = ''.obs;  // Menyimpan route yang aktif
  final hoverItem = ''.obs;   // Menyimpan route yang sedang di-hover

  // Fungsi untuk mengubah item yang aktif
  void changeActiveItem(String route) {
    activeItem.value = route;
  }

  // Fungsi untuk mengubah item yang di-hover
  void changeHoverItem(String route) {
    if (!isActive(route)) hoverItem.value = route;
  }

  // Mengecek apakah item ini aktif
  bool isActive(String route) => activeItem.value == route;

  // Mengecek apakah item ini sedang di-hover
  bool isHovering(String route) => hoverItem.value == route;

  // Fungsi untuk menanggapi tap pada menu sidebar
  void menuOnTap(String route) {
    // Jika route belum aktif, ubah menjadi aktif
    if (!isActive(route)) {
      changeActiveItem(route);

      // Jika di perangkat mobile, tutup sidebar setelah memilih item
      if (TDeviceUtils.isMobileScreen(Get.context!)) Get.back();

      // Pindah ke halaman yang sesuai
      Get.toNamed(route);
    }
  }

  // Inisialisasi item yang aktif saat controller diinisialisasi
  @override
  void onInit() {
    super.onInit();
    // Menentukan item aktif berdasarkan route yang aktif di awal
    activeItem.value = Get.currentRoute;
  }
}
