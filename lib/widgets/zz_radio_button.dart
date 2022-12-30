import 'package:musico/app/zz_icon.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class ZzRadioButton extends StatefulWidget {
  const ZzRadioButton({
    Key? key,
    this.value = false,
    this.onChanged,
    this.iconSize = 16.0,
    this.onlyChangeByValue = false,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final bool value;

  final ValueChanged<bool>? onChanged;

  final double iconSize;

  /// 只随着外部传进来的value改变值
  final bool onlyChangeByValue;

  final EdgeInsets padding;

  @override
  State<ZzRadioButton> createState() => _ZzRadioButtonState();
}

class _ZzRadioButtonState extends State<ZzRadioButton> {
  late bool _isSelected;

  @override
  void initState() {
    _isSelected = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ZzRadioButton oldWidget) {
    if (oldWidget.value != widget.value) {
      _isSelected = widget.value;
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!widget.onlyChangeByValue) {
          _isSelected = !_isSelected;
          widget.onChanged?.call(_isSelected);
        } else {
          widget.onChanged?.call(!_isSelected);
        }
      },
      child: Container(
        padding: widget.padding,
        child: _isSelected
            ? Icon(
                ZzIcons.icon_qianshou,
                size: widget.iconSize,
                color: ColorName.secondaryColor,
              )
            : Container(
                width: widget.iconSize,
                height: widget.iconSize,
                decoration: BoxDecoration(
                  color: ColorName.themeColor,
                  borderRadius: BorderRadius.circular(widget.iconSize / 2),
                  border: Border.all(
                    color: ColorName.hintTxtColor,
                  ),
                ),
              ),
      ),
    );
  }
}
