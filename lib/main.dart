// // import 'dart:ui';

// // import 'package:flutter/material.dart';
// // import 'package:flutter/widgets.dart';
// // import 'adb_client.dart';
// // import 'dart:async';
// // import 'package:percent_indicator/percent_indicator.dart';
// // import 'side_navigation.dart';
// // import 'dart:math';



// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Desktop ADB',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
        
// //       ),
// //       home: MyHomePage(title: 'Flutter Desktop ADB'),
     
// //     );
// //   }
// // }

// // class MyHomePage extends StatefulWidget {
// //   MyHomePage({Key? key, required this.title}) : super(key: key);

// //   final String title;

// //   @override
// //   _MyHomePageState createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   final AdbClient adbClient = AdbClient();
// //   List<Map<String, String>> connectedDevices = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     new LinearPercentIndicator(
// //                 width: 140.0,
// //                 lineHeight: 14.0,
// //                 percent: 0.5,
// //                 backgroundColor: Colors.grey,
// //                 progressColor: Colors.blue,
// //               );
// //     _startTrackingDevices();
// //   }

// //   void _startTrackingDevices() async {
// //     Timer.periodic(Duration(seconds: 2), (timer) async {
// //       List<String> devices = await adbClient.listDevices();
// //       List<Map<String, String>> deviceDetailsList = [];

// //       for (String deviceId in devices) {
// //         Map<String, String> details = await adbClient.getDeviceDetails(deviceId);
// //         details['id'] = deviceId;
// //         deviceDetailsList.add(details);
// //       }

// //       setState(() {
// //         connectedDevices = deviceDetailsList;
// //       });
// //     });
// //   }

// // Widget buildDeviceCard(Map<String, String> device) {
// //     double percent = 1; // Example percent value. Replace with actual logic.

// //     return Container(
// //       width: 300,
// //       child: Card(
// //         color: Colors.white,
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(15.0),
// //         ),
// //         elevation: 5,
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             children: [
// //               ListTile(
                 
// //                 title: Row(
// //                   children: [
// //                     Icon(Icons.android,color: Colors.deepPurple[400]),
// //                     SizedBox(width: 8,),
// //                     Text(
// //                       'Device ${device['id']?.substring(0,min(6,device['id']?.length ?? 0 ))}',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         color: Colors.black,
// //                         fontWeight: FontWeight.bold,
// //                       ),
                      
// //                     ),
// //                   ],
// //                 ),
// //                 subtitle: Padding(
// //                   padding: const EdgeInsets.only(top: 8.0),
// //                   child: Text(
// //                     'Model: ${device['model']}\n'
// //                     'Manufacturer: ${device['manufacturer']}\n'
// //                     'Android Version: ${device['androidVersion']}\n'
// //                     'Serial Number: ${device['serialNumber']}\n'
// //                     'IMEI: ${device['imeiOutput']}',
// //                     style: TextStyle(
// //                       color: Colors.black,
// //                       wordSpacing: 3,
// //                       letterSpacing: 1,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 10),
// //               if (percent < 0.9)
// //                 LinearPercentIndicator(
// //                   width: 200.0,
// //                   animation: true,
// //                   animationDuration: 1000,
// //                   lineHeight: 20.0,
// //                   percent: percent,
// //                   center: Text(
// //                     "${(percent * 100).toStringAsFixed(1)}%",
// //                     style: TextStyle(color: Colors.white),
// //                   ),
// //                   linearStrokeCap: LinearStrokeCap.roundAll,
// //                   progressColor: Colors.deepPurple[400],
// //                 )
// //               else if (percent < 1.0)
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     // Handle start analysis action
// //                   },
// //                   child: Text('Start crack check '),
// //                 )
// //               else
// //                 Row(
// //                   children: [
// //                     Icon(Icons.done,color:Colors.green,),
// //                     SizedBox(width: 8,),
// //                     ElevatedButton(
// //                       onPressed: () {
// //                         // Handle download report action
// //                       },
// //                       child: Text('Download Report'),
// //                       iconAlignment: IconAlignment.start,
// //                     ),
// //                   ],
// //                 ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       // appBar: AppBar(
// //       //   title: Text(widget.title,style: TextStyle(color:Colors.white),),
// //       //   backgroundColor:  const Color.fromARGB(255, 134, 96, 200),
// //       // ),
// //       drawer: SideNavigation(),
// //       body: Container(
      
// //         color: Color.fromARGB(255, 222, 219, 219),
        
// //         child: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: <Widget>[

            

// //               Container(
// //                 color:const Color.fromARGB(248, 255, 255, 255),
// //                 padding: EdgeInsets.all(10),
// //                 margin: EdgeInsets.all(20),
// //                 width:1440,
// //                 child: Text(
// //                   'Connected Devices ',
// //                   style: TextStyle(
// //                     color: Colors.black,
// //                     fontSize: 24,
// //                     fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
// //                     fontWeight: FontWeight.w400,
// //                   ),
// //                 ),
// //               ),

// //               SizedBox(height:15),
// //               Expanded(
// //                 child: SingleChildScrollView(
// //                   child: Wrap(
// //                     spacing: 16.0,
// //                     runSpacing: 16.0,
// //                     children: connectedDevices.map((device) {
// //                       return buildDeviceCard(device);
// //                     }).toList(),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// //-----------------------------------------LOG IN PAGE---------------------------------------------------------------------------------------------

// // import 'package:flutter/material.dart';

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Login Page',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: LoginPage(),
// //     );
// //   }
// // }

// // class LoginPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           Container(
// //             decoration: BoxDecoration(
// //               image: DecorationImage(
// //                 image: AssetImage('assets/background_4.jpg'),
// //                 fit: BoxFit.cover,
// //               ),
// //             ),
// //           ),
// //           Container(
// //             color: Color(0xFFF6F5FA).withOpacity(0.8), // Add a translucent overlay
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: Center(
// //                     child: Container(
// //                       padding: EdgeInsets.all(20),
// //                       child: RichText(
// //                         text: TextSpan(
// //                           children: [
// //                             TextSpan(
// //                               text: "Phone Diagnostic made ",
// //                               style: TextStyle(
// //                                 fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
// //                                 fontWeight: FontWeight.w700,
// //                                 color: Color(0xFF030712),
// //                                 fontSize: 72,
// //                                 height: 1,
// //                               ),
// //                             ),
// //                             TextSpan(
// //                               text: "faster.",
// //                               style: TextStyle(
// //                                 fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
// //                                 fontWeight: FontWeight.w700,
// //                                 color: Color(0xFF7C3AED),
// //                                 fontSize: 72,
// //                                 height: 1,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 Expanded(
// //                   child: Center(
// //                     child: Container(
// //                       width: 400,
// //                       padding: EdgeInsets.all(20),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(10),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.grey.withOpacity(0.5),
// //                             spreadRadius: 5,
// //                             blurRadius: 4,
// //                             offset: Offset(0, 3),
// //                           ),
// //                         ],
// //                       ),
// //                       child: Column(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Icon(
// //                             Icons.lock,
// //                             size: 60,
// //                             color: Colors.deepPurple[400],
// //                           ),
// //                           SizedBox(height: 20),
// //                           TextField(
// //                             decoration: InputDecoration(
// //                               prefixIcon: Icon(Icons.person, color: Colors.deepPurple[400]),
// //                               labelText: 'Username',
// //                               border: OutlineInputBorder(
// //                                 borderRadius: BorderRadius.circular(10),
// //                               ),
// //                             ),
// //                           ),
// //                           SizedBox(height: 20),
// //                           TextField(
// //                             obscureText: true,
// //                             decoration: InputDecoration(
// //                               prefixIcon: Icon(Icons.lock, color: Colors.deepPurple[400]),
// //                               labelText: 'Password',
// //                               border: OutlineInputBorder(
// //                                 borderRadius: BorderRadius.circular(10),
// //                               ),
// //                             ),
// //                           ),
// //                           SizedBox(height: 20),
// //                           ElevatedButton(
// //                             onPressed: () {
// //                               // Handle login action
// //                             },
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Colors.deepPurple[400],
// //                               padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(10),
// //                               ),
// //                             ),
// //                             child: Text(
// //                               'Login',
// //                               style: TextStyle(
// //                                 fontSize: 18,
// //                                 color: Colors.white,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }



import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Desktop ADB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
       home:MyHomePage(title: 'Flutter Desktop ADB'),
    );
  }
}
