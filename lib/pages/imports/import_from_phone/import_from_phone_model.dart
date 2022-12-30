import 'dart:io';

import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/base/view_state.dart';
import 'package:musico/const/app_const.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/eventbus/refresh_library_event.dart';
import 'package:musico/eventbus/tab_select_event.dart';
import 'package:musico/utils/dialog_utils.dart';
import 'package:musico/utils/helper/audio_query_helper.dart';
import 'package:musico/widgets/dialog/bottom_options_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

mixin _Protocol {}

class ImportFromPhoneModel extends BaseListMoreModel<SongModelWithOtherInfo>
    with _Protocol {
  ImportFromPhoneModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    showSearchWidget = false;
    viewState = ViewState.empty;
  }

  bool get canUpload => list.any((element) => element.isSelect);

  bool get isSelectedAll => list.every((element) => element.isSelect);

  @override
  Future<bool> initData() async {
    setBusy(true);
    return super.initData();
  }

  @override
  Future<List<SongModelWithOtherInfo>> loadRefreshListData(
      {int? pageNum}) async {
    return audioQueryHelper.queryAllSongs();
  }

  ///点击菜单选项
  void clickItemOptions(item, BuildContext context) {
    BottomOptionsDialog.showDialog(context: context, songModel: item.songModel);
  }

  void selectAll() {
    if (isSelectedAll) {
      for (final element in list) {
        element.isSelect = false;
      }
    } else {
      for (final element in list) {
        element.isSelect = true;
      }
    }

    notifyListeners();
  }

  Future<void> upload(BuildContext context) async {
    if (canUpload) {
      showZzLoadingDialog(context);

      final selectedList = list.where((element) => element.isSelect).toList();

      for (final element in selectedList) {
        if (File(element.songModel.data).existsSync() &&
            !File('${AppConst.localMusicPath}/${element.songModel.title}.mp3')
                .existsSync()) {
          try {
            await File(element.songModel.data).copy(
              '${AppConst.localMusicPath}/${element.songModel.title}.mp3',
            );
          } catch (e) {
            if (kDebugMode) {
              print('copy file error:$e');
            }
          }
        }
      }
      AppData.eventBus.fire(RefreshLibraryEvent('import'));
      AppData.eventBus.fire(TabSelectEvent(0));
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}

class SongModelWithOtherInfo {
  SongModelWithOtherInfo(this.songModel, {this.isSelect = false});
  SongModel songModel;
  bool isSelect;
}
