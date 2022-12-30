// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:musico/const/app_const.dart';
import 'package:musico/utils/common_widget_utils.dart';
import 'package:musico/utils/divider_urils.dart';
import 'package:musico/utils/font_style_utils.dart';

class BaseSelectAreaItem extends StatelessWidget {
  BaseSelectAreaItem({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.selectArea,
    this.showMust = false,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: AppConst.EDITOR_ITEM_TOP_BOTTOM),
    this.padding =
        const EdgeInsets.symmetric(horizontal: AppConst.EDITOR_ITEM_INDENT),
    this.showDivider = true,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;
  final String? selectArea;
  bool showMust; //是否显示必填
  final EdgeInsets contentPadding; //除下划线外内容padding
  final EdgeInsets padding; //整个组件的padding
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: padding,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: contentPadding,
              child: Row(
                children: <Widget>[
                  Text(title, style: FSUtils.font_normal_15_colorFF111111),
                  const SizedBox(width: 3),
                  if (showMust)
                    const Text(
                      '✱',
                      style: TextStyle(
                        color: Color(0xFFff0000),
                        fontSize: 11,
                      ),
                    )
                  else
                    const Text(''),
                  const SizedBox(width: 10),
                  Expanded(
                    child: selectArea!.isNotEmpty
                        ? Text(
                            selectArea!,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : const Text(
                            '请选择',
                            textAlign: TextAlign.end,
                            style: FSUtils.font_normal_14_colorFFCCCCCC,
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: CommonWidgetUtils.icon_arrow_right_12,
                  ),
                  // const ZzIconButton(
                  //   onPressed: () {},
                  //   icon: Icon(
                  //     Icons.location_on_outlined,
                  //     color: Colors.blue,
                  //     size: 22,
                  //   ),
                  // ),
                ],
              ),
            ),
            if (showDivider) dividerNormal1,
          ],
        ),
      ),
    );
  }
}
