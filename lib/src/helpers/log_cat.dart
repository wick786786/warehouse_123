import 'dart:async';
import 'dart:convert';
import 'dart:io';

class LogCat {
  static final Map<String, StreamController<int>> _progressControllers = {};
  static Map<String, List<Map<String, dynamic>>> testResults = {};
   static final Map<String, StreamController<void>> _restartControllers = {}; // For restart events

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

  static Stream<void> getRestartStream(String deviceId) {
    if (!_restartControllers.containsKey(deviceId)) {
      _restartControllers[deviceId] = StreamController<void>.broadcast();
    }
    return _restartControllers[deviceId]!.stream;
  }

  static void startLogCat(String deviceId) {
    print('debug:logcat $deviceId');
    Process.start(
      'adb',
      ['-s', deviceId, 'logcat'],
      mode: ProcessStartMode.normal,
    ).then((process) {
      int progress = 0;
      List<Map<String, dynamic>> deviceResult = [];

      process.stdout.transform(Utf8Decoder()).listen((data) async {
        if (data.contains('warehouse.start')) {
          progress = 0;
          _progressControllers[deviceId]?.add(0); 
          print('start');
          await clearDeviceLogs(deviceId);
        }
        if (data.contains('warehouse.restart')) {
          progress=0;
          _restartControllers[deviceId]?.add(null); // Notify restart event
          _progressControllers[deviceId]?.add(0); // Reset progress to 0
          print('restart');
          await clearDeviceLogs(deviceId);
          //return; // Early exit after reset
        }

        final regex = RegExp(r'1723263045@warehouse: ({.*})');
        final match = regex.firstMatch(data);

        if (match != null) {
          final jsonString = match.group(1)!;
          final Map<String, dynamic> jsonData = jsonDecode(jsonString);

          deviceResult.add(jsonData);

          // Increment progress
          progress += 5;
          _progressControllers[deviceId]?.add(progress);
        }

        testResults[deviceId] = deviceResult;
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
    _progressControllers[deviceId]?.close();
    _progressControllers.remove(deviceId);
  }
}
