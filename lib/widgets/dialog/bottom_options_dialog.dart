// ignore_for_file: cascade_invocations

import 'dart:io';

import 'package:musico/app/myapp.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/eventbus/refresh_library_event.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/divider_urils.dart';
import 'package:musico/utils/helper/audio_query_helper.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:musico/widgets/music/music_item.dart';
import 'package:musico/widgets/normal_click_item.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

///底部菜单弹窗
class BottomOptionsDialog extends StatefulWidget {
  BottomOptionsDialog._({
    Key? key,
    this.onSave,
    this.type = 0,
    this.pos = 0,
    this.playListId = 0,
    this.songModel,
    this.playlistModel,
    this.rename,
    this.deletePlaylist,
    this.deleteSongFromTrack,
  }) : super(key: key);

  static Future<void> showDialog({
    required BuildContext context,
    required SongModel? songModel,
    PlaylistModel? playlistModel,
    ValueChanged<bool>? onSave,
    Function? rename,
    Function? deletePlaylist,
    Function? deleteSongFromTrack,
    int? pos,
    int? playListId,
    int type = 0, // 0 track list 点击 1 library list 点击 2 playlist点击
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      builder: (context) {
        return BottomOptionsDialog._(
          onSave: onSave,
          type: type,
          songModel: songModel,
          playlistModel: playlistModel,
          rename: rename,
          deletePlaylist: deletePlaylist,
          deleteSongFromTrack: deleteSongFromTrack,
          playListId: playListId,
          pos: pos,
        );
      },
    );
  }

  final ValueChanged<bool>? onSave;
  final int type;
  final int? pos;
  final int? playListId;
  final Function? rename;
  final Function? deletePlaylist;
  final Function? deleteSongFromTrack;
  final SongModel? songModel;
  final PlaylistModel? playlistModel;
  @override
  State<BottomOptionsDialog> createState() => _BottomOptionsDialogState();
}

class _BottomOptionsDialogState extends State<BottomOptionsDialog> {
  late List<Widget> _type1List;

  @override
  void initState() {
    super.initState();

    if (widget.type == 0) {
      _type1List = [
        NormalClickItem(
          title: 'Add to Playlist',
          icon: Assets.images.options.optionsAddPlaylist,
          onTap: () {
            appRouter.pop();
            appRouter.push(
              SelectPlaylistRoute(
                requestParams: {
                  'title': 'Select Playlist',
                  'audioId': '${widget.songModel?.id}',
                  'audioPath': '${widget.songModel?.data}'
                },
              ),
            );
          },
        ),
/*        NormalClickItem(
          title: 'Send to another device',
          icon: Assets.images.options.optionsShare,
        ),*/
        NormalClickItem(
          title: 'Delete',
          icon: Assets.images.options.optionsDel,
          onTap: () async {
            // delete from track
            appRouter.pop();
            widget.deleteSongFromTrack?.call();
          },
        ),
      ];
    } else if (widget.type == 1) {
      _type1List = [
        NormalClickItem(
          title: 'Rename',
          icon: Assets.images.options.optionsRename,
          onTap: () async {
            await appRouter.pop();
            widget.rename?.call();
          },
        ),
        NormalClickItem(
          title: 'Delete',
          icon: Assets.images.options.optionsDel,
          onTap: () async {
            appRouter.pop();
            widget.deletePlaylist?.call();
          },
        ),
      ];
    } else if (widget.type == 2) {
      _type1List = [
        NormalClickItem(
          title: 'Delete',
          icon: Assets.images.options.optionsDel,
          onTap: () async {
            appRouter.pop();
            await audioQueryHelper.delSongFromPlaylist(
                widget.playListId ?? 0, widget.pos ?? 0);
            AppData.eventBus.fire(RefreshLibraryEvent('delFromPlaylist'));
            AppData.eventBus.fire(RefreshLibraryEvent('refresh'));
          },
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /*     height: MediaQuery.of(context).size.height / 2 +
          MediaQuery.of(context).viewInsets.bottom,*/
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        color: ColorName.dialogBgColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              color: ColorName.dialogBgColor,
            ),
            child: MusicItem(
              width: 48,
              height: 48,
              needOptions: false,
              musicItemBean: widget.songModel,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          dividerBottomDialog,
          ..._type1List
        ],
      ),
    );
  }
}
