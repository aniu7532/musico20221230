import 'package:auto_route/auto_route.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/const/app_const.dart';
import 'package:musico/utils/common_widget_utils.dart';
import 'package:musico/utils/divider_urils.dart';
import 'package:musico/utils/font_style_utils.dart';

typedef GetSelectorName<T> = String Function(T value);
typedef VerifyBeforeOnClick = bool Function();
typedef VerifyAfterOnClick = bool Function(dynamic);
typedef GetParams<T> = T? Function();

///
///选择控件基类
///
class BaseSelectorItem<T> extends StatefulWidget {
  const BaseSelectorItem({
    Key? key,
    required this.title,
    required this.getSelectorName,
    required this.route,
    this.onChangedCallback,
    this.hintText,
    this.initName,
    this.isMust = false,
    this.showDividerLine = true,
    this.canEditable = true,
    this.verifyBeforeOnClick,
    this.verifyAfterOnClick,
    this.getParams,
    this.color = Colors.white,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: AppConst.EDITOR_ITEM_TOP_BOTTOM),
    this.padding =
        const EdgeInsets.symmetric(horizontal: AppConst.EDITOR_ITEM_INDENT),
  }) : super(key: key);

  final ValueChanged? onChangedCallback;
  final String title;
  final String? hintText;
  final String? initName;

  ///是否显示*
  final bool isMust;

  ///获取选择后显示的文字
  final GetSelectorName getSelectorName;

  ///显示分割线 默认显示
  final bool showDividerLine;

  ///是否可以编辑 默认可编辑
  final bool canEditable;

  final EdgeInsets contentPadding; //除下划线外内容padding
  final EdgeInsets padding; //整个组件的padding

  ///点击时前置判断
  final VerifyBeforeOnClick? verifyBeforeOnClick;

  ///点击时后置判断
  final VerifyAfterOnClick? verifyAfterOnClick;

  final PageRouteInfo route;

  ///传递的参数
  final GetParams? getParams;
  final Color color;

  @override
  _BaseSelectorItemState<T> createState() => _BaseSelectorItemState<T>();
}

class _BaseSelectorItemState<T> extends State<BaseSelectorItem<T>> {
  T? selectData;
  String? storeName;

  @override
  void initState() {
    super.initState();
    storeName ??= widget.initName;
    if (ObjectUtil.isEmpty(storeName)) storeName = null;
  }

  @override
  void didUpdateWidget(covariant BaseSelectorItem<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initName != widget.initName && widget.initName != null) {
      storeName = widget.initName;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectData != null) storeName = widget.getSelectorName(selectData);

    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (widget.onChangedCallback != null && widget.canEditable) {
                _selectStore(context);
              }
            },
            child: Container(
              padding: widget.contentPadding,
              child: Row(
                children: <Widget>[
                  Text(widget.title,
                      style: FSUtils.font_normal_15_colorFF111111),
                  const SizedBox(width: 3),
                  Offstage(
                    offstage: !widget.isMust,
                    child: const Text('*', style: TextStyle(color: Colors.red)),
                  ),
                  const SizedBox(width: 10),
                  //
                  Expanded(
                    child: Text(
                      storeName ?? widget.hintText ?? '请选择',
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: storeName != null
                          ? FSUtils.font_normal_14_colorFF666666
                          : FSUtils.font_normal_14_colorFFCCCCCC,
                    ),
                  ),
                  Visibility(
                    visible: widget.canEditable,
                    child: Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: widget.canEditable
                          ? CommonWidgetUtils.icon_arrow_right_12
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.showDividerLine) dividerNormal1,
        ],
      ),
    );
  }

  void _selectStore(BuildContext context) async {
    if (widget.verifyBeforeOnClick != null) {
      if (!widget.verifyBeforeOnClick!()) return;
    }

    ///默认多选
    final result = await appRouter.push(widget.route);

    ///默认返回
    if (result != null) {
      if (widget.verifyAfterOnClick != null &&
          !widget.verifyAfterOnClick!(result)) {
        return;
      }
      selectData = result as T;
      if (widget.onChangedCallback != null) {
        widget.onChangedCallback!(result);
      }
    }
  }
}
