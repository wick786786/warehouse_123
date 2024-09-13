import 'package:intl/intl.dart';
import 'package:warehouse_phase_1/src/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';

class DeviceDetails extends StatelessWidget {
  final Map<String, dynamic> details;
  final List<Map<String, dynamic>> hardwareChecks;
  final Map<String, String> status = {
    '1': 'success',
    '0': 'Fail',
    '-1': 'Skip',
    '-2': 'Not supported'
  };

  DeviceDetails(
      {super.key,
      required this.details,
      required this.hardwareChecks}); //required this.hardwareChecks});
  String _formatToLocalTime(String? createdAt) {
    // Check if createdAt is null or not in a valid date format
    if (createdAt == null || createdAt == 'N/A') {
      return 'Invalid Date'; // Return a fallback value
    }

    try {
      // Parse the createdAt string to DateTime (assuming it's in ISO 8601 format)
      DateTime utcTime = DateTime.parse(createdAt).toLocal();
      print("utcTime:$utcTime");

      // Convert UTC time to Indian Standard Time (IST)
      DateTime istTime = utcTime.add(const Duration(
          hours: 5, minutes: 30)); // Corrected to 5 hours 30 minutes for IST

      // Format the IST time as a string
      String formattedTime =
          "${istTime.day}-${istTime.month}-${istTime.year} ${istTime.hour}:${istTime.minute}:${istTime.second}";
      print(formattedTime);

      return formattedTime;
    } catch (e) {
      // Handle any parsing errors
      return 'Invalid Date'; // Return a fallback value
    }
  }
  Future<String> executeShellCommand(String deviceId, String command) async {
    ProcessResult result = await Process.run('adb', ['-s', deviceId, 'shell', command]);
    if (result.exitCode != 0) {
      return '';
    }
    return result.stdout.toString().trim();
  }


  Future<void> _downloadReport() async {
    try {
      // Get the application document directory for saving the report
      //final directory = await getApplicationDocumentsDirectory();
      // Set up the warehouse and device ID folder paths
       //final androidVersion = await executeShellCommand(details['sno'], 'getprop ro.build.version.release');
      final warehouseDir =
          Directory(path.join(Directory.current.path, 'warehouse'));
      if (!await warehouseDir.exists()) {
        await warehouseDir.create();
      }

      final deviceDir =
          Directory(path.join(warehouseDir.path, details['iemi']));
      if (!await deviceDir.exists()) {
        await deviceDir.create();
      }

      // File picker for saving the report
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Choose location to save',
        allowedExtensions: ['pdf'],
        type: FileType.custom,
        lockParentWindow: true,
        fileName: 'device_diagnostic_report_${details['iemi']}.pdf',
      );

      if (outputFile == null) {
        print('User canceled the save dialog');
        return;
      }

      // Create PDF document
      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (pw.Context context) => [
            pw.Column(
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
                pw.SizedBox(height: 12),
                pw.Text(
                  'Diagnose ID: ${details['iemi']}',
                  style: const pw.TextStyle(
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
                pw.SizedBox(height: 6),
                pw.Text('Manufacturer: ${details['manufacturer']}',
                    style: const pw.TextStyle(color: PdfColors.black)),
                pw.Text('Type: Smartphone',
                    style: const pw.TextStyle(color: PdfColors.black)),
                pw.Text('RAM: ${details['ram']}',
                    style: const pw.TextStyle(color: PdfColors.black)),
                pw.Text('ROM: ${details['rom_gb']}',
                    style: const pw.TextStyle(color: PdfColors.black)),
                pw.Text('Model: ${details['model']}',
                    style: const pw.TextStyle(color: PdfColors.black)),
                pw.Text('IMEI: ${details['iemi']}',
                    style: const pw.TextStyle(color: PdfColors.black)),
                pw.Text(
                    'mdm status: ${details['mdm_status'] == '1' ? 'Unlocked' : 'Locked'}',
                    style: const pw.TextStyle(color: PdfColors.black)),
                pw.Text(
                    'oem status: ${details['oem_status'] == '1' ? 'Unlocked' : 'Locked'}',
                    style: const pw.TextStyle(color: PdfColors.black)),
                pw.Text(
                    'carrier lock status: ${details['carrier_lock_status']}',
                    style: const pw.TextStyle(color: PdfColors.black)),
                pw.Divider(height: 32, thickness: 2),
                pw.Text(
                  'Software Information',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text('OS Name: Android ',
                    style: const pw.TextStyle(color: PdfColors.black)),
                pw.Text('OS Version: ${details['ver']}',
                    style: const pw.TextStyle(color: PdfColors.black)),
                pw.Divider(height: 32, thickness: 2),
                pw.Text(
                  'Hardware Check',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 6),
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
                      padding: const pw.EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: color, width: 1),
                        borderRadius:
                            const pw.BorderRadius.all(pw.Radius.circular(5)),
                      ),
                      child: pw.Text(
                        '$key: ${value == '1' ? 'Passed' : value == '0' ? 'Failed' : value == '-1' ? 'Skipped' : 'Not Supported'}',
                        style: pw.TextStyle(
                          color: color,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                pw.Divider(height: 12, thickness: 2),
                pw.Text(
                  'Report Details',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                    'Diagnostic Date: ${_formatToLocalTime(details['createdAt'] ?? 'N/A')}',
                    style: const pw.TextStyle(color: PdfColors.black)),
              ],
            ),
          ],
        ),
      );

      // Saving the PDF report
      final file = File(path.join(deviceDir.path, path.basename(outputFile)));
      await file.writeAsBytes(await pdf.save());

      print('Report downloaded to ${file.path}');
      await OpenFilex.open(file.path);
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemes.lightMode, // Apply the light theme here
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Diagnostic Report',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Device Diagnostic Report',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.info_outline,
                    color: Theme.of(context).colorScheme.secondary, size: 32),
                title: Text(
                  'Diagnose ID: ${details['iemi']}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Hardware Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.build_circle,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('Manufacturer: ${details['manufacturer']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.device_unknown,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('Type: Smartphone',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.model_training,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('Model: ${details['model']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.model_training,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('RAM: ${details['ram']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.model_training,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('ROM: ${details['rom_gb']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.model_training,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text(
                  'MDM STATUS: ${details['mdm_status'] == '1' ? 'Unlocked' : 'Locked'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.model_training,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text(
                  'OEM STATUS: ${details['oem'] == '1' ? 'Unlocked' : 'Locked'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.model_training,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text(
                  'Carrier Lock Status: ${details['carrier_lock_status']}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.confirmation_number,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('IMEI: ${details['iemi']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
              ),
              const SizedBox(height: 32),
              Text(
                'Software Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.phone_android,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('OS Name: Android',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.system_update_alt,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('OS Version: ${details['ver']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
              ),
              const SizedBox(height: 32),
              Text(
                'Hardware Check',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10.0,
                    runSpacing: 10.0,
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

                      return SizedBox(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: iconColor, width: 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                '$key: ${value == '1' ? 'Passed' : value == '0' ? 'Failed' : value == '-1' ? 'Skipped' : 'Not Supported'}',
                                style: TextStyle(
                                  color: iconColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Report Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  'Diagnostic Date: ${_formatToLocalTime(details['createdAt'] ?? 'N/A')}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    _downloadReport();
                  },
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
