import 'package:absensi/features/authentication/media/media.dart';
import 'package:absensi/features/authentication/screens/dashboard/dashboard.dart';
import 'package:absensi/features/authentication/screens/forget_password/forget_password.dart';
import 'package:absensi/features/authentication/screens/login/login.dart';
import 'package:absensi/features/authentication/screens/register/register.dart';
import 'package:absensi/features/authentication/screens/reset_password/reset_password.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/routes/routes_middleware.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class TAppRoute{
  static final List<GetPage> pages =[
    GetPage(name: TRoutes.login, page:()=> const LoginScrenn()),
    GetPage(name: TRoutes.register, page:()=> const RegisterScreen()),
    GetPage(name: TRoutes.forgetPassword, page:()=> const ForgetPasswordScreen()),
    GetPage(name: TRoutes.resetPassword, page:()=> const ResetPasswordScreen()),
   GetPage(name: TRoutes.dashboard, page: () => const DashboardScreen()), // Middleware bisa dihapus sementara
GetPage(name: TRoutes.media, page: () => const MediaScreen()),
GetPage(name: TRoutes.media, page: () => const MediaScreen()),

    

  ];
}