import 'package:absensi/features/authentication/screens/data_management/user_data/user_data/Models/userData_model.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class DashboardUserRows extends DataTableSource {
  final List<UserModel> users;

  DashboardUserRows({required this.users});

  @override
  DataRow? getRow(int index) {
    if (index >= users.length) {
      return null;
    }

    final user = users[index];
    return DataRow2(
      cells: [
        DataCell(Text(user.name)),
        DataCell(Text(user.role)),
        DataCell(Text(user.school)),
        DataCell(Text(user.address)),
        DataCell(Text(user.phoneNumber)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}