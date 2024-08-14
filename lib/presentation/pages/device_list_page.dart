import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:process_run/stdio.dart';
import 'package:sqflite/sqflite.dart';
import 'view_details.dart';
import '../../widgets/cards.dart';
import '../../src/core/constants.dart';
import '../../src/helpers/sql_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeviceListPage extends StatefulWidget {
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
    _refreshList();
  }

  void _refreshList() async {
    final data = await SqlHelper.getItems();
    setState(() {
      allDevices = data;
      filteredDevices.clear();
      filteredDevices.addAll(allDevices);
    });
  }

  Future<void> _loadHardwareChecks(String deviceId) async {
    final fileName = 'logcat_results_$deviceId.json';
     print(" fileName:$fileName");
    final file = File(fileName);

    if (await file.exists()) {
      final jsonContent = await file.readAsString();
      print(" json content :$jsonContent");
      hardwareChecks = List<Map<String, dynamic>>.from(jsonDecode(jsonContent));
      print("hardwarecheck 1 :$hardwareChecks");
    } else {
      hardwareChecks = [];
    }
  }

  void filterSearchResults(String query) {
    List<Map<String, dynamic>> dummySearchList = [];
    dummySearchList.addAll(allDevices);
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> dummyListData = [];
      dummySearchList.forEach((item) {
        if ((item['manufacturer'] + " " + item['model'])!
            .toLowerCase()
            .contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
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
    final Color backgroundColor = theme.colorScheme.background;
    final Color surfaceColor = theme.colorScheme.surface;
    final Color onSurfaceColor = theme.colorScheme.onSurface;
    final TextStyle titleStyle = theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary) ?? TextStyle();
    final TextStyle sectionTitleStyle = theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface) ?? TextStyle();

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
            margin: EdgeInsets.only(right: 16),
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
            icon: const Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CardF(title: AppLocalizations.of(context)!.all_items, color: 'red', devices: '4'),
                CardF(title: AppLocalizations.of(context)!.out_of_stock, color: 'yellow', devices: '4'),
                CardF(title: AppLocalizations.of(context)!.limited_stocks, color: 'blue', devices: '4'),
                CardF(title: AppLocalizations.of(context)!.other_stocks, color: 'green', devices: '4'),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: onSurfaceColor.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1.5),
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
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDevices.length,
                itemBuilder: (context, index) {
                  return _buildDeviceRow(
                    index + 1,
                    filteredDevices[index]['manufacturer'] + " " + filteredDevices[index]['model']!,
                    'assets/device2.jpg',
                    filteredDevices[index]["createdAt"],
                    filteredDevices[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceRow(int index, String phone, String imagePath, String date, Map<String, dynamic> details) {
    final ThemeData theme = Theme.of(context);
    final Color darkGrey = theme.colorScheme.onSurface;
    final Color rowColor = theme.brightness == Brightness.dark ? theme.colorScheme.surface : Colors.white;

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: rowColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: darkGrey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              '$phone',
              style: TextStyle(fontSize: 14, color: darkGrey),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              date.substring(0, 11),
              style: TextStyle(fontSize: 14, color: darkGrey),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'A',
              style: TextStyle(fontSize: 14, color: darkGrey),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                TextButton(
                  child: Text('View Details'),
                  onPressed: () async {
                    final deviceId = details['id'].toString();
                    print('details ${details}');
                    print('device id :${deviceId}');
                    await _loadHardwareChecks(details['sno']);
                    print('hardware chrcks: $hardwareChecks');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeviceDetails(details: details, hardwareChecks: hardwareChecks),
                      ),
                    );
                  },
                ),
                SizedBox(width: 30),
               IconButton(
  onPressed: () async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when "No" is pressed
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true when "Yes" is pressed
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      print('Debug: Delete item with id ${details['id']}');
      await SqlHelper.deleteItem(details['id']);
      _refreshList(); // Refresh the list after deletion
    }
  },
  icon: Icon(Icons.delete),
),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
