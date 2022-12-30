import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musico/utils/toast_util.dart';

///
///
/// //使用：
/// child:TextField(
/// keyboardType: TextInputType.number,
/// maxLines: 1,
/// textAlign: TextAlign.right,
/// focusNode: priceFocus,
/// inputFormatters: [TextNumberLimitFormatter(5,3),],	//整数5位，小数3楼
/// inputFormatters: [TextNumberLimitFormatter(5,0)],	//只整数5位
/// create by ls 2022/4/25
///数字输入的精确控制
class TextNumberLimitFormatter extends TextInputFormatter {
  TextNumberLimitFormatter(
    this._intlen,
    this._declen, {
    this.isNegative = false,
    this.maxNum,
    this.minNum,
    this.whenMaxNumToastStr,
    this.whenMinNumToastStr,
    this.showToastWhenOverflow = false,
  });

  final int _declen;
  final int _intlen;

  ///是否支持 false不支持负数(默认不支持)
  final bool isNegative;

  RegExp exp = RegExp("[0-9.]");
  static const String POINTER = ".";
  static const String ZERO = "0";

  /// 最大值
  num? maxNum;

  /// 最小值
  num? minNum;

  /// 超出最大值弹出文字
  String? whenMaxNumToastStr;
  String? whenMinNumToastStr;
  final bool showToastWhenOverflow;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    ///输入完全删除
/*    if (newValue.text.isEmpty) {
      //  FocusScope.of(context).requestFocus(_focusNode);
      return TextEditingValue.empty;
    }*/

    if (!isNegative) {
      if (newValue.text.contains('-')) {
        return oldValue;
      }
      //只允许输入数字和小数点
      if (!newValue.text.isEmpty && !exp.hasMatch(newValue.text)) {
        return oldValue;
      }
    }

    ///最大值判断
    if (ObjectUtil.isNotEmpty(maxNum)) {
      final nowNum = num.tryParse(newValue.text);
      if (ObjectUtil.isNotEmpty(nowNum) &&
          nowNum! > maxNum! &&
          newValue.text.length >= oldValue.text.length) {
        final newValue = oldValue.copyWith(text: '$maxNum');
        if (whenMaxNumToastStr != null) {
          MyToast.showToast(whenMaxNumToastStr!);
        } else if (showToastWhenOverflow) {
          MyToast.showToast('超过最大值');
        }
        return newValue;
      }
    }

    ///最小值判断
    if (ObjectUtil.isNotEmpty(minNum)) {
      final nowNum = num.tryParse(newValue.text);
      if (ObjectUtil.isNotEmpty(nowNum) && nowNum! < minNum!) {
        final newValue = oldValue.copyWith(
          text: '$minNum',
          selection: TextSelection(
            baseOffset: minNum.toString().length,
            extentOffset: minNum.toString().length,
          ),
        );
        if (whenMinNumToastStr != null) {
          MyToast.showToast(whenMinNumToastStr!);
        } else if (showToastWhenOverflow) {
          MyToast.showToast('小于最小值');
        }
        return newValue;
      }
    }

    ///包含小数点的情况
    if (newValue.text.contains(POINTER)) {
      //精度为0，即不含小数
      if (_declen == 0) {
        return oldValue;
      }

      ///包含多个小数
      if (newValue.text.indexOf(POINTER) !=
          newValue.text.lastIndexOf(POINTER)) {
        return oldValue;
      }
      final input = newValue.text;
      final index = input.indexOf(POINTER);

      ///小数点前位数
      final lengthBeforePointer = input.substring(0, index).length;

      ///整数部分大于约定长度
      if (lengthBeforePointer > _intlen) {
        return oldValue;
      }

      ///小数点后位数
      final lengthAfterPointer =
          input.substring(index, input.length).length - 1;
      if (kDebugMode) {
        print('小数后位数$lengthAfterPointer');
      }

      ///小数位大于精度
      if (lengthAfterPointer > _declen) {
        return oldValue;
      }
    } else if (newValue.text.length > _intlen) {
      //如果整数长度超过约定长度
      return oldValue;
    } else if (newValue.text.startsWith(POINTER)) {
      final newText = '0${newValue.text}';
      //以点开头
      return newValue.copyWith(
        text: newText,
        selection: TextSelection(
          baseOffset: newText.length,
          extentOffset: newText.length,
        ),
      );
    } else if (newValue.text.startsWith(ZERO) &&
        newValue.text.length > 1 &&
        !newValue.text.contains(POINTER)) {
      //如果第1位为0，并且长度大于1，不包含小数点，去掉首位的0
      final newText = newValue.text.substring(1, newValue.text.length);
      return TextEditingValue(
        text: newText,
        selection: TextSelection(
          baseOffset: newText.length,
          extentOffset: newText.length,
        ),
      );
    }
    return newValue;
  }
}

/// //只允许输入数字和小数点  RegExp("[0-9.]");
///  RegExp('[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]')
///  1、匹配中文:[\u4e00-\u9fa5]
/// 2、英文字母:[a-zA-Z]
/// 3、数字:[0-9]
/// 4、匹配中文，英文字母和数字及下划线：^[\u4e00-\u9fa5_a-zA-Z0-9]+$
/// 同时判断输入长度：
/// [\u4e00-\u9fa5_a-zA-Z0-9_]{4,10}
/// 5、
/// (?!_)　　不能以_开头
/// (?!.*?_$)　　不能以_结尾
/// [a-zA-Z0-9_\u4e00-\u9fa5]+　　至少一个汉字、数字、字母、下划线
/// $　　与字符串结束的地方匹配
/// 6、只含有汉字、数字、字母、下划线，下划线位置不限：
/// ^[a-zA-Z0-9_\u4e00-\u9fa5]+$
/// 7、由数字、26个英文字母或者下划线组成的字符串
/// ^\w+$
/// 8、2~4个汉字
/// "^[\u4E00-\u9FA5]{2,4}$";
/// 9、最长不得超过7个汉字，或14个字节(数字，字母和下划线)正则表达式
/// ^[\u4e00-\u9fa5]{1,7}$|^[\dA-Za-z_]{1,14}$

class SimpleLimitFormatter extends TextInputFormatter {
  SimpleLimitFormatter(this.exp);

  RegExp exp;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newValueText = newValue.text;
    final oldValueText = oldValue.text;
    final trimOld = newValueText.replaceAll(oldValueText, '');
    if (ObjectUtil.isNotEmpty(trimOld) && !exp.hasMatch(trimOld)) {
      return oldValue;
    }
    return newValue;
  }
}

///将传入的特殊字符，替换为空字符串
class SpecialLimitFormatter extends TextInputFormatter {
  SpecialLimitFormatter(this.limitList);

  List<String> limitList;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var newValueText = newValue.text;
    if (ObjectUtil.isNotEmpty(newValueText)) {
      for (final limit in limitList) {
        if (newValueText.contains(limit)) {
          newValueText = newValueText.replaceAll(limit, '');
        }
      }
      return TextEditingValue(
        text: newValueText,
        selection: TextSelection(
          baseOffset: newValueText.length,
          extentOffset: newValueText.length,
        ),
      );
    }
    return newValue;
  }
}
