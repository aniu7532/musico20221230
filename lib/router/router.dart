import 'package:musico/pages/home/import/tab_import_page.dart';
import 'package:musico/pages/home/library/playlist_detail/playlist_detail_page.dart';
import 'package:musico/pages/home/library/tab_library_page.dart';
import 'package:musico/pages/home/setting/privacy/privacy_policy_page.dart';
import 'package:musico/pages/home/setting/tab_setting_page.dart';
import 'package:musico/pages/home/tab_page.dart';
import 'package:musico/pages/home/track/tab_track_page.dart';
import 'package:musico/pages/imports/import_from_computer/import_from_computer_page.dart';
import 'package:musico/pages/imports/import_from_phone/import_from_phone_page.dart';
import 'package:musico/pages/playing/playing_page.dart';
import 'package:musico/pages/selector/select_palylist/select_playlist_page.dart';
import 'package:musico/pages/splash_page.dart';
import 'package:musico/utils/app_crash_util.dart';
import 'package:musico/widgets/file_select/image_preview_page.dart';
import 'package:musico/widgets/file_select/video_preview_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppRouteObserver extends AutoRouterObserver {
  Future<void> _sendScreenView(Route? route, Route? previousRoute) async {
    var previousRouteName = '';
    var name = '';
    if (previousRoute != null && previousRoute is PageRoute) {
      previousRouteName = previousRoute.settings.name ?? '';
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _sendScreenView(route, previousRoute);
    if (kDebugMode) debugLog('路由跳转: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _sendScreenView(previousRoute, route);
    if (kDebugMode) debugLog('路由返回: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _sendScreenView(newRoute, oldRoute);
    if (kDebugMode) debugLog('路由替换: ${newRoute?.settings.name}');
  }
}

@CustomAutoRouter(
  replaceInRouteName: 'Page,Route',
  durationInMilliseconds: 200,
  transitionsBuilder: TransitionsBuilders.slideLeft,
  routes: <AutoRoute>[
    //启动页
    AutoRoute(initial: true, page: SplashPage),

    //首页
    AutoRoute(
      page: TabPage,
      children: [
        AutoRoute(path: 'track', page: TabTrackPage),
        AutoRoute(path: 'library', page: TabLibraryPage),
        AutoRoute(path: 'import', page: TabImportPage),
        AutoRoute(path: 'setting', page: TabSettingPage),
      ],
    ),

    //音乐播放页面
    AutoRoute(path: 'playing_page', page: PlayingPage),
/*    //图片预览
    AutoRoute(path: 'image_preview_page', page: ImagePreViewPage),
    //视频预览
    AutoRoute(path: 'image_preview_page', page: VideoPreviewPage),*/

    //import from computer
    AutoRoute(path: 'import_from_computer', page: ImportFromComputerPage),
    //import from phone
    AutoRoute(path: 'import_from_phone', page: ImportFromPhonePage),

    //歌单详情列表
    AutoRoute(path: 'playlist_detail_page', page: PlaylistDetailPage),
    //歌单详情列表
    AutoRoute(path: 'privacy_policy_page', page: PrivacyPolicyPage),

    // --------- 选择器 --------
    AutoRoute(path: 'select_playlist_page', page: SelectPlaylistPage),
  ],
)
class $AppRouter {}
