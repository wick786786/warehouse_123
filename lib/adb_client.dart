import 'dart:async';
import 'dart:convert';
import 'dart:io';

class AdbClient {
  Future<List<String>> listDevices() async {
    ProcessResult result = await Process.run('adb', ['devices']);
    if (result.exitCode != 0) {
      return [];
    }

    List<String> lines = LineSplitter.split(result.stdout.toString()).toList();
    lines.removeAt(0); // Remove the first line 'List of devices attached'

    List<String> devices = [];
    for (String line in lines) {
      if (line.trim().isEmpty) {
        continue;
      }
      devices.add(line.split('\t')[0]);
    }
    return devices;
  }

  Future<String> executeShellCommand(String deviceId, String command) async {
    ProcessResult result = await Process.run('adb', ['-s', deviceId, 'shell', command]);
    if (result.exitCode != 0) {
      return '';
    }
    return result.stdout.toString().trim();
  }

  Future<Map<String, String>> getDeviceDetails(String deviceId) async {
    final model = await executeShellCommand(deviceId, 'getprop ro.product.model');
    final manufacturer = await executeShellCommand(deviceId, 'getprop ro.product.manufacturer');
    final androidVersion = await executeShellCommand(deviceId, 'getprop ro.build.version.release');
    final serialNumber = await executeShellCommand(deviceId, 'getprop ro.serialno');
    final imeiOutput = await executeShellCommand(deviceId, 'service call iphonesubinfo 1 s16 com.android.shell | cut -c 50-64 | tr -d \'.[:space:]\'');
    
    return {
      'model': model,
      'manufacturer': manufacturer,
      'androidVersion': androidVersion,
      'serialNumber': serialNumber,
      'imeiOutput': imeiOutput.replaceAll("'", '')
    };
  }
}
