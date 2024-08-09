import 'dart:async';
import 'dart:convert';
import 'dart:io';

class AdbClient {
  Future<List<String>> listDevices() async {
    ProcessResult result = await Process.run('adb', ['devices']);
    if (result.exitCode != 0) {
      return [];
    }

    List<String> lines = LineSplitter.split(result.stdout.toString()).toList();
    lines.removeAt(0); // Remove the first line 'List of devices attached'

    List<String> devices = [];
    for (String line in lines) {
      if (line.trim().isEmpty) {
        continue;
      }
      devices.add(line.split('\t')[0]);
    }
    return devices;
  }

  Future<String> executeShellCommand(String deviceId, String command) async {
    ProcessResult result = await Process.run('adb', ['-s', deviceId, 'shell', command]);
    if (result.exitCode != 0) {
      return '';
    }
    return result.stdout.toString().trim();
  }

  Future<Map<String, String>> getDeviceDetails(String deviceId) async {
    final model = await executeShellCommand(deviceId, 'getprop ro.product.model');
    final manufacturer = await executeShellCommand(deviceId, 'getprop ro.product.manufacturer');
    final androidVersion = await executeShellCommand(deviceId, 'getprop ro.build.version.release');
    final serialNumber = await executeShellCommand(deviceId, 'getprop ro.serialno');
    final imeiOutput = await executeShellCommand(deviceId, 'service call iphonesubinfo 1 s16 com.android.shell | cut -c 50-64 | tr -d \'.[:space:]\'');
    final mdmStatus=await checkMdmStatus(deviceId);
    final batterylevel=await executeShellCommand(deviceId, 'dumpsys battery | grep level');
    return {
      'model': model,
      'manufacturer': manufacturer,
      'androidVersion': androidVersion,
      'serialNumber': serialNumber,
      'imeiOutput': imeiOutput.replaceAll("'", ''),
      'mdm_status': mdmStatus,
      'batterylevel':batterylevel,
    };
  }

  // Function to check for device or profile owner
  /*
   Purpose: This function checks if a device owner is set on the Android device. 
   Having a device owner is a key indicator of an MDM presence since it represents 
   the highest level of control an app can have over a device.
   Sufficiency: It’s a critical check. If a device owner is found, it 
   suggests the device is managed by an MDM.
  */
  Future<bool> checkDeviceOwner(String deviceId) async {
    final owner = await executeShellCommand(deviceId, 'dpm list-owners | grep "Device Owner"');
    if (owner.isNotEmpty) {
      print("Device Owner: Found");
      return true;
    } else {
      print("Device Owner: Not Found");
      return false;
    }
  }

  // Function to check for active device admins
  Future<bool> checkActiveAdmins(String deviceId) async {
    final admins = await executeShellCommand(deviceId, 'dumpsys device_policy | grep "Active admin"');
    if (admins.isNotEmpty) {
      print("Active Admins: Found");
      return true;
    } else {
      print("Active Admins: Not Found");
      return false;
    }
  }

  // Function to check for managed profiles
  Future<bool> checkManagedProfiles(String deviceId) async {
    final profiles = await executeShellCommand(deviceId, 'pm list packages -e');
    if (profiles.isNotEmpty) {
      print("Managed Profiles: Found");
      return true;
    } else {
      print("Managed Profiles: Not Found");
      return false;
    }
  }

  // Perform checks and determine final MDM status
  Future<String> checkMdmStatus(String deviceId) async {
    print("Checking MDM Status...");

    final deviceOwnerStatus = await checkDeviceOwner(deviceId);
    final activeAdminsStatus = await checkActiveAdmins(deviceId);
    final managedProfilesStatus = await checkManagedProfiles(deviceId);

    if (deviceOwnerStatus || activeAdminsStatus || managedProfilesStatus) {
      return "true";
    } else {
       return "false";
    }
  }
}
