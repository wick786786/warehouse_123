import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';
import '../src/helpers/launch_app.dart';
import '../src/helpers/log_cat.dart'; // Ensure LogCat class is imported
import '../src/helpers/sql_helper.dart';
import 'mdm_status.dart';
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

  void _startLogCat() async {
    String? id = widget.device['id'];
    print('debug : device card ${widget.device['id']}');
    if (id != null) {
      try {
        LogCat.startLogCat(id);

        _progressSubscription = LogCat.getProgressStream(id).listen((progress) async {
          setState(() {
            percent = progress / 100; // Assuming 100% is the max progress
          });
          print("my debug $percent");
          if (percent >= 1.0) {
            print("my debug");

            try {
              await SqlHelper.createItem(
                widget.device['manufacturer'] ?? '',
                widget.device['model'] ?? '',
                widget.device['imeiOutput'] ?? '',
                widget.device['serialNumber'] ?? '',
              );
              await LogCat.createJsonFile(widget.device['id']);
              print("my id : $id");
            } catch (e) {
              print('Error creating item: $e');
            }
          }
        });
      } catch (e) {
        print('Error starting LogCat: $e');
      }
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
  String safeSubstring(String? value, int length) {
  if (value == null || value.length < length) {
    return value ?? 'N/A';
  }
  return value.substring(0, min(length,6));
}




  @override
  Widget build(BuildContext context) {
   final ThemeData theme = Theme.of(context);
final Color primaryColor = theme.colorScheme.primary;
final Color whiteColor = theme.colorScheme.onPrimary;
final TextStyle deviceCardTitle = theme.textTheme.headlineSmall ?? TextStyle();
final TextStyle deviceDetails = theme.textTheme.bodySmall ?? TextStyle();

return Container(
  child: Card(
    color: theme.cardColor,
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
              Icon(Icons.android, color: primaryColor),
              SizedBox(width: 8),
              Text(
               safeSubstring(widget.device['manufacturer'],widget.device['manufacturer']!.length )+" "+safeSubstring(widget.device['model'], widget.device['model']!.length),
                style: deviceCardTitle,
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
            'Model:  ${widget.device['model'] ?? 'N/A'}\n'
            'Manufacturer: ${widget.device['manufacturer'] ?? 'N/A'}\n'
            'Android Version: ${widget.device['androidVersion'] ?? 'N/A'}\n'
            'Serial Number: ${widget.device['serialNumber'] ?? 'N/A'}\n'
            'IMEI: ${widget.device['imeiOutput'] ?? 'N/A'}\n',
            style: deviceDetails,
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Column(
                children: [
                  MdmStatus(status: widget.device['mdm_status']),
                  Text('MDM'),
                ],
              ),
              SizedBox(width:12),
              Column(
                children: [
                  Icon(Icons.battery_6_bar_rounded,color:primaryColor,),
                  Text(widget.device['batterylevel']!.substring(min(widget.device['batterylevel']!.length,7),widget.device['batterylevel']!.length) ?? 'N/A'),
                ],
              ),
              SizedBox(width:12),
               Column(
                children: [
                  //Icon(Icons.battery_6_bar_rounded,color:primaryColor,),
                  Text('${widget.device['ram']}/${widget.device['rom']}',style:TextStyle(fontSize: 15),),
                  Text('RAM/ROM'),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          LinearPercentIndicator(
            width: 200.0,
            animation: true,
            animationDuration: 1000,
            lineHeight: 23.0,
            percent: min(percent,1),
            center: Text(
              "${(percent * 100).toStringAsFixed(1)}%",
              style: TextStyle(color: whiteColor, fontSize: 12),
            ),
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: primaryColor,
          ),
          SizedBox(height: 15),
          // if (percent >= 1.0)
          //   Row(
          //     children: [
          //       Icon(Icons.done, color: Colors.green),
          //       SizedBox(width: 8),
          //       ElevatedButton(
          //         onPressed: _downloadReport,
          //         child: Text('Download Report'),
          //       ),
          //     ],
          //   ),
        ],
      ),
    ),
  ),
);

  }
}
