import 'package:flutter/material.dart';

class DeviceProgressSection extends StatelessWidget {
  final double? progress;
  final bool isDevicePresent;
  final VoidCallback onViewDetailsPressed;
  final VoidCallback onResetPressed;
  final Future<void> Function()? onDataWipe; // Updated type for async callback

  const DeviceProgressSection({
    super.key,
    required this.progress,
    required this.isDevicePresent,
    required this.onViewDetailsPressed,
    required this.onResetPressed,
    this.onDataWipe, // Optional parameter for data wipe function
  });

  @override
  Widget build(BuildContext context) {
    print('is device present in progress bar :$isDevicePresent');
    final theme = Theme.of(context);
    return progress! >= 1.0 || isDevicePresent
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      const Text('Test completed'),
                      const SizedBox(width: 5),
                      TextButton(
                        onPressed: onViewDetailsPressed,
                        child: const Text('View Details'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () async {
                      // Show confirmation dialog
                      bool? confirmDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Data Wipe'),
                            content: const Text(
                                'Are you sure you want to delete all files on your phone? This action cannot be undone.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(false); // Return false if canceled
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(true); // Return true if confirmed
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );

                      // If user confirmed the deletion
                      if (confirmDelete == true) {
                        if (onDataWipe != null) {
                          await onDataWipe!(); // Call the data wipe function
                        }
                      }
                    },
                    child: const Text('Data Wipe'),
                  )
                ],
              ),
            ],
          )
        : Column(
            children: [
              LinearProgressIndicator(
                backgroundColor: Colors.grey.shade300,
                valueColor:
                    AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                value: progress,
              ),
              Text('${(progress! * 100).toStringAsFixed(2)}% completed'),
            ],
          );
  }
}
