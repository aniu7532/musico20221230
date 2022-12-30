import 'package:flutter/cupertino.dart';

class AppConst {
  ///编辑器Item 高度，左右缩进距离
  static const double EDITOR_ITEM_HEIGHT = 44; //高度
  static const double EDITOR_ITEM_INDENT = 20; //左右缩进
  static const double EDITOR_ITEM_TOP_BOTTOM = 16; //上下距离

  /// 文字 ¥
  static const String rmb = '¥'; //人民币符号

  /// 时间显示的分隔符
  static const String DATE_MARK = '-';

  /// 时间控件默认的的最大最小值
  static const String MIN_DATETIME = '2012-12-31 00:00:00';
  static const String MAX_DATETIME = '2122-12-31 00:00:00';

  static const kInputTextFieldMinWidth = 30.0;
  static const kInputTextFieldPadding = EdgeInsets.symmetric(horizontal: 4);

  static const maxCountValue = 9999999;

  static const billSelectGoodsMaxCount = 500;

  /// 腾讯地图使用的，官网获取的WebServiceApi对应的校验keyapikey，调用搜索接口时会使用。
  //static const tencentMapApiKey = 'pA8vAAvBgY9ClCetloTrd3dXoTsEpHo';
  static const tencentMapApiKey = 'mrB0crppLBLC5fFHRF0XSw7nEYCc1Ji';

  /// 客户最近售价 字样
  static const customerPriceName = '客户最近售价';
  static const customerLevelId = '-1';

  ///本地音乐文件储存地址
  static const localMusicPath = '/storage/emulated/0/Android/media/musico';
}
