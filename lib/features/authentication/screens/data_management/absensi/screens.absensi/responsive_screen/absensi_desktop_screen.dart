import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/screens/data_management/absensi/table/data_table.dart';
import 'package:absensi/features/authentication/screens/data_management/absensi/models/absensi_model.dart';
import 'package:absensi/features/authentication/controller/AttendanceManagement/absensi_controller.dart';
import 'package:absensi/features/authentication/screens/data_management/absensi/widgets/pagination_info.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AbsensiDesktopScreen extends StatefulWidget {
  const AbsensiDesktopScreen({super.key});

  @override
  State<AbsensiDesktopScreen> createState() => _AbsensiDesktopScreenState();
}

class _AbsensiDesktopScreenState extends State<AbsensiDesktopScreen> {
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

  List<Map<String, dynamic>> _getPaginatedData() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    return _filteredData
        .sublist(
          startIndex.clamp(0, _filteredData.length),
          endIndex.clamp(0, _filteredData.length),
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

  @override
  Widget build(BuildContext context) {
    final paginatedData = _getPaginatedData();
    return Scaffold(
      backgroundColor: TColors.borderPrimary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TBreadcrumbsWithHeading(
                heading: 'Attendance',
                breadcrumbItems: ['Attendance'],
              ),

              const SizedBox(height: 15),

              TRoundedContainer(
                padding: const EdgeInsets.all(0),
                backgroundColor: TColors.light,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.search_normal),
                          hintText:
                              'Search by name, status, day, year, month, or date...',
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
                                      _currentPage = 1;
                                    });
                                  },
                                )
                              : null,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                            _currentPage = 1;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _loadAttendanceData,
                    ),
                  ],
                ),
              ),

              if (!_isLoading && _errorMessage.isEmpty && _allData.isNotEmpty)
                DataTableWidget(data: paginatedData),

              const SizedBox(height: 5),

              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage.isNotEmpty)
                Center(
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: TColors.error),
                  ),
                )
              else if (_allData.isEmpty)
                const Center(child: Text('No attendance data available')),

              const SizedBox(height: 5),

              if (_searchQuery.isNotEmpty &&
                  !_isLoading &&
                  _errorMessage.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Found ${_filteredData.length} results for "$_searchQuery"',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),

              if (!_isLoading && _errorMessage.isEmpty && _allData.isNotEmpty)
                PaginationInfoWidget(
                  currentPage: _currentPage,
                  totalItems: _filteredData.length,
                  itemsPerPage: _itemsPerPage,
                  onItemsPerPageChanged: (newValue) {
                    setState(() {
                      _itemsPerPage = newValue;
                      _currentPage = 1;
                    });
                  },
                  onPageChanged: (newPage) {
                    setState(() {
                      _currentPage = newPage;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
