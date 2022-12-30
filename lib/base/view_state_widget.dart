import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:musico/base/view_state_list_model.dart';
import 'package:musico/base/view_state_model.dart';
import 'package:musico/gen/assets.gen.dart';

///统一一个控制 加载状态显示
class LoadStatusWidget extends StatelessWidget {
  LoadStatusWidget({
    Key? key,
    this.image,
    this.message,
    this.buttonText,
    this.showBtn,
    required this.model,
  }) : super(key: key);

  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final bool? showBtn;
  final ViewStateModel model;

  static bool isEmpty(ViewStateModel model) {
    if (model is ViewStateListModel) {
      var m = model;
      return ObjectUtil.isEmpty(m.list);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    ///加载中
    if (model.busy) {
      return Center(child: CircularProgressIndicator());
    }

    if (model.unAuthorized) {
      return ViewStateUnAuthWidget(
          model: model, message: message, image: image, buttonText: buttonText);
    }

    ///空数据
    if (model.empty) {
      return ViewStateEmptyWidget(
          model: model,
          message: message,
          image: image,
          buttonText: buttonText,
          showBtn: showBtn);
    }

    ///加载错误
    return ViewStateWidget(
        model: model,
        message: message,
        image: image,
        buttonText: buttonText,
        showBtn: showBtn);
  }
}

/// 加载中
class ViewStateBusyWidget extends StatelessWidget {
  const ViewStateBusyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// 基础Widget
/// 加载错误显示
class ViewStateWidget extends StatelessWidget {
  ViewStateWidget({
    Key? key,
    this.image,
    this.message,
    this.buttonText,
    this.showBtn,
    required this.model,
  }) : super(key: key);

  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final bool? showBtn;
  final ViewStateModel model;

  @override
  Widget build(BuildContext context) {
    var msg = '';
    var reason = model.errorMessage;
    if (model.errorMessage.isEmpty) msg = 'empty';
    if (ObjectUtil.isNotEmpty(reason) && ObjectUtil.isEmpty(message)) {
      if (reason.contains('没有网络')) {
        msg = '无网络';
      } else if (reason.contains('网络异常')) {
        msg = '网络异常';
      } else if (reason.contains('请求异常')) {
        msg = '请求异常';
      }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          image ??
              Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                child: Assets.images.noData.defaultNoTrack.image(),
              ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, (showBtn ?? true) ? 30 : 15),
            child: Text(
              msg,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Color(0xFF858B9C),
                fontSize: 16,
              ),
            ),
          ),
          // Visibility(
          //   visible: showBtn ?? true,
          //   child: ViewStateButton(
          //     onPressed: model.initData,
          //     child: buttonText,
          //   ),
          // )
        ],
      ),
    );
  }
}

/// 页面无数据
class ViewStateEmptyWidget extends StatelessWidget {
  const ViewStateEmptyWidget({
    Key? key,
    this.image,
    this.message,
    this.buttonText,
    this.showBtn,
    required this.model,
  }) : super(key: key);
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final ViewStateModel model;
  final bool? showBtn;

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      model: model,
      showBtn: showBtn,
      image: image ??
          Container(
            width: 168,
            height: 152,
            alignment: Alignment.center,
            child: Assets.images.noData.defaultNoTrack.image(),
          ),
      message: message ?? 'refresh',
      buttonText: buttonText ??
          const Text(
            'refresh',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Color(0xFF666666),
              fontSize: 14,
            ),
          ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key, this.color}) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 30),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 168,
            height: 152,
            alignment: Alignment.center,
            child: Assets.images.noData.defaultNoTrack.image(),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'empty',
            style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
          )
        ],
      ),
    );
  }
}

/// 页面未授权
class ViewStateUnAuthWidget extends StatelessWidget {
  const ViewStateUnAuthWidget({
    Key? key,
    this.image,
    this.message,
    this.buttonText,
    required this.model,
  }) : super(key: key);
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final ViewStateModel model;

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      model: model,
      image: image ?? ViewStateUnAuthImage(),
      message: message ?? '认证失败',
      buttonText: buttonText ??
          const Text(
            '登录',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Color(0xFF666666),
              fontSize: 14,
            ),
          ),
    );
  }
}

/// 未授权图片
class ViewStateUnAuthImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'loginLogo',
      child: Image.asset(
        Assets.images.noData.defaultNoTrack.path,
        width: 90,
        height: 91.5,
        fit: BoxFit.fitWidth,
        color: Theme.of(context).accentColor,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}

/// 公用Button
class ViewStateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? child;

  const ViewStateButton({required this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      /*    padding: const EdgeInsets.symmetric(horizontal: 25),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))),
      textColor: Colors.grey,
      splashColor: Theme.of(context).splashColor,
      highlightedBorderColor: Theme.of(context).splashColor,*/
      onPressed: onPressed,
      child: child ??
          const Text(
            '重试',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Color(0xFF666666),
              fontSize: 14,
            ),
          ),
    );
  }
}
