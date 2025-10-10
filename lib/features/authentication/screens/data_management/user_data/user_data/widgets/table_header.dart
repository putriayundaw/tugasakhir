import 'package:absensi/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';

class TUserDataTableHeader extends StatelessWidget {
  const TUserDataTableHeader({super.key, this.onPressed, this.searchController, this.searchOnChanged});

  final Function()? onPressed;
  final TextEditingController? searchController;
  final Function(String)? searchOnChanged;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: !TDeviceUtils.isDesktopScreen(context) ? 2 : 1,
          child: TextFormField(
            controller: searchController,
            onChanged: searchOnChanged,
            decoration: const InputDecoration(
                hintText: 'Search Users',
                prefixIcon: Icon(Iconsax.search_normal)),
          ))
    ]);
  }
}
