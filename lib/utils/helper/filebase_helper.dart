import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

final FireBaseHelper fireBaseHelper = FireBaseHelper();

class FireBaseHelper {
  factory FireBaseHelper() => _instance;

  FireBaseHelper._();

  static late final FireBaseHelper _instance = FireBaseHelper._();

  ///
  /// 获取配置
  ///
  Future<void> getRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await remoteConfig.fetchAndActivate();
    remoteConfig.getString('musico_open');
  }

  ///
  /// 获取设备id 作为用户id
  ///
  Future<String> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.androidId;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor;
      }
    } catch (e) {
      return '';
    }
    return '';
  }
}
