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

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Device Diagnostic Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Diagnose ID: ${details['iemi']}', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 32),
              pw.Text('Hardware Details', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Manufacturer: ${details['manufacturer']}'),
              pw.Text('Type: Smartphone'),
              pw.Text('Model: ${details['model']}'),
              pw.Text('IMEI: ${details['iemi']}'),
              pw.SizedBox(height: 32),
              pw.Text('Software Information', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('OS Name: ${details['os_name']}'),
              pw.Text('OS Version: ${details['os_version']}'),
              pw.SizedBox(height: 32),
              pw.Text('Hardware Check', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              for (var check in hardwareChecks)
                 pw.Text('${check.keys.first}: ${status[check.values.first]}'),
              pw.SizedBox(height: 32),
              pw.Text('Report Details', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Diagnostic Date: ${details['createdAt']}'),
            ],
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
        backgroundColor: const Color.fromARGB(255, 222, 238, 226),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color.fromARGB(255, 222, 238, 226),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Device Diagnostic Report',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Diagnose ID: ${details['iemi']}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Hardware Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text('Manufacturer: ${details['manufacturer']}', style: const TextStyle(color: Colors.black54)),
              const Text('Type: Smartphone', style: TextStyle(color: Colors.black54)),
              Text('Model: ${details['model']}', style: const TextStyle(color: Colors.black54)),
              Text('IMEI: ${details['iemi']}', style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 32),
              const Text(
                'Software Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text('OS Name: ${details['os_name']}', style: const TextStyle(color: Colors.black54)),
              Text('OS Version: ${details['os_version']}', style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 32),
              const Text(
                'Hardware Check',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
               for (var check in hardwareChecks)
                 Text('${check.keys.first}: ${status[check.values.first]}', style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 32),
              const Text(
                'Report Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text('Diagnostic Date: ${details['createdAt']}', style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(159, 2, 95, 75),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: _downloadReport,
                  child: const Text('Download Report'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
