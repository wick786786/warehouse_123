import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'sql_helper.dart';

class LogCat {
  static final Map<String, StreamController<int>> _progressControllers = {};

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
      List<Map<String, dynamic>> testResults = [];

      process.stdout.transform(Utf8Decoder()).listen((data) async {
        final regex = RegExp(r'1723263045@warehouse: ({.*})');
        final match = regex.firstMatch(data);

        if (match != null) {
          final jsonString = match.group(1)!;
          final Map<String, dynamic> jsonData = jsonDecode(jsonString);
          testResults.add(jsonData);

          // Increment progress
          progress=progress+5;
          _progressControllers[deviceId]?.add(progress);

          // Append the test result to the JSON file
          final file = File('logcat_results_$deviceId.json');

          // Check if the file exists
          if (await file.exists()) {
            // Read the existing content and append the new result
            final jsonContent = jsonDecode(await file.readAsString());
            jsonContent.add(jsonData);
            await file.writeAsString(jsonEncode(jsonContent), mode: FileMode.write);
          } else {
            // Create a new file and write the initial content
            await file.writeAsString(jsonEncode([jsonData]), mode: FileMode.write);
          }
        }
      });

      process.stderr.transform(Utf8Decoder()).listen((data) {
        print('Error: $data');
      });
    }).catchError((e) {
      print('Error starting logcat: $e');
    });
  }

  static void stopLogCat(String deviceId) {
    _progressControllers[deviceId]?.close();
    _progressControllers.remove(deviceId);
  }
}
