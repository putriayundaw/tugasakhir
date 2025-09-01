import 'package:absensi/common/widgets/layouts/headers/headers.dart';
import 'package:absensi/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:flutter/material.dart';

class DesktopLayout extends StatelessWidget {
   DesktopLayout({super.key, this.body});

  final Widget? body;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(child: TSidebar()),
          Expanded(
            flex:5 ,
            child: Column(
              children: [
                //header
               const THeader(),
                //body
               body ?? const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
