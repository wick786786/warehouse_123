import 'package:flutter/material.dart';
import 'view_details.dart';
import 'cards.dart';
import 'constants.dart';

class DeviceListPage extends StatefulWidget {
  @override
  _DeviceListPageState createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  List<Map<String, String>> allDevices = [
    {'phone': 'One Plus Nord', 'date': '2024-07-20', 'grade': 'A', 'action': 'View Details'},
    {'phone': 'One Plus CE', 'date': '2024-07-19', 'grade': 'B', 'action': 'View Details'},
    {'phone': 'Phone 3', 'date': '2024-07-18', 'grade': 'A+', 'action': 'View Details'},
    // Add more devices here
  ];

  List<Map<String, String>> filteredDevices = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDevices.addAll(allDevices);
  }

  void filterSearchResults(String query) {
    List<Map<String, String>> dummySearchList = [];
    dummySearchList.addAll(allDevices);
    if (query.isNotEmpty) {
      List<Map<String, String>> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item['phone']!.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredDevices.clear();
        filteredDevices.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        filteredDevices.clear();
        filteredDevices.addAll(allDevices);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List of Diagnosed Devices',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          Container(
            width: 200,
            height: 40,
            margin: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.greyColor.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search Phone',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search, color: AppColors.primaryColor),
                          onPressed: () {
                            filterSearchResults(searchController.text);
                          },
                        ),
                      ),
                      onChanged: filterSearchResults,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.secondaryColor,
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
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greyColor.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 0,
                    child: Text(
                      '#',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Phone',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Grade',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Action',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.greyColor.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: filteredDevices.length,
                  itemBuilder: (context, index) {
                    return _buildDeviceRow(
                      index + 1, // Auto-numbering starting from 1
                      filteredDevices[index]['phone']!,
                      filteredDevices[index]['date']!,
                      filteredDevices[index]['grade']!,
                      filteredDevices[index]['action']!,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceRow(int index, String phone, String date, String grade, String action) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 0,
            child: Text(
              '$index. ',
              style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              phone,
              style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              date,
              style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              grade,
              style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // Handle action button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeviceDetails()),
                  );
                },
                child: Text(
                  action,
                  style: TextStyle(fontSize: 14, color: AppColors.primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
