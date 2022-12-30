import 'package:flutter/material.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/base/view_state_model.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/eventbus/refresh_library_event.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/utils/dialog_utils.dart';
import 'package:musico/utils/helper/audio_player_helper.dart';
import 'package:musico/utils/helper/audio_query_helper.dart';

class PlayingModel extends ViewStateModel {
  PlayingModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    star = false;
  }

  late bool star;

  @override
  initData() {
    audioPlayerHelper.audioPlayer.currentIndexStream.listen((v) {
      getStar();
    });

    return super.initData();
  }

  ///切换播放模式
  void changePlayMethod() {}

  AssetGenImage getMethodAsset() {
    if (audioPlayerHelper.playMethod == PlayMethod.random) {
      return Assets.images.play.playMethod3;
    }
    if (audioPlayerHelper.playMethod == PlayMethod.loop) {
      return Assets.images.play.playMethod2;
    }
    return Assets.images.play.playMethod1;
  }

  Future<void> addToFarivate(BuildContext context) async {
    showZzLoadingDialog(context, small: true);

    await audioQueryHelper.Star(audioPlayerHelper.nowSongModel?.id ?? -1);
    await getStar();
    appRouter.pop();
    AppData.eventBus.fire(RefreshLibraryEvent('refresh'));
  }

  Future<void> getStar() async {
    /*   star = await audioQueryHelper
        .queryStar(audioPlayerHelper.nowSongModel?.id ?? -1);*/
    star = await audioQueryHelper
        .queryStarByTitle(audioPlayerHelper.nowSongModel?.title ?? '');
    notifyListeners();
  }
}
