import 'package:absensi/features/authentication/screens/data_management/user_data/services/user_service.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/user_data/Models/userData_model.dart';
import 'package:absensi/features/authentication/screens/home/dashboard/table/table_source.dart';
import 'package:absensi/features/authentication/screens/home/dashboard/widgets/data_table/paginated_data_table.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardUserTable extends StatefulWidget {
  const DashboardUserTable({super.key});

  @override
  _DashboardUserTableState createState() => _DashboardUserTableState();
}

class _DashboardUserTableState extends State<DashboardUserTable> {
  late DashboardUserRows usersController;
  List<UserModel> allUsers = [];

  @override
  void initState() {
    super.initState();
    usersController = DashboardUserRows(users: []);
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final userService = Get.find<UserService>();
      await userService.fetchUsers();
      allUsers = userService.users;
      setState(() {
        usersController = DashboardUserRows(users: allUsers);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TPaginatedDataTable(
      minWidth: 1000,
      columns: const [
        DataColumn2(label: Text('Nama')),
        DataColumn2(label: Text('Role')),
        DataColumn2(label: Text('School')),
        DataColumn2(label: Text('Address')),
        DataColumn2(label: Text('Phone Number')),
      ],
      source: usersController, 
    );
  }
}