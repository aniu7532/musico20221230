import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

///存放应用全局静态变量
class AppData {
  AppData._();

  ///全局事件
  static EventBus eventBus = EventBus();

  ///rootContext
  static late BuildContext rootContext;

  ///是否资源版本
  static bool isWithData = true;

  ///deviceID
  static String deviceID = '';

  ///使用字体缩放
  static bool useScaleText = true;

  ///设置是否打印网络返回日志
  static bool useResponseBodyLog = true;
}
