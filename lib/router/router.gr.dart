// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i18;
import 'package:flutter/foundation.dart' as _i20;
import 'package:flutter/material.dart' as _i19;

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
import '../pages/with_data/index/index_page.dart' as _i13;
import '../pages/with_data/search/search_page.dart' as _i14;
import '../pages/with_data/search/search_rst_page.dart' as _i15;
import '../pages/with_data/selector/select_playlist/d_select_playlist_page.dart'
    as _i17;
import '../pages/with_data/selector/select_singer/select_singer_page.dart'
    as _i16;

class AppRouter extends _i18.RootStackRouter {
  AppRouter([_i19.GlobalKey<_i19.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i18.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.SplashPage(),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    TabRoute.name: (routeData) {
      final args =
          routeData.argsAs<TabRouteArgs>(orElse: () => const TabRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i2.TabPage(key: args.key),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    PlayingRoute.name: (routeData) {
      final args = routeData.argsAs<PlayingRouteArgs>(
          orElse: () => const PlayingRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i3.PlayingPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ImportFromComputerRoute.name: (routeData) {
      final args = routeData.argsAs<ImportFromComputerRouteArgs>(
          orElse: () => const ImportFromComputerRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i4.ImportFromComputerPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ImportFromPhoneRoute.name: (routeData) {
      final args = routeData.argsAs<ImportFromPhoneRouteArgs>(
          orElse: () => const ImportFromPhoneRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i5.ImportFromPhonePage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    PlaylistDetailRoute.name: (routeData) {
      final args = routeData.argsAs<PlaylistDetailRouteArgs>(
          orElse: () => const PlaylistDetailRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i6.PlaylistDetailPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    PrivacyPolicyRoute.name: (routeData) {
      final args = routeData.argsAs<PrivacyPolicyRouteArgs>(
          orElse: () => const PrivacyPolicyRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i7.PrivacyPolicyPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SelectPlaylistRoute.name: (routeData) {
      final args = routeData.argsAs<SelectPlaylistRouteArgs>(
          orElse: () => const SelectPlaylistRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i8.SelectPlaylistPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    TabTrackRoute.name: (routeData) {
      final args = routeData.argsAs<TabTrackRouteArgs>(
          orElse: () => const TabTrackRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i9.TabTrackPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    TabLibraryRoute.name: (routeData) {
      final args = routeData.argsAs<TabLibraryRouteArgs>(
          orElse: () => const TabLibraryRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i10.TabLibraryPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    TabImportRoute.name: (routeData) {
      final args = routeData.argsAs<TabImportRouteArgs>(
          orElse: () => const TabImportRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i11.TabImportPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    TabSettingRoute.name: (routeData) {
      final args = routeData.argsAs<TabSettingRouteArgs>(
          orElse: () => const TabSettingRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i12.TabSettingPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    TabIndexRoute.name: (routeData) {
      final args = routeData.argsAs<TabIndexRouteArgs>(
          orElse: () => const TabIndexRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i13.TabIndexPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    TabSearchRoute.name: (routeData) {
      final args = routeData.argsAs<TabSearchRouteArgs>(
          orElse: () => const TabSearchRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i14.TabSearchPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    TabSearchRstRoute.name: (routeData) {
      final args = routeData.argsAs<TabSearchRstRouteArgs>(
          orElse: () => const TabSearchRstRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i15.TabSearchRstPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SelectSingerRoute.name: (routeData) {
      final args = routeData.argsAs<SelectSingerRouteArgs>(
          orElse: () => const SelectSingerRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i16.SelectSingerPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    DSelectPlaylistRoute.name: (routeData) {
      final args = routeData.argsAs<DSelectPlaylistRouteArgs>(
          orElse: () => const DSelectPlaylistRouteArgs());
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: _i17.DSelectPlaylistPage(
          key: args.key,
          requestParams: args.requestParams,
        ),
        transitionsBuilder: _i18.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i18.RouteConfig> get routes => [
        _i18.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i18.RouteConfig(
          TabRoute.name,
          path: '/tab-page',
          children: [
            _i18.RouteConfig(
              TabIndexRoute.name,
              path: 'index',
              parent: TabRoute.name,
            ),
            _i18.RouteConfig(
              TabSearchRoute.name,
              path: 'search_page',
              parent: TabRoute.name,
            ),
            _i18.RouteConfig(
              TabSearchRstRoute.name,
              path: 'search_rst_page',
              parent: TabRoute.name,
            ),
          ],
        ),
        _i18.RouteConfig(
          PlayingRoute.name,
          path: 'playing_page',
        ),
        _i18.RouteConfig(
          ImportFromComputerRoute.name,
          path: 'import_from_computer',
        ),
        _i18.RouteConfig(
          ImportFromPhoneRoute.name,
          path: 'import_from_phone',
        ),
        _i18.RouteConfig(
          PlaylistDetailRoute.name,
          path: 'playlist_detail_page',
        ),
        _i18.RouteConfig(
          PrivacyPolicyRoute.name,
          path: 'privacy_policy_page',
        ),
        _i18.RouteConfig(
          SelectPlaylistRoute.name,
          path: 'select_playlist_page',
        ),
        _i18.RouteConfig(
          TabTrackRoute.name,
          path: 'track',
        ),
        _i18.RouteConfig(
          TabLibraryRoute.name,
          path: 'library',
        ),
        _i18.RouteConfig(
          TabImportRoute.name,
          path: 'import',
        ),
        _i18.RouteConfig(
          TabSettingRoute.name,
          path: 'setting',
        ),
        _i18.RouteConfig(
          TabIndexRoute.name,
          path: 'index',
        ),
        _i18.RouteConfig(
          TabSearchRoute.name,
          path: 'search_page',
        ),
        _i18.RouteConfig(
          TabSearchRstRoute.name,
          path: 'search_rst_page',
        ),
        _i18.RouteConfig(
          SelectSingerRoute.name,
          path: 'select_singer_page',
        ),
        _i18.RouteConfig(
          DSelectPlaylistRoute.name,
          path: 'd_select_playlist_page',
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i18.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.TabPage]
class TabRoute extends _i18.PageRouteInfo<TabRouteArgs> {
  TabRoute({
    _i20.Key? key,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          TabRoute.name,
          path: '/tab-page',
          args: TabRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'TabRoute';
}

class TabRouteArgs {
  const TabRouteArgs({this.key});

  final _i20.Key? key;

  @override
  String toString() {
    return 'TabRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.PlayingPage]
class PlayingRoute extends _i18.PageRouteInfo<PlayingRouteArgs> {
  PlayingRoute({
    _i20.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          PlayingRoute.name,
          path: 'playing_page',
          args: PlayingRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'PlayingRoute';
}

class PlayingRouteArgs {
  const PlayingRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i20.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'PlayingRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i4.ImportFromComputerPage]
class ImportFromComputerRoute
    extends _i18.PageRouteInfo<ImportFromComputerRouteArgs> {
  ImportFromComputerRoute({
    _i20.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          ImportFromComputerRoute.name,
          path: 'import_from_computer',
          args: ImportFromComputerRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'ImportFromComputerRoute';
}

class ImportFromComputerRouteArgs {
  const ImportFromComputerRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i20.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'ImportFromComputerRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i5.ImportFromPhonePage]
class ImportFromPhoneRoute
    extends _i18.PageRouteInfo<ImportFromPhoneRouteArgs> {
  ImportFromPhoneRoute({
    _i20.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          ImportFromPhoneRoute.name,
          path: 'import_from_phone',
          args: ImportFromPhoneRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'ImportFromPhoneRoute';
}

class ImportFromPhoneRouteArgs {
  const ImportFromPhoneRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i20.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'ImportFromPhoneRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i6.PlaylistDetailPage]
class PlaylistDetailRoute extends _i18.PageRouteInfo<PlaylistDetailRouteArgs> {
  PlaylistDetailRoute({
    _i20.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          PlaylistDetailRoute.name,
          path: 'playlist_detail_page',
          args: PlaylistDetailRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'PlaylistDetailRoute';
}

class PlaylistDetailRouteArgs {
  const PlaylistDetailRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i20.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'PlaylistDetailRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i7.PrivacyPolicyPage]
class PrivacyPolicyRoute extends _i18.PageRouteInfo<PrivacyPolicyRouteArgs> {
  PrivacyPolicyRoute({
    _i20.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          PrivacyPolicyRoute.name,
          path: 'privacy_policy_page',
          args: PrivacyPolicyRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'PrivacyPolicyRoute';
}

class PrivacyPolicyRouteArgs {
  const PrivacyPolicyRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i20.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'PrivacyPolicyRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i8.SelectPlaylistPage]
class SelectPlaylistRoute extends _i18.PageRouteInfo<SelectPlaylistRouteArgs> {
  SelectPlaylistRoute({
    _i20.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          SelectPlaylistRoute.name,
          path: 'select_playlist_page',
          args: SelectPlaylistRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'SelectPlaylistRoute';
}

class SelectPlaylistRouteArgs {
  const SelectPlaylistRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i20.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'SelectPlaylistRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i9.TabTrackPage]
class TabTrackRoute extends _i18.PageRouteInfo<TabTrackRouteArgs> {
  TabTrackRoute({
    _i20.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          TabTrackRoute.name,
          path: 'track',
          args: TabTrackRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'TabTrackRoute';
}

class TabTrackRouteArgs {
  const TabTrackRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i20.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'TabTrackRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i10.TabLibraryPage]
class TabLibraryRoute extends _i18.PageRouteInfo<TabLibraryRouteArgs> {
  TabLibraryRoute({
    _i20.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          TabLibraryRoute.name,
          path: 'library',
          args: TabLibraryRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'TabLibraryRoute';
}

class TabLibraryRouteArgs {
  const TabLibraryRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i20.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'TabLibraryRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i11.TabImportPage]
class TabImportRoute extends _i18.PageRouteInfo<TabImportRouteArgs> {
  TabImportRoute({
    _i20.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          TabImportRoute.name,
          path: 'import',
          args: TabImportRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'TabImportRoute';
}

class TabImportRouteArgs {
  const TabImportRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i20.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'TabImportRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i12.TabSettingPage]
class TabSettingRoute extends _i18.PageRouteInfo<TabSettingRouteArgs> {
  TabSettingRoute({
    _i20.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          TabSettingRoute.name,
          path: 'setting',
          args: TabSettingRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'TabSettingRoute';
}

class TabSettingRouteArgs {
  const TabSettingRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i20.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'TabSettingRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i13.TabIndexPage]
class TabIndexRoute extends _i18.PageRouteInfo<TabIndexRouteArgs> {
  TabIndexRoute({
    _i20.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          TabIndexRoute.name,
          path: 'index',
          args: TabIndexRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'TabIndexRoute';
}

class TabIndexRouteArgs {
  const TabIndexRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i20.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'TabIndexRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i14.TabSearchPage]
class TabSearchRoute extends _i18.PageRouteInfo<TabSearchRouteArgs> {
  TabSearchRoute({
    _i20.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          TabSearchRoute.name,
          path: 'search_page',
          args: TabSearchRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'TabSearchRoute';
}

class TabSearchRouteArgs {
  const TabSearchRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i20.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'TabSearchRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i15.TabSearchRstPage]
class TabSearchRstRoute extends _i18.PageRouteInfo<TabSearchRstRouteArgs> {
  TabSearchRstRoute({
    _i20.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          TabSearchRstRoute.name,
          path: 'search_rst_page',
          args: TabSearchRstRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'TabSearchRstRoute';
}

class TabSearchRstRouteArgs {
  const TabSearchRstRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i20.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'TabSearchRstRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i16.SelectSingerPage]
class SelectSingerRoute extends _i18.PageRouteInfo<SelectSingerRouteArgs> {
  SelectSingerRoute({
    _i20.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          SelectSingerRoute.name,
          path: 'select_singer_page',
          args: SelectSingerRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'SelectSingerRoute';
}

class SelectSingerRouteArgs {
  const SelectSingerRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i20.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'SelectSingerRouteArgs{key: $key, requestParams: $requestParams}';
  }
}

/// generated route for
/// [_i17.DSelectPlaylistPage]
class DSelectPlaylistRoute
    extends _i18.PageRouteInfo<DSelectPlaylistRouteArgs> {
  DSelectPlaylistRoute({
    _i20.Key? key,
    Map<String, dynamic>? requestParams,
  }) : super(
          DSelectPlaylistRoute.name,
          path: 'd_select_playlist_page',
          args: DSelectPlaylistRouteArgs(
            key: key,
            requestParams: requestParams,
          ),
        );

  static const String name = 'DSelectPlaylistRoute';
}

class DSelectPlaylistRouteArgs {
  const DSelectPlaylistRouteArgs({
    this.key,
    this.requestParams,
  });

  final _i20.Key? key;

  final Map<String, dynamic>? requestParams;

  @override
  String toString() {
    return 'DSelectPlaylistRouteArgs{key: $key, requestParams: $requestParams}';
  }
}
