// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i13;
import 'package:flutter/material.dart' as _i14;

import '../pages/home/import/tab_import_page.dart' as _i11;
import '../pages/home/library/playlist_detail/playlist_detail_page.dart' as _i6;
import '../pages/home/library/tab_library_page.dart' as _i10;
import '../pages/home/setting/privacy/privacy_policy_page.dart' as _i7;
import '../pages/home/setting/tab_setting_page.dart' as _i12;
import '../pages/home/tab_page.dart' as _i2;
import '../pages/home/track/tab_track_page.dart' as _i9;
import '../pages/imports/import_from_computer/import_from_computer_page.dart'
    as _i4;
import '../pages/imports/import_from_phone/import_from_phone_page.dart' as _i5;
import '../pages/playing/playing_page.dart' as _i3;
import '../pages/selector/select_palylist/select_playlist_page.dart' as _i8;
import '../pages/splash_page.dart' as _i1;

class AppRouter extends _i13.RootStackRouter {
  AppRouter([_i14.GlobalKey<_i14.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i13.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i1.SplashPage(),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          durationInMilliseconds: 200,
          opaque: true,
          barrierDismissible: false);
    },
    TabRoute.name: (routeData) {
      final args =
          routeData.argsAs<TabRouteArgs>(orElse: () => const TabRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i2.TabPage(key: args.key),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          durationInMilliseconds: 200,
          opaque: true,
          barrierDismissible: false);
    },
    PlayingRoute.name: (routeData) {
      final args = routeData.argsAs<PlayingRouteArgs>(
          orElse: () => const PlayingRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child:
              _i3.PlayingPage(key: args.key, requestParams: args.requestParams),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          durationInMilliseconds: 200,
          opaque: true,
          barrierDismissible: false);
    },
    ImportFromComputerRoute.name: (routeData) {
      final args = routeData.argsAs<ImportFromComputerRouteArgs>(
          orElse: () => const ImportFromComputerRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i4.ImportFromComputerPage(
              key: args.key, requestParams: args.requestParams),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          durationInMilliseconds: 200,
          opaque: true,
          barrierDismissible: false);
    },
    ImportFromPhoneRoute.name: (routeData) {
      final args = routeData.argsAs<ImportFromPhoneRouteArgs>(
          orElse: () => const ImportFromPhoneRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i5.ImportFromPhonePage(
              key: args.key, requestParams: args.requestParams),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          durationInMilliseconds: 200,
          opaque: true,
          barrierDismissible: false);
    },
    PlaylistDetailRoute.name: (routeData) {
      final args = routeData.argsAs<PlaylistDetailRouteArgs>(
          orElse: () => const PlaylistDetailRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i6.PlaylistDetailPage(
              key: args.key, requestParams: args.requestParams),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          durationInMilliseconds: 200,
          opaque: true,
          barrierDismissible: false);
    },
    PrivacyPolicyRoute.name: (routeData) {
      final args = routeData.argsAs<PrivacyPolicyRouteArgs>(
          orElse: () => const PrivacyPolicyRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i7.PrivacyPolicyPage(
              key: args.key, requestParams: args.requestParams),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          durationInMilliseconds: 200,
          opaque: true,
          barrierDismissible: false);
    },
    SelectPlaylistRoute.name: (routeData) {
      final args = routeData.argsAs<SelectPlaylistRouteArgs>(
          orElse: () => const SelectPlaylistRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i8.SelectPlaylistPage(
              key: args.key, requestParams: args.requestParams),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          durationInMilliseconds: 200,
          opaque: true,
          barrierDismissible: false);
    },
    TabTrackRoute.name: (routeData) {
      final args = routeData.argsAs<TabTrackRouteArgs>(
          orElse: () => const TabTrackRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i9.TabTrackPage(
              key: args.key, requestParams: args.requestParams),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          durationInMilliseconds: 200,
          opaque: true,
          barrierDismissible: false);
    },
    TabLibraryRoute.name: (routeData) {
      final args = routeData.argsAs<TabLibraryRouteArgs>(
          orElse: () => const TabLibraryRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i10.TabLibraryPage(
              key: args.key, requestParams: args.requestParams),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          durationInMilliseconds: 200,
          opaque: true,
          barrierDismissible: false);
    },
    TabImportRoute.name: (routeData) {
      final args = routeData.argsAs<TabImportRouteArgs>(
          orElse: () => const TabImportRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i11.TabImportPage(
              key: args.key, requestParams: args.requestParams),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          durationInMilliseconds: 200,
          opaque: true,
          barrierDismissible: false);
    },
    TabSettingRoute.name: (routeData) {
      final args = routeData.argsAs<TabSettingRouteArgs>(
          orElse: () => const TabSettingRouteArgs());
      return _i13.CustomPage<dynamic>(
          routeData: routeData,
          child: _i12.TabSettingPage(
              key: args.key, requestParams: args.requestParams),
          transitionsBuilder: _i13.TransitionsBuilders.slideLeft,
          durationInMilliseconds: 200,
          opaque: true,
          barrierDismissible: false);
    }
  };

  @override
  List<_i13.RouteConfig> get routes => [
        _i13.RouteConfig(SplashRoute.name, path: '/'),
        _i13.RouteConfig(TabRoute.name, path: '/tab-page', children: [
          _i13.RouteConfig(TabTrackRoute.name,
              path: 'track', parent: TabRoute.name),
          _i13.RouteConfig(TabLibraryRoute.name,
              path: 'library', parent: TabRoute.name),
          _i13.RouteConfig(TabImportRoute.name,
              path: 'import', parent: TabRoute.name),
          _i13.RouteConfig(TabSettingRoute.name,
              path: 'setting', parent: TabRoute.name)
        ]),
        _i13.RouteConfig(PlayingRoute.name, path: 'playing_page'),
        _i13.RouteConfig(ImportFromComputerRoute.name,
            path: 'import_from_computer'),
        _i13.RouteConfig(ImportFromPhoneRoute.name, path: 'import_from_phone'),
        _i13.RouteConfig(PlaylistDetailRoute.name,
            path: 'playlist_detail_page'),
        _i13.RouteConfig(PrivacyPolicyRoute.name, path: 'privacy_policy_page'),
        _i13.RouteConfig(SelectPlaylistRoute.name, path: 'select_playlist_page')
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i13.PageRouteInfo<void> {
  const SplashRoute() : super(SplashRoute.name, path: '/');

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.TabPage]
class TabRoute extends _i13.PageRouteInfo<TabRouteArgs> {
  TabRoute({_i14.Key? key, List<_i13.PageRouteInfo>? children})
      : super(TabRoute.name,
            path: '/tab-page',
            args: TabRouteArgs(key: key),
            initialChildren: children);

  static const String name = 'TabRoute';
}

class TabRouteArgs {
  const TabRouteArgs({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return 'TabRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.PlayingPage]
class PlayingRoute extends _i13.PageRouteInfo<PlayingRouteArgs> {
  PlayingRoute({_i14.Key? key, Map<String, dynamic>? requestParams})
      : super(PlayingRoute.name,
            path: 'playing_page',
            args: PlayingRouteArgs(key: key, requestParams: requestParams));

  static const String name = 'PlayingRoute';
}

class PlayingRouteArgs {
  const PlayingRouteArgs({this.key, this.requestParams});

  final _i14.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'PlayingRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i4.ImportFromComputerPage]
class ImportFromComputerRoute
    extends _i13.PageRouteInfo<ImportFromComputerRouteArgs> {
  ImportFromComputerRoute({_i14.Key? key, Map<String, dynamic>? requestParams})
      : super(ImportFromComputerRoute.name,
            path: 'import_from_computer',
            args: ImportFromComputerRouteArgs(
                key: key, requestParams: requestParams));

  static const String name = 'ImportFromComputerRoute';
}

class ImportFromComputerRouteArgs {
  const ImportFromComputerRouteArgs({this.key, this.requestParams});

  final _i14.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'ImportFromComputerRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i5.ImportFromPhonePage]
class ImportFromPhoneRoute
    extends _i13.PageRouteInfo<ImportFromPhoneRouteArgs> {
  ImportFromPhoneRoute({_i14.Key? key, Map<String, dynamic>? requestParams})
      : super(ImportFromPhoneRoute.name,
            path: 'import_from_phone',
            args: ImportFromPhoneRouteArgs(
                key: key, requestParams: requestParams));

  static const String name = 'ImportFromPhoneRoute';
}

class ImportFromPhoneRouteArgs {
  const ImportFromPhoneRouteArgs({this.key, this.requestParams});

  final _i14.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'ImportFromPhoneRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i6.PlaylistDetailPage]
class PlaylistDetailRoute extends _i13.PageRouteInfo<PlaylistDetailRouteArgs> {
  PlaylistDetailRoute({_i14.Key? key, Map<String, dynamic>? requestParams})
      : super(PlaylistDetailRoute.name,
            path: 'playlist_detail_page',
            args: PlaylistDetailRouteArgs(
                key: key, requestParams: requestParams));

  static const String name = 'PlaylistDetailRoute';
}

class PlaylistDetailRouteArgs {
  const PlaylistDetailRouteArgs({this.key, this.requestParams});

  final _i14.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'PlaylistDetailRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i7.PrivacyPolicyPage]
class PrivacyPolicyRoute extends _i13.PageRouteInfo<PrivacyPolicyRouteArgs> {
  PrivacyPolicyRoute({_i14.Key? key, Map<String, dynamic>? requestParams})
      : super(PrivacyPolicyRoute.name,
            path: 'privacy_policy_page',
            args:
                PrivacyPolicyRouteArgs(key: key, requestParams: requestParams));

  static const String name = 'PrivacyPolicyRoute';
}

class PrivacyPolicyRouteArgs {
  const PrivacyPolicyRouteArgs({this.key, this.requestParams});

  final _i14.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'PrivacyPolicyRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i8.SelectPlaylistPage]
class SelectPlaylistRoute extends _i13.PageRouteInfo<SelectPlaylistRouteArgs> {
  SelectPlaylistRoute({_i14.Key? key, Map<String, dynamic>? requestParams})
      : super(SelectPlaylistRoute.name,
            path: 'select_playlist_page',
            args: SelectPlaylistRouteArgs(
                key: key, requestParams: requestParams));

  static const String name = 'SelectPlaylistRoute';
}

class SelectPlaylistRouteArgs {
  const SelectPlaylistRouteArgs({this.key, this.requestParams});

  final _i14.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'SelectPlaylistRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i9.TabTrackPage]
class TabTrackRoute extends _i13.PageRouteInfo<TabTrackRouteArgs> {
  TabTrackRoute({_i14.Key? key, Map<String, dynamic>? requestParams})
      : super(TabTrackRoute.name,
            path: 'track',
            args: TabTrackRouteArgs(key: key, requestParams: requestParams));

  static const String name = 'TabTrackRoute';
}

class TabTrackRouteArgs {
  const TabTrackRouteArgs({this.key, this.requestParams});

  final _i14.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'TabTrackRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i10.TabLibraryPage]
class TabLibraryRoute extends _i13.PageRouteInfo<TabLibraryRouteArgs> {
  TabLibraryRoute({_i14.Key? key, Map<String, dynamic>? requestParams})
      : super(TabLibraryRoute.name,
            path: 'library',
            args: TabLibraryRouteArgs(key: key, requestParams: requestParams));

  static const String name = 'TabLibraryRoute';
}

class TabLibraryRouteArgs {
  const TabLibraryRouteArgs({this.key, this.requestParams});

  final _i14.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'TabLibraryRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i11.TabImportPage]
class TabImportRoute extends _i13.PageRouteInfo<TabImportRouteArgs> {
  TabImportRoute({_i14.Key? key, Map<String, dynamic>? requestParams})
      : super(TabImportRoute.name,
            path: 'import',
            args: TabImportRouteArgs(key: key, requestParams: requestParams));

  static const String name = 'TabImportRoute';
}

class TabImportRouteArgs {
  const TabImportRouteArgs({this.key, this.requestParams});

  final _i14.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'TabImportRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i12.TabSettingPage]
class TabSettingRoute extends _i13.PageRouteInfo<TabSettingRouteArgs> {
  TabSettingRoute({_i14.Key? key, Map<String, dynamic>? requestParams})
      : super(TabSettingRoute.name,
            path: 'setting',
            args: TabSettingRouteArgs(key: key, requestParams: requestParams));

  static const String name = 'TabSettingRoute';
}

class TabSettingRouteArgs {
  const TabSettingRouteArgs({this.key, this.requestParams});

  final _i14.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'TabSettingRouteArgs{key: $key, requestParams: $requestParams}';
  }
}
