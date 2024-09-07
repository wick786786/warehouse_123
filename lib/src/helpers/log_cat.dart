import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:warehouse_phase_1/presentation/pages/homepage/widgets/device_manage.dart';
import 'package:warehouse_phase_1/src/helpers/sql_helper.dart';

class LogCat {
  static final Map<String, StreamController<int>> _progressControllers = {};
  static final Map<String, int> _deviceProgress =
      {}; // Track progress values separately
     // static bool device_check=false;
  static Map<String, List<Map<String, dynamic>>> testResults = {};
  static final Map<String, StreamController<void>> _restartControllers =
      {}; // For restart events

  static Stream<int> getProgressStream(String deviceId) {
    if (!_progressControllers.containsKey(deviceId)) {
      _progressControllers[deviceId] = StreamController<int>.broadcast();
      _deviceProgress[deviceId] = 0; // Initialize progress
    }
    return _progressControllers[deviceId]!.stream;
  }

  static Future<void> clearDeviceLogs(String deviceId) async {
    try {
      // Run the adb command to clear the logs
      ProcessResult result = await Process.run(
        'adb',
        ['-s', deviceId, 'logcat', '-c'],
      );

      if (result.exitCode == 0) {
        print('Logs cleared successfully on device $deviceId');
        return;
      } else {
        print('Failed to clear logs: ${result.stderr}');
        return;
      }
    } catch (e) {
      print('Error occurred while clearing logs: $e');
    }
  }

  static Stream<void> getRestartStream(String deviceId) {
    if (!_restartControllers.containsKey(deviceId)) {
      _restartControllers[deviceId] = StreamController<void>.broadcast();
    }
    return _restartControllers[deviceId]!.stream;
  }
  static Future<bool> presenceCheck(String deviceId)async
  {
       final items = await SqlHelper.getItems();
     
     return  items.any((item) => item['sno'] == deviceId);
    //print("is device present: $_isDevicePresent");
    //return device_check;

  }

  static void startLogCat(String deviceId) {
    print('debug:logcat $deviceId');
    Process.start(
      'adb',
      ['-s', deviceId, 'logcat'],
      mode: ProcessStartMode.normal,
    ).then((process) {
      List<Map<String, dynamic>> deviceResult = [];
      Map<String, dynamic> jsonData = {};
      bool restart = false;
      String jsonString = "";
      process.stdout.transform(Utf8Decoder()).listen((data) async {
        if (data.contains('warehouse.start')||data.contains('warehouse.restart')) {
          await clearDeviceLogs(deviceId);
          bool val=await presenceCheck(deviceId);
          if(val==true)
          {
              await SqlHelper.deleteItemwithId(deviceId);
              await deleteJsonFile(deviceId);
          }
          await DeviceProgressManager.resetProgress(deviceId);
          _deviceProgress[deviceId] = 0;
          _progressControllers[deviceId]?.add(0);
          print('start');
          
          //deviceResult.clear();
          //jsonData.clear();
          
          //await clearDeviceLogs(deviceId);
          
        }
        // if (data.contains('warehouse.restart')) {
        //   restart = true;
        //   // await clearDeviceLogs(deviceId);
        //   // print('json data after clear log :${jsonData}');
        //   // print('json String after clear log :${jsonString}');
        //   // _deviceProgress[deviceId] = 0;
        //   // _progressControllers[deviceId]?.add(0); // Reset progress to 0
        //    _deviceProgress[deviceId] = 0;
        //   _progressControllers[deviceId]?.add(0);

        //   await SqlHelper.deleteItemwithId(deviceId);
        //   print('after restart');
        // }

        // if (data.contains('warehouse.final')) {
        //   print("finished");
        // }

        final regex = RegExp(r'1723263045@warehouse: ({.*})');
        final match = regex.firstMatch(data);
        //print("match : $match");
        if (match != null) {
         final jsonString = match.group(1)!;
          // print("json string $jsonString");
          jsonData = jsonDecode(jsonString);
          if (restart == true) {
            print("json result after restart : $jsonData");
          }

          deviceResult.add(jsonData);

          if(jsonData.length*5>=85)
          {
               _deviceProgress[deviceId]=(jsonData.length * 5)-5;
          }
          // Increment progress
          else{
          _deviceProgress[deviceId] = jsonData.length * 5;
          }
          _progressControllers[deviceId]?.add(_deviceProgress[deviceId]!);
        }

        testResults[deviceId] = deviceResult;
        print("test result :$testResults");
      });

      process.stderr.transform(Utf8Decoder()).listen((data) {
        print('Error: $data');
      });
    }).catchError((e) {
      print('Error starting logcat: $e');
    });
  }

  static Future<void> createJsonFile(String? deviceId) async {
    try {
      if (testResults.containsKey(deviceId)) {
        final List<Map<String, dynamic>> newResults = testResults[deviceId]!;
        final String fileName = 'logcat_results_$deviceId.json';
        final File file = File(fileName);
        Map<String, dynamic> existingData = {};

        // Check if the file already exists
        if (await file.exists()) {
          // Load existing data from the file
          final String existingContent = await file.readAsString();
          List<dynamic> existingJsonList = jsonDecode(existingContent);

          // Merge existing data with new results
          for (var item in existingJsonList) {
            item.forEach((key, value) {
              existingData[key] = value;
            });
          }
        }

        // Update the existing data with new results
        for (var result in newResults) {
          result.forEach((key, value) {
            existingData[key] = value; // Update value if key exists
          });
        }

        // Convert the merged data back to a list of maps
        List<Map<String, dynamic>> finalData =
            existingData.entries.map((entry) {
          return {entry.key: entry.value};
        }).toList();

        // Write the merged data back to the file
        await file.writeAsString(jsonEncode(finalData), mode: FileMode.write);

        print('JSON file updated: $fileName');
      } else {
        print('No test results found for device ID: $deviceId');
      }
    } catch (e) {
      print('Error creating/updating JSON file: $e');
    }
  }

  static Future<void> deleteJsonFile(String? deviceId) async {
    try {
      final String fileName = 'logcat_results_$deviceId.json';
      final File file = File(fileName);

      // Check if the file exists before deleting
      if (await file.exists()) {
        await file.delete();
        print('JSON file deleted: $fileName');
      } else {
        print('JSON file not found: $fileName');
      }
    } catch (e) {
      print('Error deleting JSON file: $e');
    }
  }

  static void stopLogCat(String? deviceId) {
    if (deviceId == null) return;

    print("removed device id in log $deviceId");
    _progressControllers[deviceId]?.close();
    _progressControllers.remove(deviceId);
    // _deviceProgress.remove(deviceId);
  }
}
