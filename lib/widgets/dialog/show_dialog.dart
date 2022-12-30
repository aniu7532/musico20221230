import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/utils/common_widget_utils.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/widgets/zz_check_box.dart';
import 'package:musico/widgets/dialog/center_base_dialog.dart';
import 'package:musico/widgets/fixed_scale_text_widget.dart';
import 'package:musico/widgets/support_cupertino_textfield.dart';
import 'package:musico/widgets/zz_checkbox_list_tile.dart';

/// 输入字数
ValueNotifier<int> valueNotifier = ValueNotifier<int>(0);

///将品牌图片应用为无图商品的商品主图
ValueNotifier<bool> applyToGoodsPicValue = ValueNotifier<bool>(false);

///文字提示弹窗
class TextDialog extends StatefulWidget {
  TextDialog({
    Key? key,
    this.title = '标题',
    this.content,
    this.subContent,
    this.confirmText = "确认",
    this.cancelText = '取消',
    this.onConfirm,
    this.onConfirmWithCheckBox,
    this.onCancel,
    this.onBack,
    this.hiddenCancelBtn,
    this.hiddenConfirmBtn,
    this.showCheckBox = false,
    this.autoFinish = true,
    this.bottom = 10,
    this.radius = 13,
    this.contentPaddingHorizontal = 13,
    this.contentPaddingVertical = 0,
  }) : super(key: key);

  final String title;
  final String? content;
  final String? subContent;
  final String confirmText;
  final String cancelText;
  final Function? onConfirm;
  final Function? onConfirmWithCheckBox;
  final Function? onCancel;
  final Function? onBack;
  final bool? hiddenCancelBtn;
  final bool? hiddenConfirmBtn;
  final bool? showCheckBox;
  final bool autoFinish;
  final double bottom;
  final double radius;
  final double contentPaddingHorizontal;
  final double contentPaddingVertical;

  @override
  State<TextDialog> createState() => _TextDialogState();
}

bool b = false;

class _TextDialogState extends State<TextDialog> {
  @override
  Widget build(BuildContext context) {
    return FixedScaleTextWidget(
      child: CenterBaseDialog(
        title: widget.title,
        radius: widget.radius,
        cancelText: widget.cancelText,
        confirmText: widget.confirmText,
        contentBottomMargin: widget.bottom,
        hiddenTitle: widget.title == null || widget.title.isEmpty,
        onPressed: () {
          if (widget.autoFinish) Navigator.pop(context);
          if (widget.onConfirm != null) {
            widget.onConfirm!();
          }
          if (widget.onConfirmWithCheckBox != null) {
            widget.onConfirmWithCheckBox!(b);
          }
        },
        onCancel: () {
          b = false;
          if (widget.onCancel != null) widget.onCancel!();
        },
        onBack: widget.onBack,
        hiddenCancelBtn: widget.hiddenCancelBtn ?? false,
        hiddenConfirmBtn: widget.hiddenConfirmBtn ?? false,
        child: ObjectUtil.isEmpty(widget.content)
            ? const SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.contentPaddingHorizontal,
                  vertical: widget.contentPaddingVertical,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        widget.content ?? '',
                        style: FSUtils.font_normal_14_color515151,
                      ),
                      Visibility(
                        visible: widget.subContent != null,
                        child: Container(
                          margin: const EdgeInsets.only(top: 4),
                          child: Text(
                            widget.subContent ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: ColorName.error,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.showCheckBox ?? false,
                        child: GestureDetector(
                          onTap: () {
                            b = !b;
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                ZzCheckbox(
                                  value: b,
                                  onChanged: (v) {},
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                const Text(
                                  '不再提醒',
                                  style: FSUtils.font_bold_12_colorFF333333,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

///创建一个输入框
Widget buildInputWidget(
  String content,
  String text,
  String hintText,
  int maxLength,
  ValueChanged<String> onChanged, {
  autofocus: false,
  TextInputType? inputType,
  BuildContext? context = null,
  bool hideNumberTips = true,
  List<TextInputFormatter>? inputFormatters,
}) {
  final _c = TextEditingController();
  if (ObjectUtil.isNotEmpty(text)) {
    _c.text = text;
    _c.selection =
        TextSelection(baseOffset: text.length, extentOffset: text.length);
  }

  return Container(
    margin: const EdgeInsets.only(
      left: 25,
      right: 25,
    ),
    padding: const EdgeInsets.all(5),
    alignment: Alignment.center,
    height: 45,
    decoration: const BoxDecoration(
      color: Colors.white, //输入框中的背景色
//        border: new Border.all(color: Color(0xFFEEEEEE), width: 0.9), //边框颜色和宽度
      // borderRadius: BorderRadius.circular(5),
      border: Border(
        bottom: BorderSide(
          color: ColorName.borderColorE2e4ea,
        ),
      ),
    ),
    //边框圆角大小
    child: Row(
      children: <Widget>[
        Expanded(
          child: SupportCupertinoTextField(
            controller: _c,
            autofocus: autofocus,
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                  maxLength == 0 ? 100 : maxLength),
              ...?inputFormatters,
            ],
            style: FSUtils.font_normal_14_colorFF666666,
            keyboardType: inputType ?? TextInputType.text,
            decoration: const BoxDecoration(
              border: Border(),
            ),
            padding: EdgeInsets.zero,
            placeholder: hintText,
            cursorHeight: 22,
            /*  decoration: InputDecoration(
              hintText: hintText,
              hintStyle: FSUtils.font_normal_14_colorFFCCCCCC,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: -22),
            ),*/
            onChanged: (v) {
              //通知改变
              valueNotifier.value = v.length;
              return onChanged.call(v);
            },
          ),
        ),
        Visibility(
          visible: !hideNumberTips,

          ///是否显示字数限制提示   ValueNotifier<int> valueNotifier = ValueNotifier<int>(0);
          child: ValueListenableBuilder(
            valueListenable: valueNotifier,
            builder: (BuildContext context, value, Widget? child) {
              return Text(
                '${value}/${maxLength}',
                style: FSUtils.font_normal_14_colorFF858B9C,
              );
            },
          ),
        )
      ],
    ),
  );
}

///创建一个竖向 content的输入框
Widget buildVerticalInputWidget(
  String content,
  String text,
  String hintText,
  int maxLength,
  ValueChanged<String> onChanged, {
  bool applyToGoodsPicBack = false,
  bool showCheck = false,
  autofocus: false,
  TextInputType? inputType,
  BuildContext? context = null,
  bool hideNumberTips = true,
}) {
  final _c = TextEditingController();
  if (ObjectUtil.isNotEmpty(text)) {
    _c.text = text;
    _c.selection =
        TextSelection(baseOffset: text.length, extentOffset: text.length);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      if (ObjectUtil.isNotEmpty(content))
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 10),
          child: SizedBox(
            child: Text(
              content,
              style: FSUtils.font_normal_14_colorFF111111,
            ),
          ),
        ),
      Container(
        margin: EdgeInsets.only(
            left: 25, right: 25, top: ObjectUtil.isNotEmpty(content) ? 20 : 0),
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        height: 35,
        decoration: BoxDecoration(
          color: ColorName.bgColor, //输入框中的背景色
//        border: new Border.all(color: Color(0xFFEEEEEE), width: 0.9), //边框颜色和宽度
          borderRadius: BorderRadius.circular(5),
        ),
        //边框圆角大小
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: _c,
                autofocus: autofocus,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                    maxLength == 0 ? 100 : maxLength,
                  )
                ],
                style: FSUtils.font_normal_14_colorFF666666,
                keyboardType: inputType ?? TextInputType.text,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: FSUtils.font_normal_14_colorFFCCCCCC,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: -22),
                ),
                onChanged: (v) {
                  //通知改变
                  valueNotifier.value = v.length;
                  return onChanged.call(v);
                },
              ),
            ),
            Visibility(
              visible: !hideNumberTips,

              ///是否显示字数限制提示   ValueNotifier<int> valueNotifier = ValueNotifier<int>(0);
              child: ValueListenableBuilder(
                valueListenable: valueNotifier,
                builder: (BuildContext context, value, Widget? child) {
                  return Text(
                    '${value}/${maxLength}',
                    style: FSUtils.font_normal_14_colorFF858B9C,
                  );
                },
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: Stack(
          children: [
            const Positioned(
              left: 80,
              top: 10,
              bottom: 0,
              child: Center(
                child: Text(
                  '建议尺寸750px*750px',
                  style: FSUtils.font_normal_14_colorFF858B9C,
                ),
              ),
            )
          ],
        ),
      ),
      Visibility(
        visible: showCheck,
        child: ValueListenableBuilder(
          valueListenable: applyToGoodsPicValue,
          builder: (BuildContext context, bool value, Widget? child) {
            return ZzCheckboxListTile(
              value: applyToGoodsPicValue.value,
              onChanged: (value) {
                applyToGoodsPicBack = value!;
                applyToGoodsPicValue.value = value;
              },
              controlAffinity: ListTileControlAffinity.leading,
              // shape: const CircleBorder(),
              activeColor: Colors.blue,
              checkColor: Colors.white,
              title: const Text(
                '将品牌图片应用为无图商品主图',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: FSUtils.font_normal_14_colorFF111A34,
              ),
              onNextLevel: (bool? value) {},
            );
          },
        ),
      )
    ],
  );
}

///输入
class InputBorderItem extends StatelessWidget {
  InputBorderItem({
    Key? key,
    this.content = '输入项',
    this.hintText = '请输入',
    this.text = '',
    this.index = 0,
    this.callBack,
    this.textWidget,
    this.inputType,
    this.focusNode,
    this.maxLines = 1,
    this.height,
    this.enable = true,
  }) : super(key: key);

  final String content;
  final String hintText;
  final String text;
  final int index;
  final Function(int, String)? callBack;
  final double? textWidget;
  final TextInputType? inputType;
  final FocusNode? focusNode;
  final int maxLines;
  final double? height;
  final bool enable;

  ///多行时指定高度

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (ObjectUtil.isNotEmpty(text)) {
      _controller.text = text;
      _controller.selection =
          TextSelection(baseOffset: text.length, extentOffset: text.length);
    }
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25),
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      height: maxLines > 1 ? height : 35.0,
      decoration: BoxDecoration(
        color: enable ? ColorName.bgColor : Colors.white, //输入框中的背景色
//          border: new Border.all(color: Color(0xFFEEEEEE), width: 0.9), //边框颜色和宽度
        borderRadius: BorderRadius.circular(5),
      ),
      //边框圆角大小
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: SizedBox(
              width: textWidget ?? 60,
              child: Text(
                content,
                style: FSUtils.font_normal_14_colorFF111111,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _controller,
              maxLines: maxLines,
              focusNode: focusNode,
              keyboardType: inputType ?? TextInputType.text,
              style: FSUtils.font_normal_14_colorFF666666,
              enabled: enable,
              inputFormatters: [LengthLimitingTextInputFormatter(20)],
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: FSUtils.font_normal_14_colorFFCCCCCC,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: maxLines > 1 ? -10 : -22),
              ),
              onChanged: (text) {
                if (callBack != null) {
                  callBack!(index, text);
                }
              },
              onEditingComplete: () {},
            ),
          )
        ],
      ),
    );
  }
}

///选择
class SelectBorderItem extends StatelessWidget {
  SelectBorderItem({
    Key? key,
    this.content = '输入项',
    this.hintText = '请选择',
    this.text = '',
    this.textWidget,
    this.index = 0,
    this.callBack,
  }) : super(key: key);

  final String content;
  final String hintText;
  final String text;
  final double? textWidget;
  final int index;
  final Function(int)? callBack;

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (ObjectUtil.isNotEmpty(text)) {
      _controller.text = text;
    }
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25),
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      height: 35,
      decoration: BoxDecoration(
        color: ColorName.bgColor, //输入框中的背景色
//          border: new Border.all(color: Color(0xFFEEEEEE), width: 0.9), //边框颜色和宽度
        borderRadius: BorderRadius.circular(5),
      ),
      //边框圆角大小
      child: InkWell(
        onTap: () {
          if (callBack != null) {
            callBack!(index);
          }
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: SizedBox(
                width: textWidget ?? 60,
                child: Text(
                  content,
                  style: FSUtils.font_normal_14_colorFF111111,
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: _controller,
                enabled: false,
                style: FSUtils.font_normal_14_colorFF666666,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: FSUtils.font_normal_14_colorFFCCCCCC,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: -22),
                ),
              ),
            ),
            CommonWidgetUtils.icon_arrow_right_12,
          ],
        ),
      ),
    );
  }
}

// class SingleTextSelectDialog extends StatefulWidget {
//   SingleTextSelectDialog({
//     Key? key,
//     this.title = '标题',
//     required this.list,
//     required this.itemName,
//     this.confirmText = '确认',
//     this.cancelText = '取消',
//     this.onConfirm,
//     this.onCancel,
//     this.hiddenCancelBtn = false,
//     this.autoFinish = true,
//     this.maxHeight,
//     this.width,
//   })  : assert(ObjectUtil.isNotEmpty(list)),
//         assert(itemName != null),
//         super(key: key);
//
//   final String title;
//   final List list;
//   final String confirmText;
//   final String cancelText;
//   final Function(dynamic)? onConfirm;
//   final Function? onCancel;
//   final bool hiddenCancelBtn;
//   final bool autoFinish;
//   final double? maxHeight;
//   final double? width;
//   final Function(String) itemName;
//
//   @override
//   _SingleTextSelectDialogState createState() => _SingleTextSelectDialogState();
// }
//
// class _SingleTextSelectDialogState extends State<SingleTextSelectDialog> {
//   late List list;
//   int i = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     list = List.generate(widget.list.length, (index) {
//       var info = widget.list[index];
//       return {'info': info, 'index': index};
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CenterBaseDialog(
//       title: widget.title,
//       cancelText: widget.cancelText,
//       confirmText: widget.confirmText,
//       hiddenTitle: widget.title == null || widget.title.isEmpty,
//       width: widget.width ?? 270,
//       maxHeight: widget.maxHeight ?? 350,
//       onPressed: () {
//         if (widget.autoFinish) Navigator.pop(context);
//         if (widget.onConfirm != null) widget.onConfirm!(list[i]['info']);
//       },
//       onCancel: widget.onCancel,
//       hiddenCancelBtn: widget.hiddenCancelBtn ?? false,
//       child: ListView.separated(
//           itemBuilder: (c, i) {
//             return _itemWidget(list[i]);
//           },
//           separatorBuilder: (c, i) => const SizedBox.shrink(),
//           itemCount: widget.list.length,
//       ),
//     );
//   }
//
//   Widget _itemWidget(info) {
//     int index = info['index'];
//     return GestureDetector(
//       behavior: HitTestBehavior.translucent,
//       onTap: () {
//         if (i != index)
//           setState(() {
//             i = index;
//           });
//       },
//       child: Container(
//         child: Row(
//           children: <Widget>[
//             CircleCheckBox(
//               checked: index == i,
//               clickPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               onChange: (change) {
//                 if (i != index)
//                   setState(() {
//                     i = index;
//                   });
//               },
//             ),
//             Expanded(
//               child: Text(
//                 widget.itemName(info['info']),
//                 style: FSUtils.font_normal_12_colorFF666666,
//               ),
//             ),
//             const SizedBox(width: 10,),
//           ],
//         ),
//       ),
//     );
//   }
// }
