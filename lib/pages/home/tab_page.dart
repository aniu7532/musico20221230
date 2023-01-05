import 'dart:async';

import 'package:musico/eventbus/tab_select_event.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/utils/helper/audio_player_helper.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:musico/widgets/common/tab_widget.dart';

///
///  首页大框架页面
///
class TabPage extends StatelessWidget {
  TabPage({
    Key? key,
  }) : super(key: key);

  DateTime? _lastPressed;

  TabsRouter? appTabsRouter;

  StreamSubscription? subscription;

  @override
  Widget build(BuildContext context) {
    subscription = AppData.eventBus.on<TabSelectEvent>().listen((event) {
      appTabsRouter?.setActiveIndex(event.index ?? 0);
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    // 设置尺寸（填写设计中设备的屏幕尺寸）如果设计基于360dp * 690dp的屏幕
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
      minTextAdapt: true, //不允许随系统改变字体大小
    );
    return WillPopScope(
      onWillPop: willPop,
      child: AutoTabsScaffold(
        animationDuration: const Duration(milliseconds: 30),
        routes: AppData.isWithData
            ? [
                TabIndexRoute(),
                TabSearchRoute(),
              ]
            : [
                TabTrackRoute(),
                TabLibraryRoute(),
                TabImportRoute(),
                TabSettingRoute(),
              ],
        bottomNavigationBuilder: (_, tabsRouter) {
          appTabsRouter = tabsRouter;
          return BottomTabBar(
            selectedIndex: tabsRouter.activeIndex,
            onItemSelected: (index) {
              tabsRouter.setActiveIndex(index);
            },
            items: <BottomTabBarItem>[
              BottomTabBarItem(
                title: const Text('home', style: TextStyle(fontSize: 12)),
                icon: Assets.images.bottomTabbar.bottombarHomeChecked
                    .image(fit: BoxFit.fill, height: 28),
                inactiveIcon: Assets.images.bottomTabbar.bottombarHomeUncheck
                    .image(fit: BoxFit.fill, height: 28),
              ),
              BottomTabBarItem(
                title: const Text('list', style: TextStyle(fontSize: 12)),
                icon: Assets.images.bottomTabbar.bottombarListChecked
                    .image(fit: BoxFit.fill, height: 28),
                inactiveIcon: Assets.images.bottomTabbar.bottombarListUncheck
                    .image(fit: BoxFit.fill, height: 28),
              ),
              BottomTabBarItem(
                title: const Text('import', style: TextStyle(fontSize: 12)),
                icon: Assets.images.bottomTabbar.bottombarImportChecked
                    .image(fit: BoxFit.fill, height: 28),
                inactiveIcon: Assets.images.bottomTabbar.bottombarImportUncheck
                    .image(fit: BoxFit.fill, height: 28),
              ),
              BottomTabBarItem(
                title: const Text('setting', style: TextStyle(fontSize: 12)),
                icon: Assets.images.bottomTabbar.bottombarSettingChecked
                    .image(fit: BoxFit.fill, height: 28),
                inactiveIcon: Assets.images.bottomTabbar.bottombarSettingUncheck
                    .image(fit: BoxFit.fill, height: 28),
              ),
            ],
          );
        },
      ),
    );
  }

  ///返回事件处理
  Future<bool> willPop() async {
    if (_lastPressed == null) {
      _lastPressed = DateTime.now();
      MyToast.showInfo('Press again to exit');
      return false;
    }

    if (DateTime.now().difference(_lastPressed!) > const Duration(seconds: 2)) {
      //两次点击间隔超过2秒则重新计时
      _lastPressed = DateTime.now();
      MyToast.showInfo('Press again to exit');
      return false;
    }

    //   ZzPlugin.startToDesktop();

    await audioPlayerHelper.dispose();

    return true;
  }

  bool get wantKeepAlive => true;
}
