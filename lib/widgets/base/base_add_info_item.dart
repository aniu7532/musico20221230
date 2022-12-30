// ignore_for_file: must_be_immutable, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:musico/utils/divider_urils.dart';
import 'package:musico/utils/font_style_utils.dart';

class BaseAddInfoItem extends StatelessWidget {
  String title;
  final bool showItem; //是否显示该widget
  final VoidCallback onPressed;
  BaseAddInfoItem({
    Key? key,
    required this.title,
    required this.onPressed,
    this.showItem = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showItem) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 17, 20, 0),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.5),
            child: Row(
              children: <Widget>[
                Text(title, style: FSUtils.font_normal_15_colorFF111111),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: onPressed,
                  child: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          dividerCustomerNoIndent,
        ],
      ),
    );
  }
}
