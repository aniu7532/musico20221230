import 'package:musico/utils/toast_util.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flustars/flustars.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

final AudioPlayerHelper audioPlayerHelper = AudioPlayerHelper();

class AudioPlayerHelper {
  factory AudioPlayerHelper() => _instance;

  AudioPlayerHelper._();

  static late final AudioPlayerHelper _instance = AudioPlayerHelper._();

  late AudioPlayerHandler _audioHandler;

  ValueStream<PlaybackState> get playbackState => _audioHandler.playbackState;

  Stream<Duration> get position => _audioHandler._player.positionStream;

  MediaItem? get nowMediaItem {
    if (ObjectUtil.isNotEmpty(_audioHandler)) {
      if (ObjectUtil.isNotEmpty(_audioHandler._player)) {
        if (ObjectUtil.isNotEmpty(_audioHandler._player.sequence)) {
          print(
              '_audioHandler._player.currentIndex : ${_audioHandler._player.currentIndex}');

          return _audioHandler
              ._player
              .sequence?[_audioHandler._player.currentIndex ?? 0]
              .tag as MediaItem;
        }
      }
    }
    return null;
  }

  MediaItem? get nextMediaItem {
    if (ObjectUtil.isNotEmpty(_audioHandler)) {
      if (ObjectUtil.isNotEmpty(_audioHandler._player)) {
        if (ObjectUtil.isNotEmpty(_audioHandler._player.sequence)) {
          return _audioHandler
              ._player
              .sequence?[_audioHandler._player.currentIndex ?? 0]
              .tag as MediaItem;
        }
      }
    }
    return null;
  }

  List<SongModel?>? get nowMusicList => _audioHandler._player.sequence
      ?.map((e) => mediaItemToSongModel(e.tag as MediaItem))
      .toList();

  SongModel? get nowSongModel => mediaItemToSongModel(nowMediaItem);

  AudioPlayer get audioPlayer => _audioHandler._player;

  PlayMethod get playMethod => _nowPlayMethod;

  ///当前播放模式
  var _nowPlayMethod = PlayMethod.sequential;

  ///当前播放的歌单id  track 为 null
  int? _nowPlaylistId;

  ///初始化
  Future<void> init() async {
    _audioHandler = await AudioService.init<AudioPlayerHandler>(
      builder: AudioPlayerHandler.new,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.aniu.myapp.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      ),
    );
    audioPlayer.currentIndexStream.listen((v) {
      _audioHandler.mediaItem.add(nowMediaItem);
    });
  }

  ///重置播放资源
  void setNewResource({
    required List<SongModel> list,
    required int pos,
    required int? playlistId,
    PlayMethod? playMethod,
  }) {
    if (ObjectUtil.isEmpty(playMethod)) {
      //如果没传  playMethod 就先取 当前，没有的话是否取缓存，再没有取默认值
    } else {}
    if (ObjectUtil.isNotEmpty(list)) {
      //断引用
      final value = <SongModel>[];
      for (final element in list) {
        final infoMap = element.getMap;
        value.add(SongModel(infoMap));
      }

      if (ObjectUtil.isNotEmpty(value[pos])) {
        //判断下 同一个歌单里面的同一首歌再次进来就不要重新播放了

        if (playlistId == _nowPlaylistId) {
          if (ObjectUtil.isEmpty(playlistId)) {
            //track
            _audioHandler.resetSources(list, pos);
            /* if (ObjectUtil.isEmpty(_audioHandler._player.audioSource)) {
              _audioHandler.resetSources(list, pos);
            } else {
              _audioHandler.seekTo(pos);
            }*/
          } else {
            //playList
            if (value[pos].id == nowSongModel?.id) {
              return;
            } else {
              //_audioHandler.seekTo(pos);
              _audioHandler.resetSources(list, pos);
            }
          }
        } else {
          _audioHandler.resetSources(list, pos);
        }
      }
      _nowPlaylistId = playlistId;
    }
  }

  void play() {
    _audioHandler.play();
  }

  void pause() {
    _audioHandler.pause();
  }

  void stop() {
    _audioHandler.stop();
  }

  void seek(Duration newPosition) {
    _audioHandler.seek(newPosition);
  }

  ///跳到某一首歌
  void skipSong(int pos) {
    _audioHandler._player.seek(Duration.zero, index: pos);
  }

  ///上一首
  void skipToPrevious() {
    if (_audioHandler._player.hasPrevious) {
      _audioHandler._player.seekToPrevious();
    } else {
      MyToast.showToast("It's already the first song");
    }
  }

  ///下一首
  void skipToNext({bool playSelf = false}) {
    //

    if (!playSelf) {
      if (_audioHandler._player.hasNext) {
        _audioHandler._player.seekToNext();
      }
    } else {
      stop();
      seek(Duration.zero);
      play();
    }
  }

  ///切换播放模式
  void changePlayMethod() {
    if (_nowPlayMethod == PlayMethod.sequential) {
      _nowPlayMethod = PlayMethod.random;
      audioPlayerHelper.audioPlayer.setShuffleModeEnabled(true);
      audioPlayerHelper.audioPlayer.shuffle();
      audioPlayerHelper.audioPlayer.setLoopMode(LoopMode.all);
    } else if (_nowPlayMethod == PlayMethod.random) {
      audioPlayerHelper.audioPlayer.setShuffleModeEnabled(false);
      _nowPlayMethod = PlayMethod.loop;
      audioPlayerHelper.audioPlayer.setLoopMode(LoopMode.one);
    } else if (_nowPlayMethod == PlayMethod.loop) {
      audioPlayerHelper.audioPlayer.setShuffleModeEnabled(false);
      _nowPlayMethod = PlayMethod.sequential;
      audioPlayerHelper.audioPlayer.setLoopMode(LoopMode.all);
    }
  }

  ///
  /// 删除当前歌曲 从播放列表
  ///
  Future<int> delFromPlayingList(int pos, SongModel? songModel) async {
    if (ObjectUtil.isNotEmpty(_audioHandler.playSongList) &&
        pos < _audioHandler.playSongList.length) {
      if (_audioHandler.playSongList.length == 1) {
        return 1;
      }
      await _audioHandler.playSongList.removeAt(pos);
    }
    return _audioHandler.playSongList.length;
  }

  ///
  /// 删除当前歌曲 从track
  ///
  void delFromTrack(int pos, SongModel? songModel) {
    if (_nowPlaylistId == null && _audioHandler._player.audioSource != null) {
      if (ObjectUtil.isNotEmpty(_audioHandler.playSongList) &&
          pos < _audioHandler.playSongList.length) {
        _audioHandler.playSongList.removeAt(pos);
      }

      if (_audioHandler.playSongList.length == 0) {
        _audioHandler._player.stop();
        // _audioHandler._player.dispose();
        // _audioHandler.stop();
      }
    }
  }

  SongModel? mediaItemToSongModel(MediaItem? mediaItem) {
    if (ObjectUtil.isEmpty(mediaItem)) {
      return null;
    }
    return SongModel(mediaItem?.extras?['songModel']);
  }

  // 格式化时间
  String formatDurationToTime(Duration duration) {
    if (ObjectUtil.isEmpty(duration)) {
      return '00:00';
    }
    return RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
            .firstMatch('$duration')
            ?.group(1) ??
        '$duration';
  }
}

/// An [AudioHandler] for playing a single item.
class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  /// Initialise our audio handler.
  AudioPlayerHandler() {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    // ... and also the current media item via mediaItem.
  }

  late ConcatenatingAudioSource playSongList;

  void resetSources(List<SongModel> songModels, int pos) {
    _player.stop();

    final list = songModels.map((e) {
      final mItem = songModelToMediaItem(e);

      return AudioSource.uri(Uri.parse(mItem!.id), tag: mItem);
    }).toList();

    playSongList = ConcatenatingAudioSource(
      children: list,
    );

    _player.setAudioSource(
      playSongList,
      initialIndex: pos,
    );

    _player.play();
    audioPlayerHelper.audioPlayer.setShuffleModeEnabled(false);
    audioPlayerHelper.audioPlayer.setLoopMode(LoopMode.all);
    mediaItem.add(audioPlayerHelper.nowMediaItem);
  }

  void seekTo(int pos) {
    _player.seek(Duration(milliseconds: 1000), index: pos).then((value) {
      _player.play();
    });
  }

  MediaItem? songModelToMediaItem(SongModel songModel) {
    if (ObjectUtil.isEmpty(songModel)) {
      return null;
    }
    return MediaItem(
      id: songModel.data,
      album: songModel.album,
      title: songModel.title,
      artist: songModel.artist,
      duration: Duration(milliseconds: songModel.duration ?? 0),
      extras: {'songModel': songModel.getMap},
    );
  }

  // In this simple example, we handle only 4 actions: play, pause, seek and
  // stop. Any button press from the Flutter UI, notification, lock screen or
  // headset will be routed through to these 4 methods so that you can handle
  // your audio playback logic in one place.

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

///播放模式枚举
///Sequential Play Random Play Singles Loop
enum PlayMethod {
  sequential, // 顺序播放
  random, // 随机播放
  loop, //单曲循环
}
