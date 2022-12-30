import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/widgets/dialog/center_base_dialog.dart';
import 'package:musico/widgets/dialog/show_dialog.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

//展示 弹出Dialog 两个按钮 + title +内容自己确定
showCommonDialog(
  BuildContext context, {
  String? title,
  EdgeInsets? titlePadding,
  required Widget child,
  Function? onConfirm,
  Function? onCancel,
  Function? onBack,
  String? confirmText,
  String? cancelText,
  bool hideCancelBtn = false,
  bool hideConfirmBtn = false,
  bool hideTitle = false,
  bool enableConfirmBtn = true,
  Function? onVerifyBeforeConfirm,
  double? width,
  double topTitle = 10,
  //标题到顶部的距离
  double? verticalMarginChild,
  //child 上下的间距
  bool useConfirmFinish = true,
  double maxHeight = 420,
  double contentBottomMargin = 10,
  bool showCloseButton = false,
  Color cancelColor = const Color(0xFF999999),
}) async {
  return await showElasticDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CenterBaseDialog(
          width: width ?? ScreenUtil.getScreenW(context) * 0.8,
          title: title ?? '标题',
          titlePadding: titlePadding,
          confirmText: confirmText ?? '确定',
          cancelText: cancelText ?? '取消',
          hiddenCancelBtn: hideCancelBtn,
          hiddenConfirmBtn: hideConfirmBtn,
          hiddenTitle: hideTitle,
          enableConfirmBtn: enableConfirmBtn,
          top: topTitle,
          maxHeight: maxHeight,
          contentBottomMargin: contentBottomMargin,
          showCloseButton: showCloseButton,
          cancelColor: cancelColor,
          onPressed: () async {
            if (onVerifyBeforeConfirm != null) {
              if (await onVerifyBeforeConfirm()) {
                Navigator.pop(context);
                if (onConfirm != null) onConfirm();
              }
            } else {
              if (useConfirmFinish) Navigator.pop(context);
              if (onConfirm != null) onConfirm();
            }
          },
          onCancel: () {
            if (onCancel != null) onCancel();
          },
          onBack: onBack,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: verticalMarginChild ?? 12),
            child: child,
          ),
        );
      });
}

///展示文字提示选择弹窗
showTextDialog(
  BuildContext context, {
  String title = '',
  required String content,
  String confirmText = '确定',
  String cancelText = '取消',
  Function? onConfirm,
  Function? onConfirmWithCheckBox,
  Function? onCancel,
  Function? onBack,
  bool hiddenCancelBtn = false,
  bool hiddenConfirmBtn = false,
  bool showCheckBox = false,
  bool autoFinish = true,
  double bottom = 10,
}) async {
  return await showElasticDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return TextDialog(
          title: title,
          content: content,
          confirmText: confirmText,
          onConfirm: onConfirm,
          onConfirmWithCheckBox: onConfirmWithCheckBox,
          cancelText: cancelText,
          onCancel: onCancel,
          onBack: onBack,
          showCheckBox: showCheckBox,
          hiddenCancelBtn: hiddenCancelBtn,
          hiddenConfirmBtn: hiddenConfirmBtn,
          autoFinish: autoFinish,
          bottom: bottom,
        );
      });
}

///展示文字提示选择弹窗
// Future showSingleSelectDialog({
//   String title = "",
//   required List list,
//   required GetItemName itemName,
//   String confirmText: '确定',
//   String cancelText: '取消',
//   Function(dynamic) onConfirm,
//   Function onCancel,
//   bool hiddenCancelBtn,
//   bool autoFinish: true,
//   double maxHeight,
//   double width,
// }) async {
//   return await showElasticDialog(
//       context: AppData.rootContext,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return SingleTextSelectDialog(
//           title: title,
//           list: list,
//           itemName: itemName,
//           confirmText: confirmText,
//           onConfirm: onConfirm,
//           cancelText: cancelText,
//           onCancel: onCancel,
//           hiddenCancelBtn: hiddenCancelBtn,
//           autoFinish: autoFinish,
//           maxHeight: maxHeight,
//           width: width,
//         );
//       });
// }

///单个输入框
showInputDialog(
  BuildContext context, {
  String title = '输入弹窗',
  String content = '输入项',
  String text = '',
  String hintText = '请输入',
  int maxLength = 0,
  Function(String)? onPressed,
  Function? onCancel,
  autofocus = true,
  autoFinish = true,
  TextInputType? inputType,
  String? confirmText,
  String? cancelText,
  List<TextInputFormatter>? inputFormatters,
}) async {
  String value = text;
  await showElasticDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CenterBaseDialog(
          width: ScreenUtil.getScreenW(context) * 0.8,
          title: title,
          confirmText: confirmText ?? '确定',
          cancelText: cancelText ?? '取消',
          onPressed: () {
            if (autoFinish) Navigator.pop(context);
            if (onPressed != null) onPressed(value);
          },
          onCancel: () {
            if (onCancel != null) onCancel();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: buildInputWidget(
              content,
              value,
              hintText,
              maxLength,
              (input) {
                value = input;
              },
              autofocus: autofocus,
              inputType: inputType,
              inputFormatters: inputFormatters,
            ),
          ),
        );
      });
}

///多个输入框
showXInputDialog(
  BuildContext context, {
  String title = "输入弹窗",
  required List<String> hintData,
  required List<String> textList, //必须与hintData的长度一致
  List<bool>? enableList,
  bool back = true,
  Function(List)? onConfirm,
  double? textWidth,
}) {
  List<Widget> children = [];

  if (ObjectUtil.isEmpty(textList)) {
    textList = [];
  } else {
    assert(hintData.length == textList.length);
  }

  bool isNeedAdd = textList.length == 0;

  for (var i = 0; i < hintData.length; i++) {
    if (isNeedAdd) {
      textList.add("");
    }
    var enable = true;
    if (enableList != null) {
      enable = enableList[i];
    }
    children.add(InputBorderItem(
      content: hintData[i],
      index: i,
      text: textList[i],
      callBack: (index, text) {
        textList[index] = text;
      },
      textWidget: textWidth,
      enable: enable,
    ));
  }

  showElasticDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CenterBaseDialog(
            width: ScreenUtil.getScreenW(context) * 0.8,
            title: title,
            onPressed: () {
              if (back) appRouter.pop();
              if (onConfirm != null) {
                onConfirm(textList);
              }
            },
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        children[index],
                      ],
                    );
                  }
                  return children[index];
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 12,
                  );
                },
                itemCount: children.length));
      });
}

///展示文字提示选择弹窗
/// pda 设计的样式
showZzTextDialog(
  BuildContext context, {
  String title = '',
  required String content,
  String? subContent,
  String confirmText = '确定',
  String cancelText = '取消',
  Function? onConfirm,
  Function? onConfirmWithCheckBox,
  Function? onCancel,
  Function? onBack,
  bool hiddenCancelBtn = false,
  bool hiddenConfirmBtn = false,
  bool autoFinish = true,
  double bottom = 10,
  double radius = 4,
}) async {
  return await showElasticDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return TextDialog(
          title: title,
          content: content,
          subContent: subContent,
          radius: radius,
          confirmText: confirmText,
          onConfirm: onConfirm,
          onConfirmWithCheckBox: onConfirmWithCheckBox,
          cancelText: cancelText,
          onCancel: onCancel,
          onBack: onBack,
          hiddenCancelBtn: hiddenCancelBtn,
          hiddenConfirmBtn: hiddenConfirmBtn,
          autoFinish: autoFinish,
          bottom: bottom,
          contentPaddingVertical: 10,
          contentPaddingHorizontal: 30,
        );
      });
}

///单个输入框
/// pda 设计的样式
showZzLoadingDialog(
  BuildContext context, {
  String title = 'Waiting',
  String content = 'loading',
  String text = '',
  Function(String)? onPressed,
  Function? onCancel,
  autofocus = true,
  autoFinish = true,
  String? confirmText,
  String? cancelText,
  bool cancelAble = false,
  bool small = false,
}) async {
  await showElasticDialog(
      context: context,
      barrierDismissible: small ? small : cancelAble,
      builder: (BuildContext context) {
        return BaseDialog(
          cancelAble: small ? small : cancelAble,
          child: small
              ? Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E2F32),
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: LoadingAnimationWidget.inkDrop(
                      color: ColorName.secondaryColor,
                      size: 20,
                    ),
                  ),
                )
              : Container(
                  height: 240,
                  width: 260,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E2F32),
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 27,
                      ),
                      Text(
                        title,
                        style: FSUtils.weight500_22_9BDD18,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        content,
                        style: FSUtils.normal_16_FFFFFF,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        child: LoadingAnimationWidget.inkDrop(
                          color: ColorName.secondaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (cancelAble) {
                            Navigator.pop(context);
                            onCancel?.call();
                          }
                        },
                        child: Container(
                          width: 222,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff46B112),
                                Color(0xffD0F91B),
                              ],
                            ),
                          ),
                          child: Text(
                            cancelText ?? 'Cancel',
                            style: FSUtils.weight500_18_ffffff,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        );
      });
}

///单个输入框
/// pda 设计的样式
showZzInputDialog(
  BuildContext context, {
  String title = '输入弹窗',
  String content = '',
  String text = '',
  String hintText = '请输入',
  int maxLength = 4,
  Function(String)? onPressed,
  Function? onCancel,
  autofocus = true,
  autoFinish = true,
  TextInputType? inputType,
  String? confirmText,
  String? cancelText,
  bool hideNumberTips = false,
  List<TextInputFormatter>? inputFormatters,
}) async {
  String value = text;
  await showElasticDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CenterBaseDialog(
          width: ScreenUtil.getScreenW(context) * 0.8,
          title: title,
          radius: 4,
          titleStytle: FSUtils.dialog_title_stytle,
          cancelColor: const Color.fromARGB(255, 102, 111, 131),
          confirmText: confirmText ?? '确认',
          cancelText: cancelText ?? '取消',
          onPressed: () {
            if (autoFinish) Navigator.pop(context);
            if (onPressed != null) onPressed(value);
            valueNotifier.value = 0;
          },
          onCancel: () {
            if (onCancel != null) onCancel();
            valueNotifier.value = 0;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: buildInputWidget(
              content,
              value,
              hintText,
              maxLength,
              (input) {
                value = input;
              },
              context: context,
              autofocus: autofocus,
              inputType: inputType,
              hideNumberTips: hideNumberTips,
              inputFormatters: inputFormatters,
            ),
          ),
        );
      });
}

/// 默认dialog背景色为半透明黑色，这里修改源码改为透明
Future<T?> showTransparentDialog<T>({
  required BuildContext context,
  bool barrierDismissible = false,
  required WidgetBuilder builder,
  Color? barrierColor,
}) {
  final theme = Theme.of(context);
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        child: Builder(builder: (BuildContext context) {
          return theme != null
              ? Theme(data: theme, child: pageChild)
              : pageChild;
        }),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor ?? const Color(0x80000000),
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: _buildMaterialDialogTransitions,
  );
}

Widget _buildMaterialDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

Future<T?> showElasticDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  int duration = 550,
  required WidgetBuilder builder,
}) {
  final theme = Theme.of(context);
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        child: Builder(builder: (BuildContext context) {
          return theme != null
              ? Theme(data: theme, child: pageChild)
              : pageChild;
        }),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: Duration(milliseconds: duration),
    transitionBuilder: _buildDialogTransitions,
  );
}

Widget _buildDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero)
          .animate(CurvedAnimation(
        parent: animation,
        curve: animation.status != AnimationStatus.forward
            ? Curves.easeOutBack
            : const ElasticOutCurve(0.85),
      )),
      child: child,
    ),
  );
}

///底部弹出式 title
class BottomTitleWidget extends StatelessWidget {
  const BottomTitleWidget(
      {Key? key,
      this.cancelText = '取消',
      this.title,
      this.confirmText = '确定',
      this.onCancel,
      this.onConfirm,
      this.titleWidget})
      : super(key: key);

  final String cancelText;
  final String? title;
  final String confirmText;
  final Function? onCancel;
  final Function? onConfirm;
  final Widget? titleWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(246, 246, 246, 1),
      child: Row(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                if (onCancel != null) {
                  onCancel!();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    cancelText,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF111111),
                        fontWeight: FontWeight.normal),
                  ))),
          const Spacer(),
          titleWidget ??
              Text(
                title ?? '',
                style: FSUtils.font_normal_14_colorFF111111,
              ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              if (onConfirm != null) {
                onConfirm!();
              } else {
                Navigator.pop(context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                confirmText,
                style: const TextStyle(
                  fontSize: 15,
                  color: ColorName.themeColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
