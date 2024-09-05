import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:warehouse_phase_1/presentation/pages/homepage/widgets/device_list_widget.dart';
import 'package:warehouse_phase_1/presentation/pages/homepage/widgets/device_manage.dart';
import 'package:warehouse_phase_1/presentation/pages/homepage/widgets/error_widget.dart';
import 'package:warehouse_phase_1/presentation/pages/homepage/widgets/hover_icon.dart';
import 'package:warehouse_phase_1/presentation/pages/homepage/widgets/waiting_widget.dart';
import 'package:warehouse_phase_1/src/helpers/log_cat.dart';
import 'package:warehouse_phase_1/src/helpers/sql_helper.dart';
import 'package:window_manager/window_manager.dart';
import '../../../src/helpers/adb_client.dart';

import 'widgets/side_navigation.dart';

import '../../../src/helpers/launch_app.dart';

import '../drop_down.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final Function(Locale) onLocaleChange;
  final VoidCallback onThemeToggle;

  const MyHomePage(
      {super.key,
      required this.title,
      required this.onLocaleChange,
      required this.onThemeToggle});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AdbClient adbClient = AdbClient();
  Map<String?, double> deviceProgress = {};
  Map<String, Map<String, String>> connectedDevices = {}; // Updated to Map
  Set<String> deviceSet = {};
  final LaunchApp launch = const LaunchApp();
  StreamSubscription<Process>? adbStream;
  String adbError = '';
  bool previouslyDiagnosed = false;
  Map<String, StreamSubscription<int>> progressSubscriptions =
      {}; // To store subscriptions per device
  Map<String, bool> resultsSaved = {}; // Track if results are saved per device

  @override
  void initState() {
    super.initState();
    asyncFunction();
  }

  Future<void> asyncFunction() async {
    _startTrackingDevices();
  }

  @override
  void dispose() {
    adbStream
        ?.cancel(); // Dispose of the ADB stream subscription to avoid memory leaks
    super.dispose();
  }

  void _handleStartAgain() {
    setState(() {
      previouslyDiagnosed = false;
    });
  }

  void _startTrackingDevices() async {
    Set<String> previousDeviceSet =
        Set.from(deviceSet); // Keep track of previously connected devices

    try {
      adbStream = Process.start('adb', ['track-devices'])
          .asStream()
          .listen((Process process) {
        process.stdout.transform(utf8.decoder).listen((String output) async {
          List<String> lines = output.split('\n');
          List<String> devices = await adbClient.listDevices();
          Map<String, Map<String, String>> deviceDetailsMap =
              {}; // Updated to use Map

          // Create a new set for currently connected devices
          Set<String> currentDeviceSet = {};

          for (String deviceId in devices) {
            Map<String, String> details =
                await adbClient.getDeviceDetails(deviceId);
            details['id'] = deviceId;
            deviceDetailsMap[deviceId] = details; // Use Map for device details

            currentDeviceSet.add(deviceId);

            if (!deviceSet.contains(deviceId)) {
              deviceSet.add(deviceId);

              // Retrieve saved progress or start from 0
              double savedProgress =
                  await DeviceProgressManager.getProgress(deviceId);
              deviceProgress[deviceId] = savedProgress;

              // Device connected, handle launch logic here
              print("Launching $deviceId");

              String apkFileName = 'warehouse.apk';
              String packageName = 'com.getinstacash.warehouse';
              String mainActivity =
                  'com.getinstacash.warehouse.ui.activity.StartTest';

              launch
                  .launchApplication(deviceId, packageName, mainActivity)
                  .then((result) {
                print('Command result: $result');
              }).catchError((e) {
                print('Error: $e');
                String modelName =
                    connectedDevices[deviceId]?['model'] ?? 'Unknown Model';
                setState(() {
                  adbError = 'Error launching application on $modelName: $e';
                });
              });
              _startLogCat(deviceId); // Start LogCat tracking for this device
            }
          }

          // Check for disconnected devices
          Set<String> disconnectedDevices =
              previousDeviceSet.difference(currentDeviceSet.toSet());
          for (String deviceId in disconnectedDevices) {
            print("Device disconnected: $deviceId");
            LogCat.stopLogCat(
                deviceId); // Stop LogCat for the disconnected device
            progressSubscriptions[deviceId]
                ?.cancel(); // Cancel progress subscription for this device
            deviceSet.remove(deviceId);
            //deviceProgress.remove(deviceId);
            resultsSaved.remove(deviceId);
          }

          setState(() {
            connectedDevices = deviceDetailsMap; // Updated to use Map
            print('connected devices : $connectedDevices');
            deviceSet = currentDeviceSet; // Updated to use Set
          });

          // Update previousDeviceSet to the current state
          previousDeviceSet = Set.from(currentDeviceSet);
        });

        process.stderr.transform(utf8.decoder).listen((String error) {
          setState(() {
            adbError = 'ADB Error: $error';
          });
        });
      });
    } catch (e) {
      setState(() {
        adbError = 'Failed to start adb process: $e';
      });
    }
  }

  void _startLogCat(String deviceId) async {
    try {
      LogCat.startLogCat(deviceId);

      StreamSubscription<int> subscription =
          LogCat.getProgressStream(deviceId).listen((progress) async {
        if (deviceSet.contains(deviceId)) {
          double newProgress = progress / 100;
          setState(() {
            deviceProgress[deviceId] =min(1, newProgress);
          });

          // Save progress
          await DeviceProgressManager.saveProgress(deviceId, newProgress);

          if (newProgress >= 1.0 && !(resultsSaved[deviceId] ?? false)) {
            resultsSaved[deviceId] = true;
            await _saveResults(deviceId);
            // Reset progress after saving results

            // await DeviceProgressManager.resetProgress(deviceId);
          }
        }
      });

      // Save the subscription to cancel it later if needed
      progressSubscriptions[deviceId] = subscription;
    } catch (e) {
      print('Error starting LogCat: $e');
      String modelName =
          connectedDevices[deviceId]?['model'] ?? 'Unknown Model';
      setState(() {
        adbError = 'Error starting LogCat for $modelName: $e';
      });
    }
  }

  Future<void> _saveResults(String deviceId) async {
    try {
      await SqlHelper.createItem(
        connectedDevices[deviceId]?['manufacturer'] ?? '',
        connectedDevices[deviceId]?['model'] ?? '',
        connectedDevices[deviceId]?['imeiOutput'] ?? '',
        connectedDevices[deviceId]?['serialNumber'] ?? '',
      );
      await LogCat.createJsonFile(deviceId);
      print("JSON DEBUG");
    } catch (e) {
      print('Error saving results: $e');
    }
  }

  void _resetPercent(String deviceId) async {
    setState(() {
      deviceProgress[deviceId] = 0;
    });
    await DeviceProgressManager.resetProgress(deviceId);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        actions: [
          HoverIcon(
            icon: Icons.brightness_6_sharp,
            onPressed: widget.onThemeToggle,
          ),
          const SizedBox(width: 20),
          HoverIcon(
            icon: Icons.language,
            onPressed: null,
            child: LanguageDropdown(onLanguageChange: widget.onLocaleChange),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisSize:
                MainAxisSize.max, // Ensure the Row takes up maximum width
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                width: constraints.maxWidth * 0.125,
                child: SideNavigation(),
              ),
              Expanded(
                child: Container(
                  color: theme.colorScheme.surface,
                  child: Center(
                    child: adbError.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red, size: 50),
                              const SizedBox(height: 10),
                              Text(
                                adbError,
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : connectedDevices.isEmpty
                            ? WaitingWidget()
                            : DeviceListWidget(
                                connectedDevices: connectedDevices,
                                deviceProgress: deviceProgress,
                                constraints: constraints,
                              ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
