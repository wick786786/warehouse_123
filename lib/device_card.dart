import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';
import 'constants.dart'; // Import the constants
import 'launch_app.dart';
import 'log_cat.dart'; // Make sure to import the LogCat class

class DeviceCard extends StatefulWidget {
  final Map<String, String> device;

  DeviceCard({required this.device});

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  double percent = 0; // Default percent value
  late StreamSubscription<int> _progressSubscription;

  @override
  void initState() {
    super.initState();
    _startLogCat();
  }

  void _startLogCat() {
    String? id = widget.device['id'];
    if (id != null) {
      LogCat.startLogCat(id);

      _progressSubscription = LogCat.getProgressStream(id).listen((progress) {
        setState(() {
          percent = progress / 100; // Assuming 100% is the max progress
        });
      });
    }
  }

  @override
  void dispose() {
    _progressSubscription.cancel();
    LogCat.stopLogCat(widget.device['id']!);
    super.dispose();
  }

  void _startAnalysis() {
    // Implement your logic for starting analysis here
  }

  void _downloadReport() {
    // Implement your logic for downloading the report here
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.android, color: AppColors.primaryColor),
                  SizedBox(width: 8),
                  Text(
                    'Device ${widget.device['id']?.substring(0, min(6, widget.device['id']?.length ?? 0))}',
                    style: AppTextStyles.deviceCardTitle,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Image.asset(
                'assets/device2.jpg',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 8),
              Text(
                'Model: ${widget.device['model']}\n'
                'Manufacturer: ${widget.device['manufacturer']}\n'
                'Android Version: ${widget.device['androidVersion']}\n'
                'Serial Number: ${widget.device['serialNumber']}\n'
                'IMEI: ${widget.device['imeiOutput']}',
                style: AppTextStyles.deviceDetails,
              ),
              SizedBox(height: 10),
              LinearPercentIndicator(
                width: 200.0,
                animation: true,
                animationDuration: 1000,
                lineHeight: 20.0,
                percent: percent,
                center: Text(
                  "${(percent * 100).toStringAsFixed(1)}%",
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: AppColors.primaryColor,
              ),
              if (percent >= 1.0)
                Row(
                  children: [
                    Icon(Icons.done, color: Colors.green),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _downloadReport,
                      child: Text('Download Report'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
