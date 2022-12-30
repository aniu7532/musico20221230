import 'package:flutter/cupertino.dart';
import 'package:musico/const/app_data.dart';

///设置键盘属性工具
class KeyboardUtil {
  ///隐藏键盘
  static hideKeyboard() {
    FocusScope.of(AppData.rootContext).requestFocus(FocusNode());
  }
}
