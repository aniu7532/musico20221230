import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:musico/app/zz_icon.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/utils/size_utils.dart';

enum SearchType {
  TEXT,
  VOICE,
  SCAN,
}

///搜索输入框
class SearchTextFieldWidget extends StatefulWidget {
  const SearchTextFieldWidget({
    Key? key,
    this.onClearCallback,
    this.onSubmitCallback,
    this.onChangeCallback,
    this.autoComplete = false,
    this.forceComplete = false,
    this.hintText,
    this.keyWord,
    this.autoFocus = false,
    this.showSearchButton = true,
    this.showVoiceButton = false,
    this.showScanCodeButton = false,
    this.canPda = true,
    this.focusNode,
    this.bgColor,
    this.textEditingController,
    this.onSearchType,
    this.showManualButton = false,
    this.scanDialogTitle,
    this.scanFitterCallback,
  }) : super(key: key);

  ///清除回调
  final VoidCallback? onClearCallback;

  ///完成回调
  final ValueChanged? onSubmitCallback;

  ///自动完成回调
  final bool autoComplete;

  ///强制完成回调
  final bool forceComplete;

  ///输入变化时回调
  final ValueChanged? onChangeCallback;

  ///没有输入时默认提示文字
  final String? hintText;

  ///默认值
  final String? keyWord;

  ///进入页面后是否直接获取输入框焦点
  final bool? autoFocus;

  ///显示搜索按钮
  final bool showSearchButton;

  //是否显示语音输入
  final bool showVoiceButton;

  ///是否显示扫码输入
  final bool showScanCodeButton;

  ///扫码是否可返回
  final bool canPda;

  ///
  final FocusNode? focusNode;

  final Color? bgColor;

  ///
  final TextEditingController? textEditingController;

  ///搜索方式回调
  final Function? onSearchType;

  ///打开全屏搜索是否显示手动输入
  final bool showManualButton;
  final String? scanDialogTitle;

  /// 扫码过滤器，如果设置了该方法并且返回false的话则会抛弃本次扫码结果
  final bool Function(String code)? scanFitterCallback;

  @override
  _SearchTextFieldWidgetState createState() => _SearchTextFieldWidgetState();
}

class _SearchTextFieldWidgetState extends State<SearchTextFieldWidget> {
  ///
  late TextEditingController controller;

  bool changed = false;

  ///是否显示清除按钮
  bool showClearBtn = false;

  ///自动回调的时间
  int _time = 1000;

  ///定时器
  TimerUtil? _tUtil;

  ///记录输入的文字
  String _mSearchText = '';

  @override
  void initState() {
    super.initState();
    controller = widget.textEditingController ?? TextEditingController();
    controller.text = _mSearchText = widget.keyWord ?? '';
    var length = controller.text.length;
    controller.selection =
        TextSelection(baseOffset: length, extentOffset: length);
    showClearBtn = length > 0;

    controller.addListener(() {
      showClearBtn = controller.text.length > 0;
      setState(() {});
    });
    initTimer();
  }

  ///定时器
  initTimer() {
    if (widget.autoComplete) {
      _tUtil = TimerUtil(mTotalTime: _time);
      _tUtil!.setOnTimerTickCallback((millis) {
        if (millis == 0 && widget.autoComplete && verifyUpdateText()) {
          if (widget.onSearchType != null)
            widget.onSearchType!(SearchType.TEXT);
          if (widget.onSubmitCallback != null)
            widget.onSubmitCallback!(controller.text);
        }
      });
      controller.addListener(() => _tUtil?.updateTotalTime(_time));
    }
  }

  @override
  void dispose() {
    if (widget.textEditingController == null) controller.dispose();
    if (_tUtil != null) _tUtil!.cancel();
    super.dispose();
  }

  ///定义一个变量_mSearchText，用于记录输入的文字
  ///判断当前输入的文字是否与记录的文字是否相同
  bool verifyUpdateText() {
    if (widget.forceComplete) return true;
    if (controller.text == _mSearchText) return false;
    _mSearchText = controller.text;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Widget result = Container(
      height: sizeUtil.h55,
      decoration: BoxDecoration(
        color: widget.bgColor ?? const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 7, 8, 8),
              child: Icon(
                ZzIcons.icon_sousu,
                size: 16,
                color: Color(0xFFC5CAD5),
              ),
            ),
            onTap: () {
              if (widget.onSearchType != null)
                widget.onSearchType!(SearchType.TEXT);
              if (widget.onSubmitCallback != null /*&& verifyUpdateText()*/)
                widget.onSubmitCallback!(controller.text);
            },
          ),

          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Color.fromRGBO(51, 51, 51, 1),
                fontSize: 15,
              ),
              autofocus: widget.autoFocus ?? false, //进入页面后是否直接获取输入框焦点
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(1),
                hintText: widget.hintText ?? '编码/名称',
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xFFC5CAD5),
                  fontSize: 13,
                ),
                border: _border,
                enabledBorder: _border,
                disabledBorder: _border,
                focusedBorder: _border,
              ),
              onSubmitted: (text) {
                //if(verifyUpdateText())
                if (widget.onSearchType != null)
                  widget.onSearchType!(SearchType.TEXT);
                if (widget.onSubmitCallback != null)
                  widget.onSubmitCallback!(text);
              },
              onChanged: (text) {
                if (null != widget.onChangeCallback && !widget.autoComplete)
                  widget.onChangeCallback!(text);
                if (text.length > 0) {
                  setState(() {
                    showClearBtn = true;
                    changed = true;
                  });
                } else {
                  setState(() {
                    showClearBtn = false;
                    changed = false;
                  });
                }
              },
              focusNode: widget.focusNode,
            ),
          ),

          ///清除按钮
          Visibility(
            visible: showClearBtn,
            child: InkWell(
              child: const Padding(
                padding: EdgeInsets.only(left: 16, top: 7, bottom: 8),
                child: Icon(
                  Icons.cancel,
                  size: 20,
                  color: ColorName.textColor858b9c,
                ),
              ),
              onTap: () async {
                if (!widget.autoComplete /*&& verifyUpdateText()*/) {
                  if (null != widget.onClearCallback)
                    widget.onClearCallback!();
                  else if (null != widget.onSubmitCallback) {
                    if (widget.onSearchType != null)
                      widget.onSearchType!(SearchType.TEXT);
                    if (widget.onSubmitCallback != null) {
                      widget.onSubmitCallback!('');
                    }
                  }
                }

                setState(() {
                  changed = !changed;
                  showClearBtn = false;
                  controller.text = '';
                });
              },
            ),
          ),

          //录音
          // Visibility(
          //   visible: widget.showVoiceButton && !showClearBtn,
          //   child: SpeechBaseWidget(
          //       child: Padding(
          //         padding:
          //             const EdgeInsets.only(left: 16.0, top: 7.0, bottom: 8.0),
          //         child: const Icon(
          //           LkIcons.icon_yuyin,
          //           size: 16,
          //           color: ColorUtils.appThemeColor,
          //         ),
          //       ),
          //       tipData: widget.hintText ?? "编码/名称",
          //       onSpeechResultCallback: (speechWords) {
          //         controller?.text = speechWords;
          //         setState(() {
          //           showClearBtn = true;
          //           changed = true;
          //         });
          //         if (widget.onSearchType != null)
          //           widget.onSearchType!(SearchType.VOICE);
          //         if (widget.onSubmitCallback != null ) {
          //           widget.onSubmitCallback!(speechWords);
          //         }
          //       }),
          // ),

          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );

    if (widget.showSearchButton) {
      result = Row(
        children: <Widget>[
          Expanded(
            child: result,
          ),
          GestureDetector(
            onTap: () {
              //if(verifyUpdateText())
              //收起键盘
              FocusManager.instance.primaryFocus?.unfocus();
              if (widget.onSearchType != null)
                widget.onSearchType!(SearchType.TEXT);
              if (widget.onSubmitCallback != null)
                widget.onSubmitCallback!(controller.text);
            },
            child: Container(
              width: 44,
              height: 26,
              alignment: Alignment.centerRight,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: const Text(
                '搜索',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: ColorName.themeColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return result;
  }

  final InputBorder _border = const OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF5F5F5), width: 0.0),
  );
}
