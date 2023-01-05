import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/base/view_state.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/eventbus/refresh_library_event.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/helper/audio_player_helper.dart';
import 'package:musico/utils/helper/audio_query_helper.dart';
import 'package:musico/widgets/dialog/bottom_options_dialog.dart';
import 'package:on_audio_query/on_audio_query.dart';

mixin _Protocol {}

class PlaylistDetailModel extends BaseListMoreModel<SongModel> with _Protocol {
  PlaylistDetailModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    showSearchWidget = false;
    viewState = ViewState.empty;
    print(requestParam);
    if (ObjectUtil.isNotEmpty(requestParam)) {
      if (requestParam!.containsKey('playlistId')) {
        playlistId = requestParam['playlistId'];
      }
    }
  }
  StreamSubscription? subscription;

  int? playlistId;

  @override
  Future<bool> initData() async {
    setBusy(true);

    subscription = AppData.eventBus.on<RefreshLibraryEvent>().listen((event) {
      if (event.type == 'delFromPlaylist') {
        refresh();
      }
    });
    return super.initData();
  }

  @override
  Future<List<SongModel>> loadRefreshListData({int? pageNum}) async {
    return audioQueryHelper.queryFromPlaylistReal(playlistId ?? 0);
  }

  ///点击整个item
  void clickItem(item, pos) {
    audioPlayerHelper.setNewResource(
        list: list, pos: pos, playlistId: playlistId);
    appRouter.push(PlayingRoute());
  }

  ///点击菜单选项
  void clickItemOptions(item, BuildContext context, int index) {
    BottomOptionsDialog.showDialog(
        pos: index,
        type: 2,
        context: context,
        songModel: item,
        playListId: playlistId);
  }

  void playAll() {
    if (ObjectUtil.isNotEmpty(list)) {
      audioPlayerHelper.setNewResource(
          list: list, pos: 0, playlistId: playlistId);
      appRouter.push(PlayingRoute());
    }
  }
}
