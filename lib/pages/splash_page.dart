import 'dart:io';

import 'package:musico/app/myapp.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///启动页
class SplashPage extends StatefulWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    //隐藏头部底部导航栏 以达到全屏效果
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    //更新以及跳转
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      checkUpgrade();
    });
    //进度条控制器
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: splashTime));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Assets.images.splashBg.image(
            fit: BoxFit.fill,
          ),
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
                child: Assets.images.splashBottom
                    .image(fit: BoxFit.fill, height: 36)),
          ),
          Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: Center(
                  child: AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget? child) {
                  return SizedBox(
                    height: 3,
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(1.5)),
                      child: LinearProgressIndicator(
                        value: controller.value,
                        backgroundColor: ColorName.progressBgColor,
                        valueColor:
                            AlwaysStoppedAnimation(ColorName.secondaryColor),
                      ),
                    ),
                  );
                },
              ))),
        ],
      ),
    );
  }

  //启动时间
  static const splashTime = 1;

  ///检测版本更新
  checkUpgrade() async {
    Future.delayed(Duration(seconds: splashTime), () {
      //直接跳转到首页
      appRouter.replace(TabRoute());
    });
  }
}
