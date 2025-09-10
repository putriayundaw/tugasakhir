import 'package:absensi/data/models/user_model.dart';
import 'package:absensi/data/repositories/user/user_repository.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  RxBool loading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;  // UserModel yang kosong sebagai nilai awal

  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
  }

  // Fungsi untuk mengambil data user dari server
  Future<UserModel> fetchUserDetails() async {
    try {
      loading.value = true;
      final user = await userRepository.fetchAdminDetails();  // Ambil data user
      this.user.value = user;
      loading.value = false;
      return user;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Something went wrong.', message: e.toString());
      return UserModel.empty();  // Jika error, kembalikan UserModel kosong
    }
  }

  // Fungsi untuk mengupdate nama dan email setelah login
  void updateUserDetails(String name, String email) {
    user.value = user.value.copyWith(name: name, email: email);  // Update nama dan email
  }
}
