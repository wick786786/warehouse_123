import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:warehouse_phase_1/src/helpers/sql_helper.dart';
import 'package:warehouse_phase_1/widgets/device_card2.dart';
import '../../src/helpers/adb_client.dart';
import '../../widgets/device_card.dart';
import '../../widgets/side_navigation.dart';
import '../../src/core/constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../src/helpers/launch_app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'drop_down.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final Function(Locale) onLocaleChange;
  final VoidCallback onThemeToggle;

  MyHomePage({Key? key, required this.title, required this.onLocaleChange, required this.onThemeToggle})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  final AdbClient adbClient = AdbClient();
  List<Map<String, String>> connectedDevices = [];
  Set<String> deviceSet = {};
  final LaunchApp launch = LaunchApp();
  StreamSubscription<Process>? adbStream;
  String adbError = '';
  bool previouslyDiagnosed=false;
  @override
  void initState() {
    super.initState();
    _startTrackingDevices();
  }

  @override
  void dispose() {
    adbStream?.cancel();  // Dispose of the ADB stream subscription to avoid memory leaks
    super.dispose();
  }

  Future<bool> isDevicePreviouslyDiagnosed(String deviceId) async {
    final data = await SqlHelper.getItems();
    return data.any((device) => device['sno'] == deviceId);
  }

   void _handleStartAgain() {

    setState(() {
      previouslyDiagnosed = false;
    });
  }

  void _startTrackingDevices() async {
    try {
      adbStream = Process.start('adb', ['track-devices']).asStream().listen((Process process) {
        process.stdout.transform(utf8.decoder).listen((String output) async {
          List<String> lines = output.split('\n');
          List<String> devices = await adbClient.listDevices();
          List<Map<String, String>> deviceDetailsList = [];

          for (String deviceId in devices) {
            Map<String, String> details = await adbClient.getDeviceDetails(deviceId);
            details['id'] = deviceId;
            deviceDetailsList.add(details);

            if (!deviceSet.contains(deviceId)) {
              deviceSet.add(deviceId);

              previouslyDiagnosed = await isDevicePreviouslyDiagnosed(deviceId);

              
                print("Launching $deviceId");

                String apkFileName = 'warehouse.apk'; 
                String packageName = 'com.getinstacash.warehouse';
                String mainActivity = 'com.getinstacash.warehouse.ui.activity.StartTest';

                launch.launchApplication(deviceId, packageName, mainActivity).then((result) {
                  print('Command result: $result');
                }).catchError((e) {
                  print('Error: $e');
                });
              
            }
          }

          setState(() {
            connectedDevices = deviceDetailsList;
            print('connected devices : $connectedDevices');
            deviceSet = connectedDevices.map((d) => d['id']!).toSet();
          });
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

  // void _showDeviceAlreadyDiagnosedDialog(String deviceId) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Device Already Diagnosed'),
  //         content: Text('The device with ID $deviceId has already been diagnosed once.'),
  //         actions: [
  //           TextButton(
  //             child: Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        actions: [
          _buildHoverIcon(
            icon: Icons.brightness_6_sharp, 
            onPressed: widget.onThemeToggle
          ),
          SizedBox(width: 6),
          _buildHoverIcon(
            icon: Icons.language,
            onPressed: null,
            child: LanguageDropdown(onLanguageChange: widget.onLocaleChange),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Container(
                width: constraints.maxWidth * 0.15,
                child: SideNavigation(),
              ),
              Expanded(
                child: Container(
                  color: theme.colorScheme.background,
                  child: Center(
                    child: adbError.isNotEmpty
                        ? _buildErrorWidget(context)
                        : connectedDevices.isEmpty
                            ? _buildWaitingWidget(context)
                            : _buildDeviceListWidget(context, constraints),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHoverIcon({required IconData icon, required VoidCallback? onPressed, Widget? child}) {
    return InkWell(
      onTap: onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => setState(() {}),
        onExit: (event) => setState(() {}),
        child: child ?? Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, color: theme.colorScheme.error, size: 60),
        SizedBox(height: 20),
        Text(
          adbError,
          style: TextStyle(color: theme.colorScheme.error, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildWaitingWidget(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingAnimationWidget.threeArchedCircle(
          color: theme.colorScheme.primary,
          size: 60,
        ),
        SizedBox(height: 20),
        Text(
          AppLocalizations.of(context)!.waiting_message,
          style: TextStyle(color: theme.colorScheme.onBackground, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildDeviceListWidget(BuildContext context, BoxConstraints constraints) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
          margin: EdgeInsets.fromLTRB(20, 14, 20, 10),
          width: constraints.maxWidth * 0.75,
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.connected_devices,
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(width: 6),
              Icon(Icons.smartphone, color: theme.colorScheme.primary),
            ],
          ),
        ),
        SizedBox(height: 15),
        Flexible(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              width: constraints.maxWidth * 0.75,
              height: 550,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth < 600
                      ? 1
                      : constraints.maxWidth < 1200
                          ? 2
                          : 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: constraints.maxWidth < 600 ? 0.8 : 0.65,
                ),
                itemCount: connectedDevices.length,
                itemBuilder: (context, index) {
                  
                  return DeviceCard(device: connectedDevices[index]);
                
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}