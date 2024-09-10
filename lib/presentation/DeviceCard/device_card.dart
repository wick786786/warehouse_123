import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse_phase_1/presentation/DeviceCard/widgets/device_header.dart';
import 'package:warehouse_phase_1/presentation/DeviceCard/widgets/device_progress.dart';
import 'package:warehouse_phase_1/presentation/DeviceCard/widgets/device_status_section.dart';
import 'package:warehouse_phase_1/presentation/DeviceCard/widgets/emptycard.dart';
import 'package:warehouse_phase_1/presentation/DeviceCard/widgets/info_section.dart';
import 'package:warehouse_phase_1/presentation/pages/view_details.dart';
import 'dart:math';
import '../../src/helpers/log_cat.dart';
import '../../src/helpers/sql_helper.dart';

class DeviceCard extends StatefulWidget {
  final Map<String, String> device;
  final double? progress;
  
  const DeviceCard({super.key, required this.device,required this.progress});

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  final Map<String?, double> deviceProgress = {}; // Store progress per device
  late StreamSubscription<int> _progressSubscription;
  bool _isDevicePresent = false;
  bool _resultsSaved = false;
  bool _isConnected = true;

  @override
  void initState()  {
    super.initState();
    //_loadSavedProgress(); // Load saved progress when the widget initializes
    //_checkDevicePresence();
    //_isConnected = widget.device['isConnected'] == 'true'
   // _startLogCat();
   // _checkDevicePresence();
   presencecheck();
  }

  Future<void> presencecheck()async
  {
       final items = await SqlHelper.getItems();
    final deviceId = widget.device['id'] ?? '';
    _isDevicePresent = items.any((item) => item['sno'] == deviceId);
    print("is device present: $_isDevicePresent");

  }

  Future<void> _loadSavedProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = widget.device['id']!;
    final savedProgress = prefs.getInt('$deviceId-progress') ?? 0;
    print('mera saved:progress $savedProgress');
    setState(() {
      deviceProgress[widget.device['id']] = savedProgress / 100;
     // _startLogCat();
    });
  }

  void _resetPercent() {
    setState(() {
      deviceProgress[widget.device['id']] = 0;
    });
    // _saveProgress(0); // Reset the progress in SharedPreferences
  }
  Future<void> rebootDeviceToBootloader() async {
    String deviceId=widget.device['id']!;
  try {
    // Run the adb reboot bootloader command for a specific device
    final result = await Process.run(
      'adb',
      ['-s', deviceId, 'reboot', 'bootloader'],
    );

    // Check if the command was successful
    if (result.exitCode == 0) {
      print('Device $deviceId successfully rebooted to bootloader.');
    } else {
      print('Failed to reboot device $deviceId to bootloader. Error: ${result.stderr}');
    }
  } catch (e) {
    print('Error executing ADB command: $e');
  }
}


  Future<void> _checkDevicePresence() async {
    final items = await SqlHelper.getItems();
    final deviceId = widget.device['id'] ?? '';
    _isDevicePresent = items.any((item) => item['sno'] == deviceId);
    print("is device present: $_isDevicePresent");

    if(_isDevicePresent==false)
    {
      LogCat.startLogCat(deviceId);
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

      Map<String, dynamic>? details =
          await SqlHelper.getItemDetails(widget.device['id']);

      if (details != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeviceDetails(
              details: details,
              hardwareChecks: hardwareChecks,
            ),
          ),
        );
      } else {
        print('No details found for id: ${widget.device['id']}');
      }
    } else {
      print("No hardware checks found.");
    }
  }

  // void _startLogCat() async {
  //   String? id = widget.device['id'];
  //   if (id != null) {
  //     try {
  //       LogCat.startLogCat(id);

  //       _progressSubscription = LogCat.getProgressStream(id).listen((progress) async {
  //         if ( id == widget.device['id']) {
  //           setState(() {
  //             deviceProgress[id] = progress / 100;
  //           });

  //           if (deviceProgress[id] == 1.0 && !_resultsSaved) {
  //             _resultsSaved = true;
  //             await _saveResults();
  //           }
  //         }
  //       });
  //     } catch (e) {
  //       print('Error starting LogCat: $e');
  //     }
  //   }
  // }

  // Future<void> _saveResults() async {
  //   try {
  //     await SqlHelper.createItem(
  //       widget.device['manufacturer'] ?? '',
  //       widget.device['model'] ?? '',
  //       widget.device['imeiOutput'] ?? '',
  //       widget.device['serialNumber'] ?? '',
  //     );
  //     await LogCat.createJsonFile(widget.device['id']);
  //     print("JSON DEBUG");
  //   } catch (e) {
  //     print('Error saving results: $e');
  //   }
  // }

  // @override
  // void dispose()  {
  //  // _progressSubscription.cancel();
  //   LogCat.stopLogCat(oldWidget.device['id']!);
  //   print('disposed is called');
  //   // _startLogCat();
  //   super.dispose();

  // }
  // @override
  // void didUpdateWidget(DeviceCard oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   print('device being stopped:${oldWidget.device['id']}');
  //   LogCat.stopLogCat(oldWidget.device['id']!);
  // }

  String safeSubstring(String? value, int length) {
    if (value == null || value.length < length) {
      return value ?? 'N/A';
    }
    return value.substring(0, min(length, 6));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
  
    //double percent = deviceProgress[widget.device['id']] ?? 0.0;
    //  print('length in device card of device progress :${deviceProgress.length}');
    // print('percent in device card:${deviceProgress[widget.device['id']]}');
    //print("device card mai devices : ${widget.device['id']}");
    print('device presence in device card :$_isDevicePresent');
    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(minHeight: 200), // Set minimum height
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DeviceHeader(
                  manufacturer: widget.device['manufacturer'],
                  model: widget.device['model'],
                ),
                const SizedBox(height: 12),
                const Divider(thickness: 1.0),
                InfoSection(device: widget.device),
                const Divider(thickness: 1.0),
                const SizedBox(height: 12),
                DeviceStatusSection(device: widget.device),
                const SizedBox(height: 15),
                DeviceProgressSection(
                  progress: widget.progress,
                  isDevicePresent: _isDevicePresent,
                  onViewDetailsPressed: () => _loadHardwareChecks(context),
                  onResetPressed: _resetPercent,
                  //onDataWipe:rebootDeviceToBootloader()
                  onDataWipe: () async {
                  await rebootDeviceToBootloader();
                },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class DeviceCard extends StatefulWidget {
//   final Map<String, String> device;

//   DeviceCard({required this.device});

//   @override
//   _DeviceCardState createState() => _DeviceCardState();
// }

// class _DeviceCardState extends State<DeviceCard> {
//   double percent = 0;
//   late StreamSubscription<int> _progressSubscription;
//   bool _isDevicePresent = false;
//   bool _resultsSaved = false;

//   @override
//   void initState() {
//     super.initState();
//     _startLogCat();
//     _checkDevicePresence();
//   }

//   Future<void> _checkDevicePresence() async {
//     final items = await SqlHelper.getItems();
//     final deviceId = widget.device['id'] ?? '';
//     _isDevicePresent = items.any((item) => item['sno'] == deviceId);
//     if (!_isDevicePresent) {
//       _startLogCat();
//     } else {
//       setState(() {});
//     }
//     }  
//     void _resetPercent() {
//     setState(() {
//       percent = 0;
//     });
//   }

//   void _startLogCat() async {
//     String? id = widget.device['id'];
//     if (id != null) {
//       try {
//         LogCat.startLogCat(id);

//         _progressSubscription =
//             LogCat.getProgressStream(id).listen((progress) async {
//           setState(() {
//             percent = progress / 100;
//             _isDevicePresent = false;
//           });

//           if (percent == 1.0 && !_resultsSaved) {
//             _resultsSaved = true;
//             await _saveResults();
//           }
//         });
//       } catch (e) {
//         print('Error starting LogCat: $e');
//       }
//     }
//   }
//   Future<void> _loadHardwareChecks(BuildContext context) async {
//     final deviceId = widget.device['id'] ?? '';
//     final fileName = 'logcat_results_$deviceId.json';
//     final file = File(fileName);

//     if (await file.exists()) {
//       final jsonContent = await file.readAsString();
//       List<Map<String, dynamic>> hardwareChecks =
//           List<Map<String, dynamic>>.from(jsonDecode(jsonContent));

//       // Fetch the details from the database
//       Map<String, dynamic>? details = await SqlHelper.getItemDetails(widget.device['id']);
      

//       if (details != null) {
//         // Pass the details to the DeviceDetails widget
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DeviceDetails(
//               details: details,
//               hardwareChecks:
//                   hardwareChecks, // Make sure hardwareChecks is defined
//             ),
//           ),
//         );
//       } else {
//         // Handle the case where no details are found
//         print('No details found for iemiOrSno: ${widget.device['id']}');
//       }
//     } else {
//       print("No hardware checks found.");
//     }
//   }


//   Future<void> _saveResults() async {
//     try {
//       await SqlHelper.createItem(
//         widget.device['manufacturer'] ?? '',
//         widget.device['model'] ?? '',
//         widget.device['imeiOutput'] ?? '',
//         widget.device['serialNumber'] ?? '',
//       );
//       await LogCat.createJsonFile(widget.device['id']);
//     } catch (e) {
//       print('Error saving results: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _progressSubscription.cancel();
//     LogCat.stopLogCat(widget.device['id']!);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//         elevation: 6,
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               DeviceHeader(
//                 manufacturer: widget.device['manufacturer'],
//                 model: widget.device['model'],
//               ),
//               const SizedBox(height: 12),
//               const Divider(thickness: 1.0),
//               InfoSection(device: widget.device),
//               const Divider(thickness: 1.0),
//               const SizedBox(height: 12),
//               DeviceStatusSection(device: widget.device),
//               const SizedBox(height: 15),
//               DeviceProgressSection(
//                 percent: percent,
//                 isDevicePresent: _isDevicePresent,
//                 onViewDetailsPressed: () => _loadHardwareChecks(context),
//                 onResetPressed: _resetPercent,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }