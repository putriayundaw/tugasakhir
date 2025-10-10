import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';


class DataTableWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  
  const DataTableWidget({super.key, required this.data});

  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  int? _hoverIndex;

  @override
  Widget build(BuildContext context) {
    const Color tableBackground = Colors.white;
    const TextStyle headerTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 13,
      color: Colors.black87,
    );
    const TextStyle rowTextStyle = TextStyle(
      fontSize: 13,
      color: Colors.black87,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: TRoundedContainer(
          showShadow: true,
          showBorder: true,
          borderColor: Colors.grey.shade300,
          backgroundColor: Colors.white, 
          padding: const EdgeInsets.all(TSizes.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Container(
              decoration: BoxDecoration(
                color: tableBackground,
                borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
              ),
              child: Column(
                children: [
                  // Header dengan kolom hari
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: TSizes.lg, vertical: TSizes.xs),
                    decoration: BoxDecoration(
                      color: TColors.borderPrimary.withOpacity(0.7),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(TSizes.borderRadiusLg),
                        topRight: Radius.circular(TSizes.borderRadiusLg),
                      ),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          flex: 1,
                          child: Align(alignment: Alignment.centerLeft, child: Text('Name', style: headerTextStyle)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(alignment: Alignment.centerLeft, child: Text('Day', style: headerTextStyle)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(alignment: Alignment.centerLeft, child: Text('Date', style: headerTextStyle)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(alignment: Alignment.centerLeft, child: Text('In', style: headerTextStyle)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(alignment: Alignment.centerLeft, child: Text('Out', style: headerTextStyle)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(alignment: Alignment.center, child: Text('Status', style: headerTextStyle)),
                        ),
                      ],
                    ),
                  ),

                  // Rows dengan data dari database
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.data.length,
                    itemBuilder: (context, index) {
                      final item = widget.data[index];
                      final isHover = _hoverIndex == index;
                  
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
                  
                      return MouseRegion(
                        onEnter: (_) => setState(() => _hoverIndex = index),
                        onExit: (_) => setState(() => _hoverIndex = null),
                        child: Container(
                          color: isHover ? TColors.grey.withOpacity(0.04) : tableBackground,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: TSizes.lg),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(item['name']!, style: rowTextStyle),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(item['day']!, style: rowTextStyle),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(item['date']!, style: rowTextStyle),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(item['in']!, style: rowTextStyle),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(item['out']!, style: rowTextStyle),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: badgeBg,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: badgeText,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}