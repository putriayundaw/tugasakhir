import 'package:absensi/features/authentication/controller/AttendanceManagement/izin_controller.dart';
import 'package:absensi/features/authentication/screens/data_management/izin/add_permission/table/table_source.dart';
import 'package:absensi/features/authentication/screens/home/dashboard/widgets/data_table/paginated_data_table.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPermissionTable extends StatefulWidget {
  const AddPermissionTable({super.key});

  @override
  _AddPermissionTableState createState() => _AddPermissionTableState();
}

class _AddPermissionTableState extends State<AddPermissionTable> {
  final IzinController _izinController = Get.put(IzinController());

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    await _izinController.fetchPermissions();
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final permissions = _izinController.filteredPermissions;

      if (_izinController.permissions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Tidak ada data izin'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadPermissions,
                child: const Text('Muat Ulang'),
              ),
            ],
          ),
        );
      }

      if (permissions.isEmpty && _izinController.searchQuery.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Tidak ada data yang sesuai dengan pencarian'),
              const SizedBox(height: 16),
              Text('Pencarian: "${_izinController.searchQuery.value}"'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _izinController.searchPermissions(''),
                child: const Text('Tampilkan Semua Data'),
              ),
            ],
          ),
        );
      }

      final source = PermissionRows(permissions: permissions);

          return TPaginatedDataTable(
            minWidth: 700,
            columns: const [
              DataColumn2(label: Text('Name')),
              DataColumn2(label: Text('School')),
              DataColumn2(label: Text('Day/Date')),
              DataColumn2(label: Text('Information')),
              DataColumn2(label: Text('Attachment'), fixedWidth: 100),
            ],
            source: source,
          );
        }
    );
      }
  }
