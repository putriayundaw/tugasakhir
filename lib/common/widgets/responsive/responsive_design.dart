import 'package:flutter/material.dart';
import 'package:absensi/utils/constans/sizes.dart';

class TResponsiveWidget extends StatelessWidget {
  const TResponsiveWidget({super.key, this.desktop, this.tablet, this.mobile});

  final Widget? desktop;
  final Widget? tablet;
  final Widget? mobile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth >= TSizes.desktopScreenSize) {
          return desktop ?? const SizedBox();
        } else if (constraints.maxWidth >= TSizes.tabletScreenSize) {
          return tablet ?? desktop ?? const SizedBox();
        } else {
          return mobile ?? tablet ?? desktop ?? const SizedBox();
        }
      },
    );
  }
}
