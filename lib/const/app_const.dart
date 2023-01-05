import 'package:flutter/cupertino.dart';

class AppConst {
  ///编辑器Item 高度，左右缩进距离
  static const double EDITOR_ITEM_HEIGHT = 44; //高度
  static const double EDITOR_ITEM_INDENT = 20; //左右缩进
  static const double EDITOR_ITEM_TOP_BOTTOM = 16; //上下距离

  /// 时间显示的分隔符
  static const String DATE_MARK = '-';

  static const kInputTextFieldPadding = EdgeInsets.symmetric(horizontal: 4);

  static const maxCountValue = 9999999;

  static const billSelectGoodsMaxCount = 500;

  ///本地音乐文件储存地址
  static const localMusicPath = '/storage/emulated/0/Android/media/musico';
}
