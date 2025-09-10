import 'package:absensi/bindings/general_bindings.dart';
import 'package:absensi/routes/app_routes.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/text_strings.dart';
import 'package:absensi/utils/theme/widgets_themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // lebih baik import get.dart

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: TTexts.appName,
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      getPages: TAppRoute.pages,
      initialBinding: GeneralBindings(),
      initialRoute: TRoutes.login,
      unknownRoute: GetPage(name:'/page-not-found' , page: () => const Scaffold(body: Center(child: Text('Page Not Found')))),
    );
  }
}

