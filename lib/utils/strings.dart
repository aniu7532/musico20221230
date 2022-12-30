
extension StringExtension on String {
  /// 在每个字符之间添加一个字符
  /// [separator]-字符对应的Unicode编码
  String join(int separator) {
    final runes = List.of(this.runes);
    final newRunes = <int>[];
    for (var i = 0; i < runes.length; i++) {
      if (i > 0) {
        newRunes.add(separator);
      }
      newRunes.add(runes.elementAt(i));
    }
    return String.fromCharCodes(newRunes);
  }

  /// 填充了无宽度空格的String
  String get noWideSpace => join(0x200B);

  /// 首字母转成大写
  String get capitalize =>
      isEmpty ? this : this[0].toUpperCase() + substring(1);

  /// 是否是一个账号
  bool get isAccount => length == 11 && RegExp(r'^1\d{10}$').hasMatch(this);

  /// 是否包含汉字
  bool get isContainsChinese {
    final reg = RegExp('[\u4e00-\u9fa5]');
    return reg.hasMatch(this);
  }
}
