import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'view_details.dart';
import '../../widgets/cards.dart';
import '../../src/core/constants.dart';
import '../../src/helpers/sql_helper.dart';

class DeviceListPage extends StatefulWidget {
  @override
  _DeviceListPageState createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  List<Map<String, dynamic>> allDevices = [];
  List<Map<String, dynamic>> filteredDevices = [];

  TextEditingController searchController = TextEditingController();

  void _refreshList() async {
    final data = await SqlHelper.getItems();
    setState(() {
      allDevices = data;
      filteredDevices.addAll(allDevices);
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshList();
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
          'List of Diagnosed Devices',
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
                CardF(title: 'All Products', color: 'red', devices: '4'),
                CardF(title: 'Out of Stock', color: 'yellow', devices: '4'),
                CardF(title: 'Limited Stock', color: 'blue', devices: '4'),
                CardF(title: 'Other Stock', color: 'green', devices: '4'),
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
                  // Expanded(
                  //   flex: 0,
                  //   child: Text(
                  //     '#',
                  //     style: sectionTitleStyle.copyWith(fontSize: 15),
                  //   ),
                  // ),
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
                    index + 1, // Auto-numbering starting from 1
                    filteredDevices[index]['manufacturer'] + " " + filteredDevices[index]['model']!,
                    'assets/device2.jpg', // Image asset path
                    filteredDevices[index]["createdAt"]
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget _buildDeviceRow(int index, String phone, String imagePath, String date) {
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
            date.substring(0,11),
            style: TextStyle(fontSize: 14, color: darkGrey),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'A', // Placeholder for the Grade column
            style: TextStyle(fontSize: 14, color: darkGrey),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Action', // Placeholder for the Action column
            style: TextStyle(fontSize: 14, color: darkGrey),
          ),
        ),
      ],
    ),
  );
}

}
