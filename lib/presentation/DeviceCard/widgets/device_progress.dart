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
                      if (onDataWipe != null) {
                        await onDataWipe!(); // Call the data wipe function
                      }
                    },
                    child: const Text('Data Wipe'),
                  ),
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
