import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';

class DeviceDetails extends StatelessWidget {
  const DeviceDetails({super.key});

  Future<void> _downloadReport() async {
    try {
      // Step 1: Open Save Dialog and Get the Output File Location
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

      // Step 2: Create the PDF file
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
              pw.Text('Diagnose ID: 35270220240718', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 32),
              pw.Text('Hardware Details', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Manufacturer: Apple'),
              pw.Text('Type: Smartphone'),
              pw.Text('Model: Apple iPhone 11 4GB/256GB'),
              pw.Text('IMEI: 356-564-103-944-190'),
              pw.SizedBox(height: 32),
              pw.Text('Software Information', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('OS Name: IOS'),
              pw.Text('OS Version: '),
              pw.SizedBox(height: 32),
              pw.Text('Hardware Check', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Vibrator: Success'),
              pw.Text('Rotation: Success'),
              pw.Text('Battery: Success'),
              pw.Text('Fingerprint Scanner: Failed'),
              pw.Text('MIC: Success'),
              pw.Text('Storage: Success'),
              pw.Text('Hardware Buttons: Success'),
              pw.Text('Dead Pixels: Success'),
              pw.SizedBox(height: 32),
              pw.Text('Report Details', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Diagnostic Date: '),
            ],
          ),
        ),
      );

      // Step 3: Save the PDF file
      final file = File(outputFile);
      await file.writeAsBytes(await pdf.save());

      print('Report downloaded to $outputFile');

      // Step 4: Open the downloaded file
      await OpenFilex.open(outputFile);

    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.lightBlue[50], // Set light blue background
        appBar: AppBar(
          title: const Text('Device Diagnostic Report'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                  color: Colors.black87, // Dark text for contrast
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Diagnose ID: 35270220240718',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54, // Lighter text for less emphasis
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
              const Text('Manufacturer: Apple', style: TextStyle(color: Colors.black54)),
              const Text('Type: Smartphone', style: TextStyle(color: Colors.black54)),
              const Text('Model: Apple iPhone 11 4GB/256GB', style: TextStyle(color: Colors.black54)),
              const Text('IMEI: 356-564-103-944-190', style: TextStyle(color: Colors.black54)),
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
              const Text('OS Name: IOS', style: TextStyle(color: Colors.black54)),
              const Text('OS Version: ', style: TextStyle(color: Colors.black54)),
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
              const Text('Vibrator: Success', style: TextStyle(color: Colors.black54)),
              const Text('Rotation: Success', style: TextStyle(color: Colors.black54)),
              const Text('Battery: Success', style: TextStyle(color: Colors.black54)),
              const Text('Fingerprint Scanner: Failed', style: TextStyle(color: Colors.black54)),
              const Text('MIC: Success', style: TextStyle(color: Colors.black54)),
              const Text('Storage: Success', style: TextStyle(color: Colors.black54)),
              const Text('Hardware Buttons: Success', style: TextStyle(color: Colors.black54)),
              const Text('Dead Pixels: Success', style: TextStyle(color: Colors.black54)),
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
              const Text('Diagnostic Date: ', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Blue accent button
                    foregroundColor: Colors.white, // White text
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
