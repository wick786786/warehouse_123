import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:process_run/stdio.dart';
import 'package:sqflite/sqflite.dart';

import 'package:warehouse_phase_1/presentation/pages/DeviceListPage/widgets/device_row.dart';
import 'package:warehouse_phase_1/presentation/pages/DeviceListPage/widgets/stats.dart';
import '../view_details.dart';

import '../../../src/core/constants.dart';
import '../../../src/helpers/sql_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeviceListPage extends StatefulWidget {
  const DeviceListPage({super.key});

  @override
  _DeviceListPageState createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  List<Map<String, dynamic>> allDevices = [];
  List<Map<String, dynamic>> filteredDevices = [];
  late List<Map<String, dynamic>> hardwareChecks;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void refreshList() async {
    final data = await SqlHelper.getItems();
    setState(() {
      allDevices = data;
      filteredDevices.clear();
      filteredDevices.addAll(allDevices);
    });
  }

  Future<void> _loadHardwareChecks(String deviceId) async {
    final fileName = 'logcat_results_$deviceId.json';
    final file = File(fileName);

    if (await file.exists()) {
      final jsonContent = await file.readAsString();
      hardwareChecks = List<Map<String, dynamic>>.from(jsonDecode(jsonContent));
    } else {
      hardwareChecks = [];
    }
  }

  void filterSearchResults(String query) {
    List<Map<String, dynamic>> dummySearchList = [];
    dummySearchList.addAll(allDevices);
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> dummyListData = [];
      for (var item in dummySearchList) {
        if ((item['manufacturer'] + " " + item['model'])!
            .toLowerCase()
            .contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        filteredDevices.clear();
        filteredDevices.addAll(dummyListData);
      });
    } else {
      setState(() {
        filteredDevices.clear();
        filteredDevices.addAll(allDevices);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;
    final Color backgroundColor = theme.colorScheme.surface;
    final Color surfaceColor = theme.colorScheme.surface;
    final Color onSurfaceColor = theme.colorScheme.onSurface;
    final TextStyle titleStyle = theme.textTheme.titleLarge
            ?.copyWith(color: theme.colorScheme.onPrimary) ??
        const TextStyle();
    final TextStyle sectionTitleStyle = theme.textTheme.titleMedium
            ?.copyWith(color: theme.colorScheme.onSurface) ??
        const TextStyle();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.list,
          style: titleStyle,
        ),
        backgroundColor: primaryColor,
        actions: [
          Container(
            width: 200,
            height: 40,
            margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Phone',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: theme.dividerColor,
                    width: 1,
                  ),
                ),
                suffixIcon: Icon(
                  Icons.search,
                  color: primaryColor,
                ),
              ),
              onChanged: filterSearchResults,
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatsCard(
                    title: AppLocalizations.of(context)!.all_items,
                    color: 'red',
                    devices: '4'),
                StatsCard(
                    title: AppLocalizations.of(context)!.out_of_stock,
                    color: 'yellow',
                    devices: '4'),
                StatsCard(
                    title: AppLocalizations.of(context)!.limited_stocks,
                    color: 'blue',
                    devices: '4'),
                StatsCard(
                    title: AppLocalizations.of(context)!.other_stocks,
                    color: 'green',
                    devices: '4'),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: onSurfaceColor.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1.5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Phone',
                      style: sectionTitleStyle.copyWith(fontSize: 15),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Date',
                      style: sectionTitleStyle.copyWith(fontSize: 15),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Grade',
                      style: sectionTitleStyle.copyWith(fontSize: 15),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Action',
                      style: sectionTitleStyle.copyWith(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDevices.length,
                itemBuilder: (context, index) {
                  return DeviceRow(
                    index: index + 1,
                    phone: filteredDevices[index]['manufacturer'] +
                        " " +
                        filteredDevices[index]['model']!,
                    imagePath: 'assets/device2.jpg',
                    date: filteredDevices[index]["createdAt"],
                    details: filteredDevices[index],
                    refreshListCallback: refreshList,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
