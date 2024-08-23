import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:warehouse_phase_1/src/helpers/sql_helper.dart';

class LogCat {
  static final Map<String, StreamController<int>> _progressControllers = {};
  static Map<String, List<Map<String, dynamic>>> testResults = {};
  static Map<String,bool>restart={};
  
  static Stream<int> getProgressStream(String deviceId) {
    if (!_progressControllers.containsKey(deviceId)) {
      _progressControllers[deviceId] = StreamController<int>.broadcast();
    }
    return _progressControllers[deviceId]!.stream;
  }

 static  Future<void> clearDeviceLogs(String deviceId) async {
  try {
    // Run the adb command to clear the logs
    ProcessResult result = await Process.run(
      'adb',
      ['-s', deviceId, 'logcat', '-c'],
    );

    if (result.exitCode == 0) {
      print('Logs cleared successfully on device $deviceId');
    } else {
      print('Failed to clear logs: ${result.stderr}');
    }
  } catch (e) {
    print('Error occurred while clearing logs: $e');
  }
}


static void startLogCat(String deviceId) {
  print('Starting logcat for device: $deviceId');

  Timer? timer;
  Process? process;

  void startLogcatProcess() async {
    print('debug:logcat $deviceId');

    try {
      process = await Process.start(
        'adb',
        ['-s', deviceId, 'logcat'],
        mode: ProcessStartMode.normal,
      );

      int progress = 0;
      List<Map<String, dynamic>> deviceResult = [];

      process!.stdout.transform(Utf8Decoder()).listen((data) async {
        if (data.contains('warehouse.start')) {
          progress = 0;
          _progressControllers[deviceId]?.add(progress);
          await clearDeviceLogs(deviceId);
        }
        if (data.contains('warehouse.restart')) {
          progress = 0;
          print('restart mai swagat hai aapka');
          _progressControllers[deviceId]?.add(progress);
          testResults[deviceId]?.clear();
          await clearDeviceLogs(deviceId);
          await SqlHelper.deleteItemwithId(deviceId);
          print('Restarting the process for device $deviceId');
        }

        final regex = RegExp(r'1723263045@warehouse: ({.*})');
        final match = regex.firstMatch(data);

        if (match != null) {
          final jsonString = match.group(1)!;
          final Map<String, dynamic> jsonData = jsonDecode(jsonString);
          deviceResult.add(jsonData);

          progress = progress + 5;
          _progressControllers[deviceId]?.add(progress);
        }

        testResults[deviceId] = deviceResult;
        // print("device results:${deviceResult}");
      });

      process!.stderr.transform(Utf8Decoder()).listen((data) {
        print('Error: $data');
      });
    } catch (e) {
      print('Error starting logcat: $e');
    }
  }

  void checkDeviceConnection() async {
    try {
      final result = await Process.run('adb', ['devices']);
      if (result.stdout.contains(deviceId)) {
        if (process == null) {
          startLogcatProcess();
        }
      } else {
        print('Device $deviceId disconnected.');
        process?.kill();
        process = null;
      }
    } catch (e) {
      print('Error checking device connection: $e');
    }
  }

  // Check the device connection status every 5 seconds
  timer = Timer.periodic(Duration(seconds: 2), (_) => checkDeviceConnection());
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
        List<Map<String, dynamic>> finalData = existingData.entries.map((entry) {
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
    _progressControllers[deviceId]?.close();
    _progressControllers.remove(deviceId);
  }
}
