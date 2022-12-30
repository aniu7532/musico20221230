import 'package:flutter/material.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/utils/font_style_utils.dart';

class ZzNodataViewWidget extends StatefulWidget {
  const ZzNodataViewWidget({
    Key? key,
    this.title,
    this.iconData/*= ZzIcons.icon_xinxi*/,
  }) : super(key: key);

  final String? title; // 提示文案
  final IconData? iconData; // 图片

  @override
  State<ZzNodataViewWidget> createState() => _ZzNodataViewWidgetState();
}

class _ZzNodataViewWidgetState extends State<ZzNodataViewWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(children: [
      Expanded(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const Spacer(),
              if (widget.iconData != null)
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Icon(
                    widget.iconData,
                    color: const Color(0xFFFF5B60),
                  ),
                )
              else
                Assets.images.noData.defaultNoTrack.image(
                    width: screenWidth / 2,
                    height: screenWidth / 2,
                    fit: BoxFit.fill),
              const SizedBox(
                height: 16,
              ),
              Text(
                widget.title ?? '',
                style: FSUtils.font_normal_16_colorFF858B9C,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    ]);
  }
}
