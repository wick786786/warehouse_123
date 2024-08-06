import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'log_cat.dart';
class LaunchApp extends StatelessWidget {
  const LaunchApp({super.key});
  static Map<String, int> pp = {};


  Future<String> launchApplication(String deviceId, String apkFileName, String packageName, String mainActivity) async {
  // Default path for APK in Downloads directory
  String apkPath = 'C:\\Users\\thesa\\Downloads\\DemoNext.apk';


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

  // Launch the app
  print('Launching app...');
  ProcessResult launchResult = await Process.run('adb', ['-s', deviceId, 'shell', 'am', 'start', '-n', '$packageName/$mainActivity']);

  if (launchResult.exitCode != 0) {
    return 'Launch failed: ${launchResult.stderr}';
  }

  // Optional: Check the progress or wait for a condition here
  //await progress_check(deviceId);

  return launchResult.stdout.toString();
}

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
