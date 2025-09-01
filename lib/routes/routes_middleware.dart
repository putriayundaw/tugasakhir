import 'package:absensi/data/repositories/authentication/authentication_repository.dart';
import 'package:absensi/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TRouteMiddleware extends GetMiddleware{

  @override
  RouteSettings? redirect(String? route){
    return AuthenticationRepository.instance.isAuthenticated?null:const RouteSettings(name: TRoutes.login);
   }

}