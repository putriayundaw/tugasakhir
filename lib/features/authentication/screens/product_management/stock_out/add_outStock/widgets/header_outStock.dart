import 'package:absensi/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TTableHeaderOutStock extends StatelessWidget {
  const TTableHeaderOutStock({
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
      // Layout untuk Desktop (Row)
      return Row(
        children: [
          Expanded(
            flex: 3,
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
            flex: 2,
            child: TextFormField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search Products',
                prefixIcon: const Icon(Iconsax.search_normal),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 15),
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
          // Tombol Create New Products
          SizedBox(
            width: double.infinity, // Memenuhi lebar layar
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ),
          const SizedBox(height: 16),
          // Search Field
          TextFormField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search Products',
              prefixIcon: const Icon(Iconsax.search_normal),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 15),
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