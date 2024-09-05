import 'package:flutter/material.dart';

class DeviceProgressSection extends StatelessWidget {
  final double? progress;
  final bool isDevicePresent;
  final VoidCallback onViewDetailsPressed;
  final VoidCallback onResetPressed;

  const DeviceProgressSection({
    super.key,
    required this.progress,
    required this.isDevicePresent,
    required this.onViewDetailsPressed,
    required this.onResetPressed,
  });

  @override
  Widget build(BuildContext context) {
    print('is device present in progress bar :$isDevicePresent');
    final theme = Theme.of(context);
    return  progress! >= 1.0 || isDevicePresent
        ? 
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Test completed'),
              TextButton(
                onPressed: onViewDetailsPressed,
                child: const Text('View Details'),
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
