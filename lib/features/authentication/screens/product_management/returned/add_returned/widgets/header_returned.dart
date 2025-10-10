import 'package:absensi/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TTableHeaderReturned extends StatelessWidget {
  const TTableHeaderReturned({
    super.key, 
    this.onPressed, 
    required this.buttonText, 
    this.searchController,
    required this.onSearchChanged,
  });

  final Function()? onPressed;
  final String buttonText;
  final TextEditingController? searchController;
  final Function(String) onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = TDeviceUtils.isDesktopScreen(context);

    if (isDesktop) {
      // Layout untuk Desktop (Row - layout asli)
      return Row(
        children: [
          // Tombol di kiri
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ),
          
          const Spacer(), // Mengisi ruang antara tombol dan search
          
          // Search Field di kanan dengan lebar fixed
          Container(
            width: 300, // Fixed width untuk search field
            child: TextFormField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search Products',
                prefixIcon: const Icon(Iconsax.search_normal),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Layout untuk Mobile (Column)
      return Column(
        children: [
          // Tombol memenuhi lebar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ),
          const SizedBox(height: 16),
          // Search Field memenuhi lebar
          TextFormField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search Products',
              prefixIcon: const Icon(Iconsax.search_normal),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ],
      );
    }
  }
}