import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/user_data/table/data_table.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/user_data/widgets/table_header.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserDataTabletScreen extends StatefulWidget {
  const UserDataTabletScreen({super.key});

  @override
  _UserDataTabletScreenState createState() => _UserDataTabletScreenState();
}

class _UserDataTabletScreenState extends State<UserDataTabletScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
       return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding:  const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const TBreadcrumbsWithHeading(heading: 'User Data', breadcrumbItems: ['User Data']),
             TRoundedContainer(
                child: Column(
                  children: [
                    TUserDataTableHeader(
                      onPressed: null,
                      searchController: searchController,
                      searchOnChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
             
                  UserDataTable(searchQuery: searchQuery)
                  ]
                ),
             ),
          ],
        ),),
      ),
    );
  }
}