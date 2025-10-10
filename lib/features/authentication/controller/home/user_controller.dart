// import 'package:absensi/data/models/user_model.dart';
// import 'package:absensi/data/repositories/user/user_repository.dart';
// import 'package:absensi/features/authentication/screens/data_management/user_data/services/user_service.dart';
// import 'package:absensi/utils/popups/loaders.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class UserController extends GetxController {
//   static UserController get instance => Get.find();

//   RxBool loading = false.obs;
//   Rx<UserModel> user = UserModel.empty().obs;

//   final userRepository = Get.put(UserRepository());
//   final localStorage = GetStorage();

//   @override
//   void onInit() {
//     super.onInit();
//     _loadUserDataFromStorage();
//     _refreshUserDataIfLoggedIn();
//   }

//   void _refreshUserDataIfLoggedIn() async {
//     final isLoggedIn = localStorage.read('isLoggedIn') ?? false;
//     if (isLoggedIn) {
//       final userId = localStorage.read('userId');
//       if (userId != null) {
//         try {
//           final userService = Get.find<UserService>();
//           final fullUser = await userService.getUserById(userId);
//           String username = fullUser.name;
//           if (username.isEmpty) {
//             username = fullUser.email.split('@')[0];
//           }
//           updateUserDetails(username, fullUser.email);
//         } catch (e) {
//           // Jika gagal refresh dari server, gunakan data dari localStorage
//           print('Failed to refresh user data from server: $e');
//         }
//       }
//     }
//   }

//   void _loadUserDataFromStorage() {
//     final storedName = localStorage.read('userName') ?? '';
//     final storedEmail = localStorage.read('userEmail') ?? '';
//     if (storedName.isNotEmpty || storedEmail.isNotEmpty) {
//       user.value = user.value.copyWith(name: storedName, email: storedEmail);
//     }
//   }

//   void _saveUserDataToStorage() {
//     localStorage.write('userName', user.value.name);
//     localStorage.write('userEmail', user.value.email);
//   }

//   Future<UserModel> fetchUserDetails() async {
//     try {
//       loading.value = true;
//       final user = await userRepository.fetchAdminDetails();
//       this.user.value = user;
//       loading.value = false;
//       return user;
//     } catch (e) {
//       loading.value = false;
//       TLoaders.errorSnackBar(title: 'Something went wrong.', message: e.toString());
//       return UserModel.empty();
//     }
//   }
//   void updateUserDetails(String name, String email) {
//     user.value = user.value.copyWith(name: name, email: email);
//     _saveUserDataToStorage();
//     update(); // Force UI update
//   }

//   void clearUserData() {
//     user.value = UserModel.empty();
//     localStorage.remove('userName');
//     localStorage.remove('userEmail');
//     update(); // Force UI update
//   }
// }