import 'dart:async';
import 'dart:io';

import 'package:musico/app/myapp.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/base/view_state.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/eventbus/refresh_library_event.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/helper/audio_player_helper.dart';
import 'package:musico/utils/helper/audio_query_helper.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:musico/widgets/dialog/bottom_options_dialog.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

mixin _Protocol {}

class TrackModel extends BaseListMoreModel<SongModel> with _Protocol {
  TrackModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    showSearchWidget = false;
    viewState = ViewState.empty;
  }
  StreamSubscription? subscription;
  @override
  Future<bool> initData() async {
    setBusy(true);

    subscription = AppData.eventBus.on<RefreshLibraryEvent>().listen((event) {
      if (event.type == 'del') {
        refresh();
      } else if (event.type == 'import') {
        refresh(init: true);
      }
    });

    return super.initData();
  }

  @override
  Future<List<SongModel>> loadRefreshListData({int? pageNum}) async {
    return audioQueryHelper.queryTrack();
  }

  ///点击整个item
  void clickItem(item, pos) {
    audioPlayerHelper.setNewResource(list: list, pos: pos, playlistId: null);
    appRouter.push(PlayingRoute());
  }

  ///点击菜单选项
  void clickItemOptions(item, pos, BuildContext context) {
    BottomOptionsDialog.showDialog(
        context: context,
        songModel: item,
        deleteSongFromTrack: () async {
          final file = File('${item?.data}');
          try {
            if (file.existsSync()) {
              file.deleteSync();
              await refresh();
              await audioQueryHelper.scan().then((value) {
                audioPlayerHelper.delFromTrack(pos, item);
              });
            }
          } catch (e) {
            debugPrint('$e');
          }
        });
  }

  void playAll() {
    if (ObjectUtil.isNotEmpty(list)) {
      audioPlayerHelper.setNewResource(list: list, pos: 0, playlistId: null);
      appRouter.push(PlayingRoute());
    }
  }
}
