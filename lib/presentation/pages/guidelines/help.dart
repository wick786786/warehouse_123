import 'package:flutter/material.dart';
import 'package:warehouse_phase_1/presentation/pages/guidelines/numbers.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: Text(
          'Guidelines',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Developer Options',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'On Android 4.1 and lower, the Developer options screen is available by default. '
                'On Android 4.2 and higher, you must enable this screen.',
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  // color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Note: On some devices, the Developer options screen might be located or named differently.',
                  style: TextStyle(
                    fontSize: 16,
                   // color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  NumberCircle(number: 1),
                  SizedBox(width: 6),
                  Text(
                    'On your device, find the Build number option. The following table shows the settings location of the Build number on various devices:',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      //color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              DataTable(
                columns: const [
                  DataColumn(
                      label: Text('Device',
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black))),
                  DataColumn(
                      label: Text('Setting',
                          style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black))),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Google Pixel')),
                    DataCell(Text('Settings > About phone > Build number')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Samsung Galaxy S8 and later')),
                    DataCell(Text(
                        'Settings > About phone > Software information > Build number')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('LG G6 and later')),
                    DataCell(Text(
                        'Settings > About phone > Software info > Build number')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('HTC U11 and later')),
                    DataCell(Text(
                        'Settings > About > Software information > More > Build number')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('OnePlus 5T and later')),
                    DataCell(Text('Settings > About phone > Build number')),
                  ]),
                ],
                dataTextStyle: const TextStyle(
                  fontSize: 16,
                ),
                headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    return Colors.white;
                  },
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 30),
              const Row(
                children: [
                  NumberCircle(number: 2),
                  SizedBox(width: 6),
                  Text(
                    'Tap the Build Number option seven times until you see the message "You are now a developer!" '
                    'This enables developer options on your device.',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  NumberCircle(number: 3),
                  SizedBox(width: 6),
                  Text(
                    'Return to the previous screen to find Developer options at the bottom.',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Row(
                children: [
                  NumberCircle(number: 4),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'At the top of the Developer options screen, you can toggle the options on and off. '
                      'Keep this on. When off, most options are disabled except those that dont require communication between the device and your development computer.',
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),
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
