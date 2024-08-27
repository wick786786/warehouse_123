import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:warehouse_phase_1/presentation/pages/view_details.dart';
import 'dart:math';
import '../src/helpers/launch_app.dart';
import '../src/helpers/log_cat.dart'; // Ensure LogCat class is imported
import '../src/helpers/sql_helper.dart';
import 'mdm_status.dart';

//import 'package:adb_client/crack-check/crack_detect.dart';

class DeviceCard extends StatefulWidget {
  final Map<String, String> device;

  DeviceCard({required this.device});

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  double percent = 0; // Default percent value
  late StreamSubscription<int> _progressSubscription;
  late StreamSubscription<void> _restartSubscription;
  bool _isDevicePresent = false;

  @override
  void initState() {
    super.initState();
    _startLogCat();
    _checkDevicePresence();
  }

  Future<void> _checkDevicePresence() async {
    final items = await SqlHelper.getItems();
    final deviceId = widget.device['id'] ?? '';
    _isDevicePresent = items.any((item) => item['sno'] == deviceId);
    if (!_isDevicePresent) {
      _startLogCat();
    } else {
      setState(() {}); // Trigger a rebuild if the device is found
    }
  }

  Future<void> _loadHardwareChecks(BuildContext context) async {
    final deviceId = widget.device['id'] ?? '';
    final fileName = 'logcat_results_$deviceId.json';
    final file = File(fileName);

    if (await file.exists()) {
      final jsonContent = await file.readAsString();
      List<Map<String, dynamic>> hardwareChecks =
          List<Map<String, dynamic>>.from(jsonDecode(jsonContent));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeviceDetails(
              details: widget.device, hardwareChecks: hardwareChecks),
        ),
      );
    } else {
      print("No hardware checks found.");
    }
  }

  void _startLogCat() async {
    String? id = widget.device['id'];
    if (id != null) {
      try {
        LogCat.startLogCat(id);
        //  _isDevicePresent=false;
        _progressSubscription = LogCat.getProgressStream(id).listen((progress) {
          setState(() {
            percent = progress / 100; // Assuming 100% is the max progress
             _isDevicePresent=false;
          });

          if (percent >= 1.0) {
            // LogCat.stopLogCat(widget.device['id']);
            _saveResults();
          }
        });

        // Listen for the restart event
        _restartSubscription = LogCat.getRestartStream(id).listen((_) {
          setState(() {
            percent = 0; 
            _isDevicePresent=false;// Reset progress to 0 on restart event
          });
          LogCat.clearDeviceLogs(id); // Clear logs when device restarts
        });
      } catch (e) {
        print('Error starting LogCat: $e');
      }
    }
  }

  Future<void> _saveResults() async {
    try {
      await SqlHelper.createItem(
        widget.device['manufacturer'] ?? '',
        widget.device['model'] ?? '',
        widget.device['imeiOutput'] ?? '',
        widget.device['serialNumber'] ?? '',
      );
      await LogCat.createJsonFile(widget.device['id']);
    } catch (e) {
      print('Error saving results: $e');
    }
  }

  @override
  void dispose() {
    _progressSubscription.cancel();
    _restartSubscription.cancel(); // Cancel the restart subscription
    LogCat.stopLogCat(widget.device['id']!);
    super.dispose();
  }

  void _startAnalysis() {
    // Implement your logic for starting analysis here
  }

  void _downloadReport() {
    // Implement your logic for downloading the report here
  }
  String safeSubstring(String? value, int length) {
    if (value == null || value.length < length) {
      return value ?? 'N/A';
    }
    return value.substring(0, min(length, 6));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;
    final Color whiteColor = theme.colorScheme.onPrimary;
    final TextStyle deviceCardTitle =
        theme.textTheme.headlineSmall ?? TextStyle();
    final TextStyle deviceDetails = theme.textTheme.bodySmall ?? TextStyle();

    return SingleChildScrollView(
      child: Container(
        child: Card(
          color: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 6,
          shadowColor: Colors.black26,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.2),
                      child: Icon(Icons.android, color: primaryColor),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "${safeSubstring(widget.device['manufacturer'], widget.device['manufacturer']!.length)} ${safeSubstring(widget.device['model'], widget.device['model']!.length)}",
                        style: deviceCardTitle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                const Divider(
                  color: Color(0xFFDCD1D1),
                  thickness: 1.5,
                  height: 20.0,
                  indent: 0.0,
                  endIndent: 0.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      _buildInfoRow(
                          'Model', widget.device['model'] ?? 'N/A', theme),
                      _buildInfoRow('Manufacturer',
                          widget.device['manufacturer'] ?? 'N/A', theme),
                      _buildInfoRow('Version',
                          widget.device['androidVersion'] ?? 'N/A', theme),
                      _buildInfoRow('Serial No.',
                          widget.device['serialNumber'] ?? 'N/A', theme),
                      _buildInfoRow(
                          'IMEI', widget.device['imeiOutput'] ?? 'N/A', theme),
                    ],
                  ),
                ),
                const Divider(
                  color: Color(0xFFDCD1D1),
                  thickness: 1.5,
                  height: 20.0,
                  indent: 0.0,
                  endIndent: 0.0,
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          MdmStatus(status: widget.device['mdm_status']),
                          Text(
                            'MDM',
                            style: deviceDetails.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        children: [
                          Icon(Icons.battery_6_bar_rounded,
                              color: primaryColor),
                          Text(
                            widget.device['batterylevel']!.substring(
                                    min(widget.device['batterylevel']!.length,
                                        7),
                                    widget.device['batterylevel']!.length) ??
                                'N/A',
                            style: deviceDetails.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        children: [
                          Text(
                            '${widget.device['ram']}',
                            style: deviceDetails.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                          Text(
                            'RAM',
                            style: deviceDetails.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                if (percent >=0 && percent < 1.0 && !_isDevicePresent)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LinearProgressIndicator(
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green.shade400),
                        value: percent,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(percent * 100).round()}/100',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  )
                else if(_isDevicePresent||percent==1.0)
                  Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),

                          Text('Testing complete'),

                          // Icon(Icons.delete)
                        ],
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () async {
                          await _loadHardwareChecks(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Colors.green, // Set your preferred button color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                          ),
                          // minimumSize: const Size(100, 40), // Define the size of the button
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12), // Padding inside the button
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(color: Colors.white), // Text color
                        ),
                      ),
                    ],
                  ),

                //  SizedBox(width:20),
                //  Text('Completed')

                // ElevatedButton.icon(
                //   onPressed: _downloadReport,
                //   icon: Icon(Icons.done, color: Colors.white),
                //   label: Text(
                //     'Start Crack Check',
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //   ),
                //   style: ElevatedButton.styleFrom(
                //     //primary: Colors.green,
                //     // onPrimary: Colors.white,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8.0),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 16,
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
