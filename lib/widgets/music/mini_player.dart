import 'package:musico/app/myapp.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/helper/audio_player_helper.dart';
import 'package:musico/utils/strings.dart';
import 'package:musico/widgets/animated_text.dart';
import 'package:musico/widgets/music/asset_button.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: audioPlayerHelper.playbackState,
      builder: (context, snapshot) {
        final playBackState = snapshot.data;
        final processingState = playBackState?.processingState;
        if (processingState == AudioProcessingState.idle) {
          return const SizedBox.shrink();
        }
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            appRouter.push(PlayingRoute());
          },
          child: Column(
            children: [
              Container(
                color: const Color(0xff333333),
                height: 61.h,
                child: Row(
                  children: [
                    Expanded(
                      child: StreamBuilder<SequenceState?>(
                        stream:
                            audioPlayerHelper.audioPlayer.sequenceStateStream,
                        builder: (context, snapshot) {
                          final state = snapshot.data;
                          if (state?.sequence.isEmpty ?? true) {
                            return const SizedBox();
                          }

                          return Row(
                            children: [
                              SizedBox(
                                width: 14.w,
                              ),
                              QueryArtworkWidget(
                                id: audioPlayerHelper.nowSongModel?.id ?? 0,
                                type: ArtworkType.AUDIO,
                                artworkWidth: 50,
                                artworkHeight: 50,
                                artworkBorder: BorderRadius.circular(180),
                                nullArtworkWidget:
                                    Assets.images.miniPlayerIcon.image(
                                  fit: BoxFit.fill,
                                  height: 80.w,
                                ),
                              ),
                              Expanded(
                                child: AnimatedText(
                                  text: audioPlayerHelper.nowMediaItem?.title ??
                                      '',
                                  pauseAfterRound: const Duration(seconds: 3),
                                  showFadingOnlyWhenScrolling: false,
                                  fadingEdgeEndFraction: 0.1,
                                  fadingEdgeStartFraction: 0.1,
                                  startAfter: const Duration(seconds: 2),
                                  style: FSUtils.normal_16_FFFFFF,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    StreamBuilder<PlaybackState>(
                        stream: audioPlayerHelper.playbackState,
                        builder: (context, snapshot) {
                          final playing = (snapshot.data?.playing) ?? false;
                          return Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              AssetButton(
                                asset: Assets.images.play.pre,
                                height: 12.h,
                                boxWidth: 34.w,
                                color: audioPlayerHelper.audioPlayer.hasPrevious
                                    ? null
                                    : const Color(0x44ffffff),
                                outClickCallBack: () {
                                  audioPlayerHelper.skipToPrevious();
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              if (playing)
                                AssetButton(
                                  asset: Assets.images.play.playWhite,
                                  height: 28.h,
                                  outClickCallBack: () {
                                    audioPlayerHelper.pause();
                                  },
                                )
                              else
                                AssetButton(
                                  asset: Assets.images.play.pauseWhite,
                                  height: 28.h,
                                  outClickCallBack: () {
                                    audioPlayerHelper.play();
                                  },
                                ),
                              const SizedBox(
                                width: 10,
                              ),
                              AssetButton(
                                asset: Assets.images.play.next,
                                height: 12.h,
                                boxWidth: 34.w,
                                outClickCallBack: () {
                                  audioPlayerHelper.skipToNext();
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          );
                        })
                  ],
                ),
              ),
              _seek(),
            ],
          ),
        );
      },
    );
  }

  Widget _seek() {
    return StreamBuilder<SequenceState?>(
        stream: audioPlayerHelper.audioPlayer.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state?.sequence.isEmpty ?? true) {
            return const SizedBox();
          }
          final mediaItem = state!.currentSource!.tag as MediaItem;

          final duration = (mediaItem.duration ?? Duration.zero).inMilliseconds;

          return StreamBuilder<Duration>(
              stream: audioPlayerHelper.position,
              builder: (context, snapshot) {
                final pos = snapshot.data;

                var value = 0.0;
                final position = (pos ?? Duration.zero).inMilliseconds;

                if (position > 0 && position < duration) {
                  value = position / duration;
                }

                ///歌曲进度条自动播放完成时
                if (duration != 0 && position >= duration) {
                  audioPlayerHelper.skipToNext(
                      playSelf:
                          audioPlayerHelper.playMethod == PlayMethod.loop);
                }
                return SizedBox(
                  height: 2,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(1.5)),
                    child: LinearProgressIndicator(
                      value: value,
                      backgroundColor: ColorName.progressBgColor,
                      valueColor: const AlwaysStoppedAnimation(
                          ColorName.secondaryColor),
                    ),
                  ),
                );
              });
        });
  }
}
