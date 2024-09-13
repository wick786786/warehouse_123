import 'package:flutter/material.dart';
import 'package:warehouse_phase_1/presentation/pages/view_details.dart';
import 'package:warehouse_phase_1/src/helpers/log_cat.dart';
import 'package:warehouse_phase_1/src/helpers/sql_helper.dart';
import 'dart:io';
import 'dart:convert';


class DeviceRow extends StatelessWidget {
  final int index;
  final String phone;
  final String imagePath;
  final String date;
  final Map<String, dynamic> details;
  final Function refreshListCallback;

  const DeviceRow({
    required this.index,
    required this.phone,
    required this.imagePath,
    required this.date,
    required this.details,
     required this.refreshListCallback,
    super.key,
  });

  Future<void> _loadHardwareChecks(BuildContext context, String deviceId) async {
    final fileName = 'logcat_results_$deviceId.json';
    print(" fileName:$fileName");
    final file = File(fileName);

    if (await file.exists()) {
      final jsonContent = await file.readAsString();
      print(" json content :$jsonContent");
      List<Map<String, dynamic>> hardwareChecks = List<Map<String, dynamic>>.from(jsonDecode(jsonContent));
      print("hardwarecheck 1 :$hardwareChecks");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeviceDetails(details: details, hardwareChecks: hardwareChecks),
        ),
      );
    } else {
      print("No hardware checks found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color darkGrey = theme.colorScheme.onSurface;
    final Color rowColor = theme.brightness == Brightness.dark ? theme.colorScheme.surface : Colors.white;

    Future<void>viewDetails()async
    {

        final deviceId = details['id'].toString();
        await _loadHardwareChecks(context, details['sno']);

    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: rowColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: darkGrey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
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
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              phone,
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
              details['iemi']??'N/A',
              style: TextStyle(fontSize: 14, color: darkGrey),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                TextButton(
                  child: const Text('View Details'),
                  onPressed: () async {
                    viewDetails();
                  },
                ),
                const SizedBox(width: 30),
                IconButton(
                  onPressed: () async {
                    bool? confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text('Are you sure you want to delete this item?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('No'),
                              onPressed: () {
                                Navigator.of(context).pop(false); // Return false when "No" is pressed
                              },
                            ),
                            TextButton(
                              child: const Text('Yes'),
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
                      await SqlHelper.deleteItemwithId(details['sno']);
                      await LogCat.deleteJsonFile(details['sno']);
                      refreshListCallback(); // Refresh the list after deletion
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
