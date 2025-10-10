
import 'package:absensi/features/authentication/screens/data_management/user_data/services/user_service.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/user_data/Models/userData_model.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/user_data/table/table_source.dart';
import 'package:absensi/features/authentication/screens/home/dashboard/widgets/data_table/paginated_data_table.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserDataTable extends StatefulWidget {
  const UserDataTable({super.key, this.searchQuery = ''});

  final String searchQuery;

  @override
  _UserDataTableState createState() => _UserDataTableState();
}

class _UserDataTableState extends State<UserDataTable> {
  late UserDataRows usersController;
  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    usersController = UserDataRows(users: [], onDataChanged: _loadUsers);
    _loadUsers();
  }

  @override
  void didUpdateWidget(covariant UserDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _filterUsers();
    }
  }

  Future<void> _loadUsers() async {
    try {
      final userService = Get.find<UserService>();
      await userService.fetchUsers();
      allUsers = userService.users;
      _filterUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $e')),
      );
    }
  }

  void _filterUsers() {
    filteredUsers = allUsers.where((user) =>
      user.name.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
      user.phoneNumber.contains(widget.searchQuery)
    ).toList();
    setState(() {
      usersController = UserDataRows(users: filteredUsers, onDataChanged: _loadUsers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TPaginatedDataTable(
      minWidth: 700,
      columns: const [
        DataColumn2(label: Text('Name')),
        DataColumn2(label: Text('Role')),
        DataColumn2(label: Text('School')),
        DataColumn2(label: Text('Address')),
        DataColumn2(label: Text('Phone Number')),
        DataColumn2(label: Text('Action'), fixedWidth: 100),
      ],
      source: usersController, 
    );
  }
}
