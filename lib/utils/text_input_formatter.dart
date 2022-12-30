import 'package:musico/utils/text_number_limit_formatter.dart';
import 'package:flutter/services.dart';

final textInputFormatter = ZzTextInputFormatter();

class ZzTextInputFormatter {
  factory ZzTextInputFormatter() => _instance;
  ZzTextInputFormatter._();

  static final ZzTextInputFormatter _instance = ZzTextInputFormatter._();

  TextInputFormatter get numberLetterOnly => SimpleLimitFormatter(
        RegExp('[a-zA-Z]|[0-9]'),
      );
}
