import 'package:absensi/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TAddPermissionTableHeader extends StatelessWidget {
  const TAddPermissionTableHeader({
    super.key, 
    this.onPressed, 
    required this.buttonText,
    this.searchController,
    required this.searchOnChanged, 
    this.onSearchSubmitted, 
  });

  final Function()? onPressed;
  final String buttonText;
  final TextEditingController? searchController;
  final Function(String) searchOnChanged; 
  final Function(String)? onSearchSubmitted; 

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: !TDeviceUtils.isDesktopScreen(context) ? 1 : 3,
          child: Row(
            children: [
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: !TDeviceUtils.isDesktopScreen(context) ? 2 : 1,
          child: TextFormField(
            controller: searchController,
            onChanged: searchOnChanged, 
            onFieldSubmitted: onSearchSubmitted, 
            decoration: const InputDecoration(
              hintText: 'Search Names',
              prefixIcon: Icon(Iconsax.search_normal),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}