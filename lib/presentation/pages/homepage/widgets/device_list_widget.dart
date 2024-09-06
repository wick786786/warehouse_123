import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Ensure this import is correct
import 'package:warehouse_phase_1/presentation/DeviceCard/device_card.dart';
// import 'package:warehouse_phase_1/presentation/DeviceCard/widgets/device_progress.dart';

 // Adjust the import as per your file structure

class DeviceListWidget extends StatelessWidget {
  final Map<String, Map<String, String>> connectedDevices; // Updated to Map
  final Map<String?, double> deviceProgress; // Add this line
  final BoxConstraints constraints;

  const DeviceListWidget({
    super.key,
    required this.connectedDevices,
    required this.deviceProgress, // Add this line
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          margin: const EdgeInsets.fromLTRB(20, 14, 20, 10),
          width: constraints.maxWidth * 0.75,
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.connected_devices,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(width: 6),
              Icon(Icons.smartphone, color: theme.colorScheme.primary),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0),
               border: Border.all( // Add this to create a colored border
      color: theme.primaryColor, // Border color
      width: 2.0, // Border width
    ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            width: constraints.maxWidth * 0.75,
            height: 550,
            child: GridView.builder(
              // physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth < 600
                    ? 1
                    : constraints.maxWidth < 1200
                        ? 2
                        : constraints.maxWidth < 1470
                            ? 3
                            : 4,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: constraints.maxWidth < 600 ? 0.8 : 0.4,
              ),
              itemCount: connectedDevices.length,
              itemBuilder: (context, index) {
                // Extract the device ID and details
                String deviceId = connectedDevices.keys.elementAt(index);
                Map<String, String> deviceDetails = connectedDevices[deviceId]!;

                return SizedBox(
                  width: double.infinity,
                  child: DeviceCard(
                    device: deviceDetails,
                    progress: deviceProgress[deviceId], // Pass progress here
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
