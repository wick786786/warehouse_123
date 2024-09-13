import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart'; // To get the temporary directory
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';


class LaunchApp extends StatelessWidget {
  const LaunchApp({super.key});

  Future<File> extractApkFromAssets() async {
    // Load the APK from the assets
    ByteData data = await rootBundle.load('assets/warehouse.apk');

    // Get the temporary directory
    Directory tempDir = await getTemporaryDirectory();

    // Define the path for the APK file
    String apkPath = path.join(tempDir.path, 'Warehouse.apk');

    // Write the APK to the temporary directory
    File apkFile = File(apkPath);
    await apkFile.writeAsBytes(data.buffer.asUint8List());

    return apkFile;
  }
  
  Future<String> launchApplication(String deviceId, String packageName, String mainActivity) async {
  try {
    // Extract the APK from assets to the temporary directory
    File apkFile = await extractApkFromAssets();

    // Check if the APK file was successfully extracted
    if (!apkFile.existsSync()) {
      return 'Failed to extract APK file from assets.';
    }

    String apkPath = apkFile.path;

    // Check if the app is installed
    ProcessResult checkResult = await Process.run('adb', ['-s', deviceId, 'shell', 'pm', 'list', 'packages', packageName]);

    if (checkResult.stdout.toString().contains(packageName)) {
      print('App is already installed.');
    } else {
      print('Installing app...');
      ProcessResult installResult = await Process.run('adb', ['-s', deviceId, 'install', apkPath]);
      if (installResult.exitCode != 0) {
        return 'Installation failed: ${installResult.stderr}';
      }
      print('App installed successfully.');
    }

    // Check if the app is already running in the background
    ProcessResult runningResult = await Process.run('adb', ['-s', deviceId, 'shell', 'pidof', packageName]);

    if (runningResult.stdout.toString().isNotEmpty) {
      print('App is already running in the background.');
      return 'App is already running.';
    }

    // Launch the app if it's not running
    print('Launching app...');
    ProcessResult launchResult = await Process.run('adb', ['-s', deviceId, 'shell', 'am', 'start', '-n', '$packageName/$mainActivity']);

    if (launchResult.exitCode != 0) {
      return 'Launch failed: ${launchResult.stderr}';
    }

    return launchResult.stdout.toString();
  } catch (e) {
    print('Error launching app: $e');
    return 'Error launching app: $e';
  }
}


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
