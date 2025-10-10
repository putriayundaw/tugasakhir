import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TDashboardCard extends StatelessWidget {
  const TDashboardCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.stats,
    this.icon = Iconsax.arrow_up_3,
    this.color = Colors.green,
    this.onTap,
    this.comparedText = 'Compared to Dec 2025',
  });

  final String title, subTitle;
  final IconData icon;
  final Color color;
  final int stats;
  final void Function()? onTap;
  final String comparedText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600, // Batasi lebar maksimal card supaya gak overflow
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8, spreadRadius: 1)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title dan "View all" (optional)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'View all',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),

              /// SubTitle (nilai utama)
              Text(
                subTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              /// Statistik dan info "Compared to ..."
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Icon panah dan persentase
                  Row(
                    children: [
                      Icon(icon, color: color, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '$stats%',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  /// Text kecil dengan ellipsis
                  Expanded(
                    child: Text(
                      comparedText,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

