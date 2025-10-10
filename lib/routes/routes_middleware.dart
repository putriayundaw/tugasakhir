
import 'package:absensi/features/authentication/controller/home/login_controller.dart';
import 'package:absensi/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TRouteMiddleware extends GetMiddleware{

  @override
  RouteSettings? redirect(String? route){
    if (LoginController.instance.isLoggedIn()) {
      if (route == TRoutes.login) {
        return const RouteSettings(name: TRoutes.dashboard);
      }
      return null;
    } else {
      if (route == TRoutes.dashboard) {
        return const RouteSettings(name: TRoutes.login);
      }
      return null;
    }
  }

}
