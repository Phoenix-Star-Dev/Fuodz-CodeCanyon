// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:fuodz/widgets/bottomsheets/photo_permission.bottomsheet.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:device_info_plus/device_info_plus.dart';

class PermissionUtils {
  /*
  static Future<bool> handleImagePermissionRequest(BuildContext context) async {
    //check if is android
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 33) {
        return await storageRequest(context);
      } else {
        return await photoRequest(context);
      }
    } else {
      return await photoRequest(context);
    }
  }

  static Future<bool> photoRequest(BuildContext context) async {
    Permission permission = Permission.photos;
    //check if permission is granted
    bool isGranted = await permission.isGranted;
    if (!isGranted) {
      //show the dialog infor before showing the permission request
      final result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => PhotoPermissionDialog(),
      );

      if (result == null || !result) {
        return false;
      }

      //
      final photoPermissionStatus = await permission.request();
      if (photoPermissionStatus.isGranted) {
        return true;
        // } else if (await Permission.photos.isPermanentlyDenied) {
        //   await openAppSettings();
        //   return await Permission.photos.request().isGranted;
      }
      return false;
    }

    //
    return true;
  }

  */
  /*
  static Future<bool> storageRequest(BuildContext context) async {
    //check if permission is granted
    Permission permission = Permission.storage;
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 33) {
        permission = Permission.storage;
      } else {
        permission = Permission.manageExternalStorage;
      }
    }

    //
    bool isGranted = await permission.isGranted;
    if (!isGranted) {
      //show the dialog infor before showing the permission request
      final result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => PhotoPermissionDialog(),
      );

      if (result == null || !result) {
        return false;
      }

      //
      if ((await permission.request()).isGranted) {
        return true;
        // } else if (await Permission.storage.isPermanentlyDenied) {
        //   await openAppSettings();
        //   return await Permission.storage.request().isGranted;
      }
      return false;
    }
    //
    return true;
  }
  */
}
