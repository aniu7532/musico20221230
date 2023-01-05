import 'dart:async';
import 'package:musico/app/myapp.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/base/view_state.dart';
import 'package:musico/router/router.gr.dart';

mixin _Protocol {}

class IndexModel extends BaseListMoreModel<dynamic> with _Protocol {
  IndexModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    showSearchWidget = false;
    searchWidgetOnAppbar = true;
    needBack = false;
    searchHintText = '';
    enablePullUp = false;
    viewState = ViewState.empty;
  }

  @override
  Future<bool> initData() async {
    setBusy(true);

    return super.initData();
  }

  @override
  Future<List<dynamic>> loadRefreshListData({int? pageNum}) async {
    return [
      'asdasdsad',
      'wahhasdgkasdasd',
      '1xxx',
      '2asdsad'
          'whaosdhoahds'
    ];
  }

  ///
  /// 查看所有playlist
  ///
  Future<void> goToAllPlaylist() async {
    await appRouter.push(
        DSelectPlaylistRoute(requestParams: {'title': 'Popular playlists'}));
  }

  ///
  /// 查看所有artlist
  ///
  Future<void> goToAllArtist() async {
    await appRouter
        .push(SelectSingerRoute(requestParams: {'title': 'Hottest Artist'}));
  }
}
