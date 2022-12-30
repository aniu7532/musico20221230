import 'package:decimal/decimal.dart';
import 'package:flustars/flustars.dart';

class NumberFormatUtil {
  NumberFormatUtil._();

  /// 去掉末尾的.0格式化成字符串 为空则返回空字符串
  static String formatNumNoZero(num? n) {
    if (n == null) return '';
    return Decimal.parse(n.toString()).toString();
  }

  /// 去掉末尾的.0格式化成字符串 为空则返回null
  static String? tryFormatNumNoZero(num? n) {
    if (n == null) return null;
    return Decimal.parse(n.toString()).toString();
  }

  /// 保留两位小数，不足补零
  static String formatNum2Zero(num? num, {int fractionDigits = 2}) {
    if (num == null) return '0.00';
    return toStringWithDigit(
          number: NumUtil.getNumByValueDouble(double.tryParse('$num'), 2),
          digit: 2,
        ) ??
        '';
  }

  /// 将数字收位
  /// [number] 原始数字
  /// [fixDigit] 收位后要保留的小数位数
  static num? formatNumberWithFixDigit({
    required num? number,
    int? fixDigit,
  }) {
    if (number == null) {
      return null;
    }
    if (fixDigit == null) {
      return number;
    }
    // 精度为负时，往前移位,这里是为了处理其他端折扣没有百分号，而pda端有百分号，所以这边的精度会-2可能变成负数，需要特殊处理
    if (fixDigit < 0) {
      final percentNumber = number / 100;
      final absDigit = fixDigit.abs();
      return num.parse(
            toStringWithDigit(
              number: percentNumber,
              digit: absDigit,
            )!,
          ) *
          100;
    }
    return num.parse(
      toStringWithDigit(
        number: number,
        digit: fixDigit,
      )!,
    );
  }

  /// 将数字收位（不四舍五入）
  /// [number] 原始数字
  /// [fixDigit] 收位后要保留的小数位数
  static num? formatNumberWithFloorDigit({
    required num? number,
    int? fixDigit,
  }) {
    if (number == null) {
      return null;
    }
    if (fixDigit == null) {
      return number;
    }
    // 精度为负时，往前移位,这里是为了处理其他端折扣没有百分号，而pda端有百分号，所以这边的精度会-2可能变成负数，需要特殊处理
    if (fixDigit < 0) {
      final percentNumber = number / 100;
      final absDigit = fixDigit.abs();
      return num.parse(
            toStringWithFloor(
              number: percentNumber,
              digit: absDigit,
            )!,
          ) *
          100;
    }
    return num.parse(
      toStringWithFloor(
        number: number,
        digit: fixDigit,
      )!,
    );
  }

  /// 将数字收位并转换成String字符串
  /// [number] 原始数字
  /// [fixDigit] 收位后要保留的小数位数
  static String formatNumberWithFixDigitToString({
    required num? number,
    int? fixDigit,
  }) {
    return NumberFormatUtil.formatNumNoZero(
      formatNumberWithFixDigit(
        number: number,
        fixDigit: fixDigit,
      ),
    );
  }

  /// 按小数位数四舍五入收位，num的toStringAsFixed方法因为double精度问题存在bug，使用此方法代替
  static String? toStringWithDigit({
    required num? number,
    required int digit,
  }) {
    if (number == null) {
      return '';
    }
    final numberString = number.toString();
    if (numberString.contains('.')) {
      final pointIndex = numberString.indexOf('.');
      final nextIndex = pointIndex + digit + 1;
      if (numberString.length > nextIndex) {
        final nextNumber = int.tryParse(
          numberString.substring(nextIndex, nextIndex + 1),
        );
        if (nextNumber == 5) {
          final newNumber = numberString.replaceRange(nextIndex, null, '6');
          return num.parse(newNumber).toStringAsFixed(digit);
        }
      }
    }
    return number.toStringAsFixed(digit);
  }

  /// 按小数位数直接舍掉后续位数，不四舍五入
  static String? toStringWithFloor({
    required num? number,
    required int digit,
  }) {
    if (number == null) {
      return '';
    }
    final numberString = number.toString();
    if (numberString.contains('.')) {
      final pointIndex = numberString.indexOf('.');
      final nextIndex = pointIndex + digit + 1;
      if (numberString.length > nextIndex) {
        return numberString.substring(0, nextIndex);
      }
    }
    return number.toStringAsFixed(digit);
  }

  //格式化数字
  static num fixNum(number) {
    if (number == null) number = 0;
    if (number is String) {
      if (number == 'NaN') return 0;
      number = num.tryParse(number) ?? 0;
    }
    return number == number.toInt() ? number.toInt() : number;
  }

  /// 将数字取反
  static num? parseNumToNegate(num? number) {
    if (number == null) {
      return number;
    }
    return -number;
  }

  /// 将数字字符串取反
  static num? parseNumStringToNegate(String? number) {
    return parseNumToNegate(num.tryParse(number ?? ''));
  }
}
