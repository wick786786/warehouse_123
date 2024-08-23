
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


class DeviceCard2 extends StatefulWidget {
  final Map<String, String> device;
  final VoidCallback onStartAgain;

  DeviceCard2({required this.device,required this.onStartAgain});

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard2> {
  // double percent = 0; // Default percent value
  // late StreamSubscription<int> _progressSubscription;

  // @override
  // void initState() {
  //   super.initState();
  //   _startLogCat();
  // }

  // void _startLogCat() async {
  //   String? id = widget.device['id'];
  //   print('debug : device card ${widget.device['id']}');
  //   if (id != null) {
  //     try {
  //       LogCat.startLogCat(id);

  //       _progressSubscription =
  //           LogCat.getProgressStream(id).listen((progress) async {
  //         setState(() {
  //           percent = progress / 100; // Assuming 100% is the max progress
  //         });
  //         print("my debug $percent");
  //         if (percent >= 1.0) {
  //           print("my debug");
  //           LogCat.stopLogCat(widget.device['id']);
  //           try {
  //             await SqlHelper.createItem(
  //               widget.device['manufacturer'] ?? '',
  //               widget.device['model'] ?? '',
  //               widget.device['imeiOutput'] ?? '',
  //               widget.device['serialNumber'] ?? '',
  //             );
  //             await LogCat.createJsonFile(widget.device['id']);
  //             print("my id : $id");
  //           } catch (e) {
  //             print('Error creating item: $e');
  //           }
  //         }
  //       });
  //     } catch (e) {
  //       print('Error starting LogCat: $e');
  //     }
  //   }
  // }

// common function used in device card and device card 2
  Future<void> _loadHardwareChecks(BuildContext context) async {
    final deviceId = widget.device['id'] ?? '';
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
          builder: (context) => DeviceDetails(details: widget.device, hardwareChecks: hardwareChecks),
        ),
      );
    } else {
      print("No hardware checks found.");
    }
  }

  @override
  // void dispose() {
  //   _progressSubscription.cancel();
  //   LogCat.stopLogCat(widget.device['id']!);
  //   super.dispose();
  // }

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
          color: Colors.grey,
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
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          child: const Icon(Icons.android, color: Colors.black),
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
                        "${(widget.device['manufacturer'])} ${(widget.device['model'])}",
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
                          const Icon(Icons.battery_6_bar_rounded,
                              color: Colors.black),
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
                   Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                     children: [
                        ElevatedButton(
                          onPressed:widget.onStartAgain ,
                          child: const Text('Start Again',style: TextStyle(color: Colors.green),),
                        ),

                        
                        TextButton(
                          onPressed:() async {
                            await _loadHardwareChecks(context);
                          } ,
                          child: const Text('View Details',style: TextStyle(color: Color.fromARGB(255, 10, 41, 67)),),
                        ),

                       // Icon(Icons.delete)
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