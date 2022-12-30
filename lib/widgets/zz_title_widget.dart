
import 'package:flutter/material.dart';

///统一定义AppBar中使用的标题样式
class ZzTitle extends StatelessWidget {

  const ZzTitle(
    this.title,
    {
      Key? key,
      this.style,
    }
  ) : super(key: key);

  final String title;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: style ?? const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
