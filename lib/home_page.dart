import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'adb_client.dart';
import 'device_card.dart';
import 'side_navigation.dart';
import 'constants.dart'; // Import the constants
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'launch_app.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AdbClient adbClient = AdbClient();
  List<Map<String, String>> connectedDevices = [];
  Set<String> set = {};
  var launch=LaunchApp();
  @override
  void initState() {
    super.initState();
    _startTrackingDevices();
  }

  // Future<String> _launchApplication(String deviceId, String command) async {
  //   ProcessResult result =
  //       await Process.run('adb', ['-s', deviceId, 'shell', command]);
  //   return result.stdout.toString();
  // }

  void _startTrackingDevices() async {
    Timer.periodic(Duration(seconds: 2), (timer) async {
      List<String> devices = await adbClient.listDevices();
      List<Map<String, String>> deviceDetailsList = [];

      for (String deviceId in devices) {
        Map<String, String> details =
            await adbClient.getDeviceDetails(deviceId);
        details['id'] = deviceId;
        deviceDetailsList.add(details);

        if (!set.contains(deviceId)) {
          set.add(deviceId);
          print("launch $deviceId");

        //  var result = await launch.launchApplication(
        //      deviceId, 'am start -n com.getinstacash.demonext/com.getinstacash.demonext.PageOneActivity');
        //   print('output of launch App , $result');
        //String deviceId = 'your_device_id';
String apkFileName = 'DemoNext.apk';  // Name of the APK file in Downloads
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
        //print('connected at 0 index: ${connectedDevices[0]}');
        Set<String> temp = {};
       // print(connectedDevices);
        for (Map<String, String> d in connectedDevices) {
          d.forEach((key, value) {
            if (key == 'id') {
              temp.add(value);
            }
          });
        }
        set = temp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  color: AppColors.whiteColor,
                  child: Center(
                    child: connectedDevices.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingAnimationWidget.threeArchedCircle(
                                color: AppColors.primaryColor,
                                size: 60,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Waiting for device to be connected...',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                color: AppColors.whiteColor,
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                margin: EdgeInsets.fromLTRB(20, 14, 20, 10),
                                width: constraints.maxWidth * 0.75,
                                child: Row(
                                  children: [
                                    Text(
                                      'Connected Devices',
                                      style: AppTextStyles.heading,
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.smartphone,
                                        color: AppColors.primaryColor),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.greyColor
                                          .withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: constraints.maxWidth * 0.75,
                                height: 550,
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: constraints.maxWidth < 600
                                        ? 1
                                        : constraints.maxWidth < 1200
                                            ? 2
                                            : 3, // Responsive columns
                                    crossAxisSpacing: 16.0,
                                    mainAxisSpacing: 16.0,
                                    childAspectRatio:
                                        0.9, // Adjust based on your card aspect ratio
                                  ),
                                  itemCount: connectedDevices.length,
                                  itemBuilder: (context, index) {
                                    return DeviceCard(
                                        device: connectedDevices[index]);
                                  },
                                ),
                              ),
                            ],
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
