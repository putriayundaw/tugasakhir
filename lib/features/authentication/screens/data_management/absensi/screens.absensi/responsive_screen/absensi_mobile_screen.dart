import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/screens/data_management/absensi/models/absensi_model.dart';
import 'package:absensi/features/authentication/controller/AttendanceManagement/absensi_controller.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class AbsensiMobileScreen extends StatefulWidget {
  const AbsensiMobileScreen({super.key});

  @override
  State<AbsensiMobileScreen> createState() => _AbsensiMobileScreenState();
}

class _AbsensiMobileScreenState extends State<AbsensiMobileScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentPage = 1;
  int _itemsPerPage = 10;
  List<Attendance> _allData = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final data = await Attendancecontroller.getAttendanceData();

      setState(() {
        _allData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load data: $e';
      });
    }
  }

  List<Attendance> get _filteredData {
    if (_searchQuery.isEmpty) {
      return _allData;
    }

    final query = _searchQuery.toLowerCase();

    return _allData.where((item) {
      final name = item.name.toLowerCase();
      final day = item.day.toLowerCase();
      final date = item.date.toLowerCase();
      final status = item.status.toLowerCase();

      if (name.contains(query) ||
          status.contains(query) ||
          day.contains(query)) {
        return true;
      }

      if (_isDateRelatedQuery(query, date)) {
        return true;
      }

      return false;
    }).toList();
  }

  bool _isDateRelatedQuery(String query, String date) {
    if (RegExp(r'^\d{4}-\d{1,2}-\d{1,2}$').hasMatch(query)) {
      return date == query;
    }

    if (RegExp(r'^\d{4}$').hasMatch(query)) {
      return date.startsWith(query);
    }

    if (RegExp(r'^\d{4}-\d{1,2}$').hasMatch(query)) {
      return date.startsWith(query);
    }

    if (RegExp(r'^\d{1,2}$').hasMatch(query) && int.tryParse(query) != null) {
      final month = int.parse(query);
      if (month >= 1 && month <= 12) {
        return date.contains('-$query-');
      }
    }

    return false;
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty || time == 'null') {
      return '-';
    }

    if (time.length >= 5) {
      return time.substring(0, 5);
    }

    return time;
  }

  Widget _buildMobileCard(Map<String, dynamic> item) {
    final status = item['status'] as String;
    Color badgeBg;
    Color badgeText;
    
    if (status == 'Present') {
      badgeBg = TColors.success.withOpacity(0.30);
      badgeText = TColors.success;
    } else if (status == 'Late') {
      badgeBg = TColors.warning.withOpacity(0.30);
      badgeText = TColors.warning;
    } else {
      badgeBg = TColors.error.withOpacity(0.30);
      badgeText = TColors.error;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['name']!, 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(item['date']!),
                const Spacer(),
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 8),
                Text(item['day']!),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.login, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Text('In: ${item['in']}'),
                const Spacer(),
                const Icon(Icons.logout, size: 16, color: Colors.red),
                const SizedBox(width: 8),
                Text('Out: ${item['out']}'),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: badgeText,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paginatedData = _filteredData
        .sublist(
          0,
          _filteredData.length > 10 ? 10 : _filteredData.length,
        )
        .map((attendance) {
          return {
            'name': attendance.name,
            'day': attendance.day,
            'date': attendance.date,
            'in': _formatTime(attendance.timeIn),
            'out': _formatTime(attendance.timeOut),
            'status': attendance.status,
          };
        })
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAttendanceData,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TRoundedContainer(
              padding: const EdgeInsets.all(0),
              backgroundColor: TColors.light,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.search_normal),
                        hintText: 'Search attendance...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: TSizes.sm,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: TColors.error),
                        ),
                      )
                    : _allData.isEmpty
                        ? const Center(child: Text('No attendance data available'))
                        : ListView.builder(
                            itemCount: paginatedData.length,
                            itemBuilder: (context, index) {
                              return _buildMobileCard(paginatedData[index]);
                            },
                          ),
          ),
          if (_searchQuery.isNotEmpty && !_isLoading && _errorMessage.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Found ${_filteredData.length} results for "$_searchQuery"',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}