import 'package:absensi/common/widgets/layouts/sidebars/sidebar_controller.dart';
import 'package:absensi/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RouteObserver extends GetObserver {


  @override  
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute){
    final sidebarController = Get.put(SidebarController());

    if(previousRoute!= null){
      for(var routeName in TRoutes.sidebarMenuItems){
        if (previousRoute.settings.name == routeName){
          sidebarController.activeItem.value = routeName;
        }
      }
    }
  }
}