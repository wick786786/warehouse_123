import 'package:flutter/material.dart';

class DeviceHeader extends StatelessWidget {
  final String? manufacturer;
  final String? model;

  const DeviceHeader({super.key, required this.manufacturer, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
          child: Icon(Icons.android, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "$manufacturer $model",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
