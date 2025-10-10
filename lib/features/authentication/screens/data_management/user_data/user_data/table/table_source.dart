

import 'package:absensi/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/services/user_service.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/user_data/Models/userData_model.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UserDataRows extends DataTableSource {
  final List<UserModel> users;
  final VoidCallback onDataChanged;

  UserDataRows({required this.users, required this.onDataChanged});

  @override
  DataRow? getRow(int index) {
    final user = users[index];

    return DataRow2(
      cells: [
        DataCell(Text(user.name)),
        DataCell(Text(user.role)),
        DataCell(Text(user.school)),
        DataCell(Text(user.address)),
        DataCell(Text(user.phoneNumber)),
        DataCell(
          TTableActionButtons(
            onEditPressed: () =>
                Get.toNamed(TRoutes.editData, arguments: {'user': user})?.then((_) => onDataChanged()),
            onDeletePressed: () => _showDeleteConfirmation(user.id, user.name),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(String uid, String userName) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus user "$userName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final userService = Get.find<UserService>();
                final success = await userService.deleteUser(uid); // Kirim UID
                if (success) {
                  ScaffoldMessenger.of(Get.context!).showSnackBar(
                    SnackBar(content: Text('User "$userName" berhasil dihapus!'), backgroundColor: TColors.primary),
                  );
                  onDataChanged();
                } else {
                  ScaffoldMessenger.of(Get.context!).showSnackBar(
                    const SnackBar(content: Text('Gagal menghapus user'), backgroundColor: TColors.primary),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(Get.context!).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}