import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musico/const/app_const.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/widgets/support_cupertino_textfield.dart';

typedef EnableTextChange = Future<bool> Function(String text);

///一个简单的输入框，默认部分属性
class ZzSimpleTextField extends StatefulWidget {
  const ZzSimpleTextField({
    Key? key,
    this.enabled = true,
    this.autofocus = false,
    this.textEditingController,
    this.placeholderText = '请输入',
    this.placeholderTextStyle = const TextStyle(
      fontSize: 16,
      color: ColorName.hintTxtColor,
    ),
    this.defaultText,
    this.textStyle = const TextStyle(
      fontSize: 16,
      color: ColorName.textColor111a34,
    ),
    this.maxLines = 1,
    this.padding = AppConst.kInputTextFieldPadding,
    this.bgColor = Colors.white,
    this.border = const Border(),
    this.borderRadius = BorderRadius.zero,
    this.onChanged,
    this.onSubmit,
    this.onEditingComplete,
    this.textAlign = TextAlign.start,
    this.maxLength,
    this.inputType,
    this.inputFormatters,
    this.focusNode,
    this.onUnFocused,
    this.minWidth = 20.0,
    this.maxWidth = double.infinity,
    this.enableAdaptiveWidth = false,
    this.isUnFocusEnableTextChange,
    this.cursorHeight = 26.0,
  }) : super(key: key);

  final bool enabled;
  final bool autofocus;
  final TextEditingController? textEditingController;
  final String placeholderText;
  final TextStyle placeholderTextStyle;
  final String? defaultText;
  final TextStyle textStyle;
  final int maxLines;
  final EdgeInsets padding;
  final Color bgColor;
  final Border border;
  final BorderRadius borderRadius;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final VoidCallback? onEditingComplete;
  final TextAlign textAlign;
  final int? maxLength;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final ValueChanged<String>? onUnFocused; //失去焦点回调输入内容
  final double cursorHeight;

  /// 最小和最大宽度，enableAdaptiveWidth为true时生效，在最大值和最小值范围内自适应宽度
  final double minWidth;
  final double maxWidth;

  /// 是否自适应宽度，为true则根据内容自适应输入框宽度，同时受minWidth和maxWidth限制。
  final bool enableAdaptiveWidth;

  /// 是否允许改变，在值改变之前回调，如果返回false则改变不生效，以进入焦点为起始值，失去焦点为结束值进行判断
  final EnableTextChange? isUnFocusEnableTextChange;

  @override
  State<ZzSimpleTextField> createState() => _ZzSimpleTextFieldState();
}

class _ZzSimpleTextFieldState extends State<ZzSimpleTextField> {
  late TextEditingController textEditingController;
  late FocusNode _focusNode;

  /// 进入焦点时，缓存当前的输入值，失去焦点时改变不允许生效则需要回退到当前值
  String _text = '';
  @override
  void initState() {
    textEditingController =
        widget.textEditingController ?? TextEditingController();
    textEditingController.text =
        widget.defaultText ?? textEditingController.text;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _text = textEditingController.text;
      }
      //失去焦点，并且值没有改变时，才回调unFocus
      if (!_focusNode.hasFocus) {
        isUnFocusEnableTextChanged().then((value) {
          if (value) {
            widget.onUnFocused?.call(textEditingController.text);
          }
        });
      }
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ZzSimpleTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.defaultText != widget.defaultText) {
      final value = widget.defaultText ?? '';
      final selection = TextSelection(
        baseOffset: value.length,
        extentOffset: value.length,
      );
      textEditingController.value = textEditingController.value.copyWith(
        text: value,
        selection: selection,
      );
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    // 外部传进来的focusNode，由外部处理生命周期。否则输入框隐藏再显示会报错
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
  }

  /// 监听文本改变过程，如果不允许改变，则回退值
  /// 仅处理进入焦点到失去焦点首尾过程，通过enableTextChange方法判断
  /// 如果允许改变，则回调onUnFocus方法，如果不允许则不回调
  Future<bool> isUnFocusEnableTextChanged() async {
    final oldText = _text;
    final newText = textEditingController.text;
    if (widget.isUnFocusEnableTextChange != null) {
      final enable = await widget.isUnFocusEnableTextChange!(newText);
      if (!enable) {
        final selection = TextSelection(
          baseOffset: oldText.length,
          extentOffset: oldText.length,
        );
        textEditingController.value = textEditingController.value.copyWith(
          text: oldText,
          selection: selection,
        );
        setState(() {});
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final textField = SupportCupertinoTextField(
      cursorHeight: widget.cursorHeight,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      controller: textEditingController,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      placeholder: widget.placeholderText,
      placeholderStyle: widget.placeholderTextStyle,
      style: widget.textStyle,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.bgColor,
        border: widget.border,
        borderRadius: widget.borderRadius,
      ),
      keyboardType: widget.inputType ?? TextInputType.text,
      inputFormatters: [
        ...?widget.inputFormatters,
      ],
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmit,
      onEditingComplete: widget.onEditingComplete,
      textAlign: widget.textAlign,
      focusNode: _focusNode,
    );
    if (widget.enableAdaptiveWidth) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final maxWidth = math.min(constraints.maxWidth, widget.maxWidth);
          return ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: widget.minWidth,
              maxWidth: maxWidth,
            ),
            child: IntrinsicWidth(
              child: textField,
            ),
          );
        },
      );
    } else {
      return textField;
    }
  }
}
