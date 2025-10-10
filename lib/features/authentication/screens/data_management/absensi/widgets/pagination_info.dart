import 'package:flutter/material.dart';

class PaginationInfoWidget extends StatelessWidget {
  final int currentPage;
  final int totalItems;
  final int itemsPerPage;
  final ValueChanged<int>? onItemsPerPageChanged;
  final ValueChanged<int>? onPageChanged;

  const PaginationInfoWidget({
    super.key,
    required this.currentPage,
    required this.totalItems,
    this.itemsPerPage = 10,
    this.onItemsPerPageChanged,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final totalPages = (totalItems / itemsPerPage).ceil();
    final startItem = ((currentPage - 1) * itemsPerPage) + 1;
    final endItem = currentPage * itemsPerPage > totalItems
        ? totalItems
        : currentPage * itemsPerPage;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Menampilkan $itemsPerPage dari $totalItems data',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        
        Row(
          children: [
            Row(
              children: [
                Text(
                  'Rows per page:',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: itemsPerPage,
                  icon: const Icon(Icons.arrow_drop_down, size: 16),
                  elevation: 2,
                  style: Theme.of(context).textTheme.bodySmall,
                  underline: Container(height: 0),
                  onChanged: (int? newValue) {
                    if (newValue != null && onItemsPerPageChanged != null) {
                      onItemsPerPageChanged!(newValue);
                    }
                  },
                  items: [5, 10, 20, 50].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ],
            ),
            
            const SizedBox(width: 16),
            
            Text(
              '$startItem-$endItem of about $totalItems',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            
            const SizedBox(width: 16),
            
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  onPressed: currentPage > 1 && onPageChanged != null
                      ? () => onPageChanged!(currentPage - 1)
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  onPressed: currentPage < totalPages && onPageChanged != null
                      ? () => onPageChanged!(currentPage + 1)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}