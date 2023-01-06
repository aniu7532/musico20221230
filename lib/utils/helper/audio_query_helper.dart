import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/const/app_const.dart';
import 'package:musico/pages/imports/import_from_phone/import_from_phone_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

final AudioQueryHelper audioQueryHelper = AudioQueryHelper();

class AudioQueryHelper {
  factory AudioQueryHelper() => _instance;

  AudioQueryHelper._() {
    _onAudioQuery = OnAudioQuery();
  }

  static late final AudioQueryHelper _instance = AudioQueryHelper._();

  late OnAudioQuery _onAudioQuery;

  ///获取除media以外的能获取到的本手机的所有数据
  ///needUploaded 是否显示已经上传到track的歌曲
  Future<List<SongModelWithOtherInfo>> queryAllSongs(
      {bool needUploaded = false}) async {
    final b = await requestPermission();
    if (!b) {
      return [];
    }
    final rst = await _onAudioQuery.querySongs(
      uriType: UriType.EXTERNAL,
    );

    rst.removeWhere(
      (element) => element.data.contains(AppConst.localMusicPath),
    );

    if (!needUploaded) {
      final track = await queryTrack();
      for (final trackElement in track) {
        rst.removeWhere(
          (element) => trackElement.title == element.title,
        );
      }
    }

    final realRst = rst.map(SongModelWithOtherInfo.new).toList();

    return realRst;
  }

  /// 通知media刷新
  Future<void> scan() async {
    await _onAudioQuery.scanMedia(AppConst.localMusicPath);
  }

  ///获取track
  Future<List<SongModel>> queryTrack() async {
    final b = await requestPermission();
    if (!b) {
      return [];
    }
    await scan();
    final rst = await _onAudioQuery.querySongs(
      uriType: UriType.EXTERNAL,
      path: AppConst.localMusicPath,
      orderType: OrderType.DESC_OR_GREATER,
      sortType: SongSortType.DATE_ADDED,
    );
    return rst;
  }

  ///获取library
  Future<List<PlaylistModel>> queryLibrary() async {
    final b = await requestPermission();
    if (!b) {
      return [];
    }
    //  await _onAudioQuery.scanMedia(AppConst.localMusicPath);
    final ss = await _onAudioQuery.queryPlaylists();
    return ss;
  }

  ///创建歌单
  Future<bool> createPlaylist(
    String name, {
    String? author,
    String? desc,
  }) async {
    final b = await requestPermission();
    if (!b) {
      return false;
    }
    return _onAudioQuery.createPlaylist(name);
  }

  ///重命名歌单
  Future<bool> renamePlaylist(
    int id,
    String name,
  ) async {
    final b = await requestPermission();
    if (!b) {
      return false;
    }
    //由于重命名 api在报错 现在采用替代方案
    //先查询到当前要重命名的歌单的歌曲
    //再删除歌单
    //创建新歌单
    //添加之前的歌曲

    //这里的歌曲id查出来不一样 也需要匹配获取

    final songs = await queryFromPlaylist(id);
    await delPlaylist(id);
    await createPlaylist(name, desc: 'rename');
    final list = await queryLibrary();
    final newId = list.where((element) => element.playlist == name).first.id;
    for (final element in songs) {
      final realId = await getRealId(element.data);
      await addToPlaylist(newId, realId, null);
    }

    await appRouter.pop();
    return true;
  }

  Future<bool> renamePlaylistOld(
    BuildContext context,
    int id,
    String name,
  ) async {
    final b = await requestPermission();
    if (!b) {
      return false;
    }

    return _onAudioQuery.renamePlaylist(id, name);
  }

  //通过歌曲真实路径获取真实id
  Future<int> getRealId(String path) async {
    final track = await queryTrack();
    final rst = track.where((element) => element.data == path).toList();
    if (ObjectUtil.isEmpty(rst)) {
      return -1;
    }
    final id = rst.first.id;
    return id;
  }

  ///查询歌单中的歌曲
  Future<List<SongModel>> queryFromPlaylist(
    int id,
  ) async {
    final b = await requestPermission();
    if (!b) {
      return [];
    }

    return _onAudioQuery.queryAudiosFrom(AudiosFromType.PLAYLIST, id);
  }

  ///查询歌曲是否在 favorite 中
  Future<bool> queryStar(
    int id,
  ) async {
    final b = await requestPermission();
    if (!b || id == -1) {
      return false;
    }
    final track = await queryTrack();
    final item = track.where((element) => element.id == id).first;
    final lb = await queryLibrary();
    final favorite =
        lb.where((element) => element.playlist == 'favorite').first;
    if (ObjectUtil.isNotEmpty(favorite)) {
      final favoriteSongList = await queryFromPlaylist(favorite.id);
      if (ObjectUtil.isNotEmpty(favoriteSongList)) {
        final b = favoriteSongList.any((element) => element.data == item.data);
        if (b) {
          return true;
        }
      }
    }
    return false;
  }

  ///通过title获取 针对某些id有问题的歌曲
  Future<bool> queryStarByTitle(
    String title,
  ) async {
    final b = await requestPermission();
    if (!b || ObjectUtil.isEmpty(title)) {
      return false;
    }

    final lb = await queryLibrary();
    final favorite =
        lb.where((element) => element.playlist == 'favorite').first;
    if (ObjectUtil.isNotEmpty(favorite)) {
      final favoriteSongList = await queryFromPlaylist(favorite.id);
      if (ObjectUtil.isNotEmpty(favoriteSongList)) {
        final b = favoriteSongList.any((element) => element.title == title);
        if (b) {
          return true;
        }
      }
    }
    return false;
  }

  ///
  /// 收藏
  ///
  Future<bool> Star(
    int id,
  ) async {
    final b = await requestPermission();
    if (!b) {
      return false;
    }
    final track = await queryTrack();
    final item = track.where((element) => element.id == id).first;
    final lb = await queryLibrary();
    final favorite =
        lb.where((element) => element.playlist == 'favorite').first;
    if (ObjectUtil.isNotEmpty(favorite)) {
      final favoriteSongList = await queryFromPlaylist(favorite.id);
      if (ObjectUtil.isNotEmpty(favoriteSongList)) {
        final b = favoriteSongList.any((element) => element.data == item.data);
        if (b) {
          final pos = favoriteSongList
              .indexWhere((element) => element.data == item.data);
          return delSongFromPlaylist(favorite.id, pos);
        } else {
          await addToPlaylist(favorite.id, item.id, item.data);
        }
      } else {
        await addToPlaylist(favorite.id, item.id, item.data);
      }
    }
    return false;
  }

  ///查询歌单中的歌曲
  Future<List<SongModel>> queryFromPlaylistReal(
    int id,
  ) async {
    final songs = await queryFromPlaylist(id);

    for (final element in songs) {
      final realId = await getRealId(element.data);

      if (realId != -1) {
        element.getMap['_id'] = realId;
      }

      // SongModel(element.getMap);
    }

    return songs;
  }

  ///删除歌单
  Future<bool> delPlaylist(int playlistId) async {
    final b = await requestPermission();
    if (!b) {
      return false;
    }

    return _onAudioQuery.removePlaylist(playlistId);
  }

  ///从歌单删除某首歌
  Future<bool> delSongFromPlaylist(int playlistId, int pos) async {
    final b = await requestPermission();
    if (!b) {
      return false;
    }
    final s = await _onAudioQuery.queryAudiosFrom(
        AudiosFromType.PLAYLIST, playlistId);
    return _onAudioQuery.removeFromPlaylist(playlistId, s[pos].id);
  }

  ///添加到歌单
  Future<bool> addToPlaylist(
      int playlistId, int audioId, String? audioPath) async {
    final b = await requestPermission();
    if (!b) {
      return false;
    }
    final songs = await queryFromPlaylist(playlistId);

    if (ObjectUtil.isNotEmpty(songs) && ObjectUtil.isNotEmpty(audioPath)) {
      if (songs.any((element) => element.data == audioPath)) {
        return false;
      }
    }

    return _onAudioQuery.addToPlaylist(playlistId, audioId);
  }

  ///权限判断
  Future<bool> requestPermission() async {
    if (!kIsWeb) {
      final permissionStatus = await _onAudioQuery.permissionsStatus();
      if (!permissionStatus) {
        return _onAudioQuery.permissionsRequest();
      }

      if (!Directory('${AppConst.localMusicPath}/').existsSync()) {
        Directory('${AppConst.localMusicPath}/').createSync();
        if (kDebugMode) {
          print('-------- create Directory -------');
        }
      }

      return true;
    }
    return false;
  }
}
