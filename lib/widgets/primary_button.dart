import 'package:flutter/material.dart';
import 'package:musico/gen/colors.gen.dart';

///使用主题颜色的作为背景的 button
///文字是白色
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    this.text = '确定',
    required this.onPressed,
    this.width = double.infinity,
    this.height = 44.0,
    this.fontSize = 16.0,
    this.padding = 10.0,
    this.fontWeight = FontWeight.normal,
    this.color = ColorName.themeColor,
    this.fontColor = Colors.white,
    this.borderRadius = 4,
    this.borderWidth = 1,
    this.borderColor = ColorName.themeColor,
  }) : super(key: key);

  const PrimaryButton.secondary({
    Key? key,
    this.text = '确定',
    required this.onPressed,
    this.width = double.infinity,
    this.height = 44.0,
    this.fontSize = 16.0,
    this.padding = 10.0,
    this.fontWeight = FontWeight.normal,
    this.color = ColorName.secondaryColor,
    this.fontColor = Colors.white,
    this.borderRadius = 0,
    this.borderWidth = 1,
    this.borderColor = ColorName.themeColor,
  }) : super(key: key);

  ///有边框的按钮
  const PrimaryButton.singleWithBorder({
    Key? key,
    this.text = '确定',
    required this.onPressed,
    this.width = double.infinity,
    this.height = 30.0,
    this.fontSize = 14.0,
    this.padding = 10,
    this.fontWeight = FontWeight.normal,
    this.color = ColorName.themeColor,
    this.fontColor = Colors.white,
    this.borderRadius = 36,
    this.borderWidth = 1,
    this.borderColor = Colors.white,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double fontSize;
  final double padding;
  final FontWeight? fontWeight;
  final Color fontColor;
  final Color color;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      //设置按钮是否自动获取焦点
      // autofocus: true,
      //定义一下文本样式
      style: ButtonStyle(
        //定义文本的样式 这里设置的颜色是不起作用的
        textStyle: MaterialStateProperty.all(TextStyle(
            fontSize: fontSize, color: Colors.red, fontWeight: fontWeight)),
        //设置按钮上字体与图标的颜色
        //foregroundColor: MaterialStateProperty.all(Colors.deepPurple),
        //更优美的方式来设置
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.focused) &&
                !states.contains(MaterialState.pressed)) {
              //获取焦点时的颜色
              return fontColor;
            } else if (states.contains(MaterialState.pressed)) {
              //按下时的颜色
              return fontColor;
            }
            //默认状态使用灰色
            return fontColor;
          },
        ),
        //背景颜色
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          //设置按下时的背景颜色
          if (states.contains(MaterialState.pressed)) {
            return ColorName.themeColor.withOpacity(0.8);
          }
          //默认不使用背景颜色
          return color;
        }),
        //设置水波纹颜色
        overlayColor: MaterialStateProperty.all(
            ColorName.secondaryColor.withOpacity(0.1)),
        //设置阴影  不适用于这里的TextButton
        elevation: MaterialStateProperty.all(0),
        //设置按钮内边距
        padding: MaterialStateProperty.all(EdgeInsets.all(padding)),
        //设置按钮的大小
        minimumSize: MaterialStateProperty.all(Size(width, height)),
        //设置边框
        side: MaterialStateProperty.all(
          BorderSide(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        //外边框装饰 会覆盖 side 配置的样式
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      child: Text(text),
    );
  }
}
