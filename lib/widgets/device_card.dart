import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:warehouse_phase_1/presentation/pages/view_details.dart';
import 'package:warehouse_phase_1/src/helpers/device_row.dart';
import 'dart:math';
import '../src/helpers/launch_app.dart';
import '../src/helpers/log_cat.dart'; // Ensure LogCat class is imported
import '../src/helpers/sql_helper.dart';
import 'mdm_status.dart';
import 'package:warehouse_phase_1/crack-check/crack_detect.dart';

class DeviceCard extends StatefulWidget {
  final Map<String, String> device;

  DeviceCard({required this.device});

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  double percent = 0; // Default percent value
  late StreamSubscription<int> _progressSubscription;
  bool _isDevicePresent = false;

  @override
  void initState() {
    super.initState();
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

 void _startLogCat() async {
  String? id = widget.device['id'];
  if (id != null) {
    try {
      LogCat.startLogCat(id);

      _progressSubscription =
          LogCat.getProgressStream(id).listen((progress) async {
        setState(() {
          percent = progress / 100; // Assuming 100% is the max progress
        });
        if (percent >= 1.0) {
        
          LogCat.stopLogCat(widget.device['id']);
          try {
            await SqlHelper.createItem(
              widget.device['manufacturer'] ?? '',
              widget.device['model'] ?? '',
              widget.device['imeiOutput'] ?? '',
              widget.device['serialNumber'] ?? '',
            );
            await LogCat.createJsonFile(widget.device['id']);
          } catch (e) {
            print('Error creating item: $e');
          }
        }
      });
    } catch (e) {
      print('Error starting LogCat: $e');
    }
  }
}
  void _resetDeviceCard() async {
    setState(() {
      percent = 0;
      _isDevicePresent = false;
    });
    await LogCat.clearDeviceLogs(widget.device['id']!);
    _startLogCat(); // Restart log capturing if needed
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

  @override
  void dispose() {
    _progressSubscription.cancel();
    if (widget.device['id'] != null) {
      LogCat.stopLogCat(widget.device['id']!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;
    final Color whiteColor = theme.colorScheme.onPrimary;
    final Color secondaryColor = theme.colorScheme.secondary;
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
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: primaryColor.withOpacity(0.2),
                          child: Icon(Icons.android, color: primaryColor),
                        ),
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.cardColor,
                                width: 1.5,
                              ),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Center(
                              child: Text(
                                '${widget.device['androidVersion']}',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "${widget.device['manufacturer']} ${widget.device['model']}",
                        style: deviceCardTitle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_isDevicePresent)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/completed_Stamp.png',
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
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
                            widget.device['batterylevel']?.substring(
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
                if ((!_isDevicePresent) && percent < 1.0)
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
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),

                     
                       
                      TextButton(
                        onPressed: () async {
                          await _loadHardwareChecks(context);
                        },
                        child: Text('View Details'),
                      ),
                    ],
                  ),
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
