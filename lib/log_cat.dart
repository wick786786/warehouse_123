import 'dart:async';
import 'dart:convert';
import 'dart:io';

class LogCat {
  static final Map<String, StreamController<int>> _progressControllers = {};

  static Stream<int> getProgressStream(String deviceId) {
    if (!_progressControllers.containsKey(deviceId)) {
      _progressControllers[deviceId] = StreamController<int>.broadcast();
    }
    return _progressControllers[deviceId]!.stream;
  }

  static void startLogCat(String deviceId) {
    Process.start(
      'adb',
      ['-s', deviceId, 'logcat'],
      mode: ProcessStartMode.normal,
    ).then((process) {
      int progress = 0;

      process.stdout.transform(Utf8Decoder()).listen((data) {
        if (data.contains('Success 123')) {
          progress++;
          _progressControllers[deviceId]?.add(progress);
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
