import 'dart:async';
import 'dart:convert';
import 'dart:io';

class LogCat {
  static final Map<String, StreamController<int>> _progressControllers = {};
  static Map<String, List<Map<String, dynamic>>> testResults = {};

  static Stream<int> getProgressStream(String deviceId) {
    if (!_progressControllers.containsKey(deviceId)) {
      _progressControllers[deviceId] = StreamController<int>.broadcast();
    }
    return _progressControllers[deviceId]!.stream;
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
        print("test results:${testResults[deviceId]}");
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

  static void stopLogCat(String deviceId) {
    _progressControllers[deviceId]?.close();
    _progressControllers.remove(deviceId);
  }
}
