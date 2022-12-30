import 'package:musico/const/user_bean.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

///存放应用全局静态变量
class AppData {
  AppData._();

  ///全局事件
  static EventBus eventBus = EventBus();

  ///rootContext
  static late BuildContext rootContext;

  ///使用字体缩放
  static bool useScaleText = true;

  ///判断设置是否是PDA
  static bool isPdaDevice = false;

  ///设置是否打印网络返回日志
  static bool useResponseBodyLog = true;

  ///首页开单页是否显示状态
  static bool isMainBillPageShow = true;

  ///首页商品页面是否显示
  static bool isMainGoodsPageShow = false;

  String proxy = '';

  ///是否允许体验一下
  static bool isAllowExperience = false;

  ///是否是上架的版本
  static bool isShelfApp = false;

  ///登录后用户的信息
  static UserBean? userBean;

  ///允许体验时的体验账号信息
  static String corpId = '';
  static String wxCorpId = '';
  static String wxUserId = '';
}
