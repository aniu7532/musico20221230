import 'dart:async';

import 'package:musico/app/myapp.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/base/view_state.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/eventbus/refresh_library_event.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/dialog_utils.dart';
import 'package:musico/utils/helper/audio_query_helper.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:musico/widgets/dialog/bottom_options_dialog.dart';
import 'package:musico/widgets/dialog/textinput_dialog.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

mixin _Protocol {}

class LibraryModel extends BaseListMoreModel<PlaylistModel> with _Protocol {
  LibraryModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    showSearchWidget = false;
    viewState = ViewState.empty;
  }

  StreamSubscription? subscription;

  @override
  Future<bool> initData() async {
    setBusy(true);
    subscription = AppData.eventBus.on<RefreshLibraryEvent>().listen((event) {
      if (event.type == 'refresh') {
        refresh();
      }
    });
    return super.initData();
  }

  @override
  Future<List<PlaylistModel>> loadRefreshListData({int? pageNum}) async {
    var rst = await audioQueryHelper.queryLibrary();
    if (ObjectUtil.isEmpty(rst)) {
      await audioQueryHelper.createPlaylist(
        'favorite',
        author: 'system',
        desc: 'favorite',
      );
      rst = await audioQueryHelper.queryLibrary();
    }
    return rst;
  }

  ///点击整个item
  void clickItem(item, context) async {
    final PlaylistModel bean = item;
    await appRouter.push(
      PlaylistDetailRoute(
        requestParams: {'title': bean.playlist, 'playlistId': bean.id},
      ),
    );
  }

  ///点击菜单选项
  void clickItemOptions(item, BuildContext context) {
    BottomOptionsDialog.showDialog(
      context: context,
      type: 1,
      songModel: null,
      playlistModel: item,
      deletePlaylist: () async {
        await audioQueryHelper.delPlaylist(item.id);
        refresh();
      },
      rename: () async {
        await showTextInputDialog(
          context: context,
          title: 'rename playlist',
          initialText: (item as PlaylistModel).playlist,
          keyboardType: TextInputType.name,
          onSubmitted: (value) async {
            if (ObjectUtil.isEmpty(value)) {
              MyToast.showToast('please enter a name');
            } else {
              Navigator.pop(context);
              showZzLoadingDialog(context, small: true);
              final b = await audioQueryHelper.renamePlaylist(
                item.id,
                value,
              );
              // Navigator.pop(context);
              if (b) {
                refresh();
              }
            }
          },
        );
      },
    );
  }

  void createPlayList(BuildContext context) async {
    //showInputDialog(context);
    await showTextInputDialog(
        context: context,
        title: 'create playlist',
        keyboardType: TextInputType.name,
        onSubmitted: (value) async {
          if (ObjectUtil.isEmpty(value)) {
            MyToast.showToast('please enter a name');
          } else if (value == 'favorite') {
            // MyToast.showToast('already had');
          } else {
            var rst = await audioQueryHelper.queryLibrary();
            if (ObjectUtil.isNotEmpty(rst)) {
              if (rst.any((element) => element.playlist == value)) {
                MyToast.showToast('playlist is existed');
              } else {
                final b = await audioQueryHelper.createPlaylist(value);
                if (b) {
                  Navigator.pop(context);
                  refresh();
                }
              }
            }
          }
        });
  }
}
