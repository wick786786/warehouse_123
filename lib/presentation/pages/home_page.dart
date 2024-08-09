import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

  MyHomePage({Key? key, required this.title, required this.onLocaleChange,required this.onThemeToggle})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AdbClient adbClient = AdbClient();
  List<Map<String, String>> connectedDevices = [];
  Set<String> deviceSet = {};
  final LaunchApp launch = LaunchApp();

  @override
  void initState() {
    super.initState();
    _startTrackingDevices();
  }

  void _startTrackingDevices() async {
  Process.start('adb', ['track-devices']).then((Process process) {
    process.stdout.transform(utf8.decoder).listen((String output) async {
      // The output of 'adb track-devices' will include device connection and disconnection events
      List<String> lines = output.split('\n');

      // Parse the devices from the output
      List<String> devices = await adbClient.listDevices();
      List<Map<String, String>> deviceDetailsList = [];

      for (String deviceId in devices) {
        Map<String, String> details = await adbClient.getDeviceDetails(deviceId);
        details['id'] = deviceId;
        deviceDetailsList.add(details);

        if (!deviceSet.contains(deviceId)) {
          deviceSet.add(deviceId);
          print("Launching $deviceId");

          String apkFileName = 'DemoNext.apk'; // Name of the APK file in Downloads
          String packageName = 'com.getinstacash.demonext';
          String mainActivity = 'com.getinstacash.demonext.PageOneActivity';

          launch.launchApplication(deviceId, apkFileName, packageName, mainActivity).then((result) {
            print('Command result: $result');
          }).catchError((e) {
            print('Error: $e');
          });
        }
      }

      setState(() {
        connectedDevices = deviceDetailsList;
        deviceSet = connectedDevices.map((d) => d['id']!).toSet();
      });
    });

    process.stderr.transform(utf8.decoder).listen((String error) {
      print('ADB Error: $error');
    });
  }).catchError((e) {
    print('Failed to start adb process: $e');
  });
}


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
       // title: Text(widget.title),
        backgroundColor: theme.colorScheme.background,
        actions: [
           IconButton(
            icon: Icon(Icons.brightness_6), // Icon for theme toggle
            onPressed: 
              widget.onThemeToggle
             // Call the toggle function
          ),
          SizedBox(width:6),
          LanguageDropdown(
            onLanguageChange: widget.onLocaleChange,
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
                    child: connectedDevices.isEmpty
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
          color: theme.colorScheme.background,
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
                    offset: Offset(0, 3), // changes position of shadow
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
                          : 3, // Responsive columns
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 0.7, // Adjust based on your card aspect ratio
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
