import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storeUtil = StoreUtil();

///自动加密存储
class StoreUtil {
  factory StoreUtil() => _instance;

  StoreUtil._();

  static late final StoreUtil _instance = StoreUtil._();

  static const noDataTips = '未获取到数据';

  Future<void> removeValue(String key) async {
    if (Platform.isIOS || Platform.isAndroid || Platform.isLinux) {
      const storage = FlutterSecureStorage();
      try {
        await storage.delete(key: key);
      } on Exception catch (e) {}
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    }
  }

  Future<void> saveValue(String key, String? value) async {
    if (Platform.isIOS || Platform.isAndroid || Platform.isLinux) {
      const storage = FlutterSecureStorage();
      try {
        await storage.write(key: key, value: value);
      } on Exception catch (e) {}
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value ?? '');
    }
  }

  Future<String> fetchValue(String key) async {
    String? value;

    if (Platform.isIOS || Platform.isAndroid || Platform.isLinux) {
      const storage = FlutterSecureStorage();
      value = await storage.read(key: key);
    } else {
      final prefs = await SharedPreferences.getInstance();
      value = prefs.getString(key);
    }

    return value ?? noDataTips;
  }

  Future<void> clear() async {
    if (Platform.isIOS || Platform.isAndroid || Platform.isLinux) {
      const storage = FlutterSecureStorage();
      await storage.deleteAll();
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }
  }
}
