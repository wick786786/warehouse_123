import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';

class DeviceDetails extends StatelessWidget {
  final Map<String, dynamic> details;
  final List<Map<String, dynamic>> hardwareChecks;
   final Map<String,String>status={
    '1':'success',
    '0':'Fail',
    '-1':'Skip',
    '-2':'Not supported'
   };

  DeviceDetails({super.key, required this.details,required this.hardwareChecks}); //required this.hardwareChecks});

  Future<void> _downloadReport() async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Choose location to save',
        allowedExtensions: ['pdf'],
        type: FileType.custom,
        lockParentWindow: true,
        fileName: 'device_diagnostic_report.pdf',
      );

      if (outputFile == null) {
        print('User canceled the save dialog');
        return;
      }

      final pdf = pw.Document();

      //final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'Device Diagnostic Report',
                    style: pw.TextStyle(
                      fontSize: 26,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                ),
                pw.SizedBox(height: 24),
                pw.Text(
                  'Diagnose ID: ${details['iemi']}',
                  style: pw.TextStyle(
                    fontSize: 18,
                    color: PdfColors.black,
                  ),
                ),
                pw.Divider(height: 32, thickness: 2),
                pw.Text(
                  'Hardware Details',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text('Manufacturer: ${details['manufacturer']}', style: pw.TextStyle(color: PdfColors.black)),
                pw.Text('Type: Smartphone', style: pw.TextStyle(color: PdfColors.black)),
                pw.Text('Model: ${details['model']}', style: pw.TextStyle(color: PdfColors.black)),
                pw.Text('IMEI: ${details['iemi']}', style: pw.TextStyle(color: PdfColors.black)),
                pw.Divider(height: 32, thickness: 2),
                pw.Text(
                  'Software Information',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text('OS Name: Android ', style: pw.TextStyle(color: PdfColors.black)),
                pw.Text('OS Version: 14', style: pw.TextStyle(color: PdfColors.black)),
                pw.Divider(height: 32, thickness: 2),
                pw.Text(
                  'Hardware Check',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: hardwareChecks.map((check) {
                    final key = check.keys.first;
                    final value = check.values.first.toString();
                    PdfColor color;

                    if (value == '1') {
                      color = PdfColors.green;
                    } else if (value == '0') {
                      color = PdfColors.red;
                    } else if (value == '-1') {
                      color = PdfColors.yellow800;
                    } else {
                      color = PdfColors.grey;
                    }

                    return pw.Container(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: color, width: 1),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
                      ),
                      child: pw.Text(
                        '$key: ${status[value]}',
                        style: pw.TextStyle(
                          color: color,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                pw.Divider(height: 32, thickness: 2),
                pw.Text(
                  'Report Details',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text('Diagnostic Date: ${details['createdAt']}', style: pw.TextStyle(color: PdfColors.black)),
              ],
            ),
          ),
        ),
      );



      final file = File(outputFile);
      await file.writeAsBytes(await pdf.save());

      print('Report downloaded to $outputFile');
      await OpenFilex.open(outputFile);

    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor:const Color(0xFF4CAF50),
          title: const Text(
            'Diagnostic Report',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Device Diagnostic Report',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color:Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.info_outline, color: Color(0xFF0277BD), size: 32),
                title: Text(
                  'Diagnose ID: ${details['iemi']}',
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Hardware Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.build_circle, color: Color(0xFF0277BD)),
                title: Text('Manufacturer: ${details['manufacturer']}', style: const TextStyle(color: Colors.black87)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.device_unknown, color:const Color(0xFF0277BD)),
                title: const Text('Type: Smartphone', style: TextStyle(color: Colors.black87)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.model_training, color: Color(0xFF0277BD)),
                title: Text('Model: ${details['model']}', style: const TextStyle(color: Colors.black87)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.confirmation_number, color: Color(0xFF0277BD)),
                title: Text('IMEI: ${details['iemi']}', style: const TextStyle(color: Colors.black87)),
              ),
              const SizedBox(height: 32),
              const Text(
                'Software Information',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.phone_android, color: Color(0xFF0277BD)),
                title: Text('OS Name: Android', style: TextStyle(color: Colors.black87)),
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.system_update_alt, color: Color(0xFF0277BD)),
                title: Text('OS Version: 14', style: TextStyle(color: Colors.black87)),
              ),
              const SizedBox(height: 32),
              const Text(
                'Hardware Check',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: hardwareChecks.map((check) {
                  String key = check.keys.first;
                  String value = check.values.first.toString();
                  Color textColor;
                  IconData icon;
                  Color iconColor;

                  switch (value) {
                    case '1':
                      textColor = Colors.green;
                      icon = Icons.check_circle;
                      iconColor = Colors.green;
                      break;
                    case '0':
                      textColor = Colors.red;
                      icon = Icons.cancel;
                      iconColor = Colors.red;
                      break;
                    case '-1':
                      textColor = Colors.yellow[800]!;
                      icon = Icons.warning;
                      iconColor = Colors.yellow[800]!;
                      break;
                    default:
                      textColor = Colors.grey;
                      icon = Icons.block;
                      iconColor = Colors.grey;
                      break;
                  }

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(icon, color: iconColor),
                    title: Text(
                      '$key: ${status[value]}',
                      style: TextStyle(color: textColor),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              const Text(
                'Report Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today, color: Color(0xFF0277BD)),
                title: Text('Diagnostic Date: ${details['createdAt']}', style: const TextStyle(color: Colors.black87)),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: _downloadReport,
                  icon: const Icon(Icons.download),
                  label: const Text('Download Report'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  

}
