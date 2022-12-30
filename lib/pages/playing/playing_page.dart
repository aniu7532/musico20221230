import 'dart:ui';

import 'package:musico/app/myapp.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/base_page_mixin.dart';
import 'package:musico/base/provider_widget.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/pages/playing/playing_model.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/helper/audio_player_helper.dart';
import 'package:musico/utils/helper/audio_query_helper.dart';
import 'package:musico/utils/strings.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:musico/widgets/music/asset_button.dart';
import 'package:musico/widgets/slider/my_slider_track_shape.dart';
import 'package:musico/widgets/zz_back_button.dart';
import 'package:musico/widgets/zz_show_model_bottom_sheet.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

/// 播放页
class PlayingPage extends BasePage {
  PlayingPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<PlayingPage> createState() => _PlayingPageState();
}

class _PlayingPageState extends BasePageState<PlayingPage>
    with
        BasePageMixin<PlayingPage, PlayingModel>,
        SingleTickerProviderStateMixin {
  @override
  PlayingModel initModel() {
    return PlayingModel(requestParam: widget.requestParams);
  }

  late final AnimationController? controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this);
  }

  @override
  bool needRefreshAll() {
    return false;
  }

  @override
  List<Widget> getActions() {
    return [];
  }

  @override
  Widget buildContainerWidget() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        StreamBuilder<SequenceState?>(
            stream: audioPlayerHelper.audioPlayer.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                return const SizedBox();
              }
              final metadata = state!.currentSource!.tag as MediaItem;

              final id = metadata.extras?['songId'];
              return QueryArtworkWidget(
                id: audioPlayerHelper.nowSongModel?.id ?? 0,
                type: ArtworkType.AUDIO,
                artworkWidth: width,
                artworkHeight: height,
                artworkBorder: BorderRadius.circular(4),
                nullArtworkWidget: Assets.images.play.playMusicDefault.image(
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ),
              );
            }),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: Opacity(
            opacity: 0.5,
            child: Container(
              height: height,
              width: width,
              color: const Color(0xff343434),
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: 40.h,
            ),
            _headerWidget(),
            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child: Column(
                children: [
                  StreamBuilder<SequenceState?>(
                    stream: audioPlayerHelper.audioPlayer.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state?.sequence.isEmpty ?? true) {
                        return const SizedBox();
                      }

                      return QueryArtworkWidget(
                        id: audioPlayerHelper.nowSongModel?.id ?? 0,
                        type: ArtworkType.AUDIO,
                        artworkWidth: 318.w,
                        artworkHeight: 318.w,
                        artworkBorder: BorderRadius.circular(4),
                        nullArtworkWidget:
                            Assets.images.play.playMusicDefault.image(
                          width: 318.w,
                          height: 318.w,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPlayingInfo(),
                          _buildSlider(),
                          _buildPlayController(),
                          const SizedBox(
                            height: 29,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildAd(),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  ///头部操作项
  Widget _headerWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 44.h,
      child: Row(
        children: [
          const ZzBackButton(),
/*          AssetButton(
            asset: Assets.images.play.arrowDown,
            boxWidth: 44,
            height: 24.h,
            outClickCallBack: appRouter.pop,
          ),*/
          const Spacer(),
          Visibility(
            visible: false,
            child: AssetButton(
              asset: Assets.images.play.more,
              boxWidth: 44,
              height: 24.h,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildContentWidget() {
    return const SizedBox.shrink();
  }

  ///歌曲信息
  Widget _buildPlayingInfo() {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<SequenceState?>(
            stream: audioPlayerHelper.audioPlayer.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                return const SizedBox();
              }
              final mediaItem = state!.currentSource!.tag as MediaItem;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (mediaItem.title).noWideSpace,
                    style: FSUtils.weight500_21_ffffff,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    (mediaItem.artist ?? '').noWideSpace,
                    style: FSUtils.w500_13_B3FFFFFF,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
        ),
        Visibility(
          visible: false,
          child: AssetButton(
            asset: Assets.images.play.download,
            height: 24.h,
            boxHeight: 44.h,
            boxWidth: 44.w,
            outClickCallBack: () {
              MyToast.showToast('download');
            },
          ),
        ),
        ChangeNotifierProvider<PlayingModel>.value(
          value: model,
          child: Consumer<PlayingModel>(
            builder: (
              BuildContext context,
              PlayingModel value,
              Widget? child,
            ) {
              return AssetButton(
                asset: (model.star)
                    ? Assets.images.play.starRed
                    : Assets.images.play.starEmpty,
                height: 24.h,
                boxHeight: 44.h,
                boxWidth: 44.w,
                outClickCallBack: () {
                  model.addToFarivate(context);
                },
              );
            },
          ),
        )
      ],
    );
  }

  ///进度条
  Widget _buildSlider() {
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
                    playSelf: audioPlayerHelper.playMethod == PlayMethod.loop);
                model.getStar();
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        audioPlayerHelper.formatDurationToTime(
                          pos ?? Duration.zero,
                        ),
                        style: FSUtils.w600_12_91FFFFFF,
                      ),
                      Text(
                        audioPlayerHelper.formatDurationToTime(
                          mediaItem.duration ?? Duration.zero,
                        ),
                        style: FSUtils.w600_12_91FFFFFF,
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: ColorName.secondaryColor, //已播放进度条颜色
                      inactiveTrackColor:
                          Colors.white.withOpacity(0.18), //未播放的进度条颜色
                      thumbColor: ColorName.secondaryColor, //滑块颜色
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 4),
                      trackShape: MySliderTrackShape(),
                      trackHeight: 2.h,
                    ),
                    child: Slider(
                      value: value,
                      onChanged: (pos) {
                        final curPosition = pos * duration;
                        audioPlayerHelper
                            .seek(Duration(milliseconds: curPosition.round()));
                      },
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  ///播放控制
  Widget _buildPlayController() {
    return StreamBuilder<PlaybackState?>(
      stream: audioPlayerHelper.playbackState,
      builder: (context, snapshot) {
        final playing = (snapshot.data?.playing) ?? false;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProviderWidget<PlayingModel>(
              model: model,
              onModelReady: (model) {
                ///初始化
                model.initData();
              },
              builder: (context, model, child) {
                return AssetButton(
                  asset: model.getMethodAsset(),
                  height: 26,
                  boxHeight: 30,
                  boxWidth: 30,
                  outClickCallBack: () {
                    audioPlayerHelper.changePlayMethod();
                    model.notifyListeners();
                  },
                );
              },
            ),
            AssetButton(
              asset: Assets.images.play.pre,
              height: 16,
              boxHeight: 30,
              boxWidth: 30,
              color: audioPlayerHelper.audioPlayer.hasPrevious
                  ? null
                  : const Color(0x44ffffff),
              outClickCallBack: () {
                audioPlayerHelper.skipToPrevious();
                model.getStar();
              },
            ),
            if (playing)
              AssetButton(
                asset: Assets.images.play.pauseCir,
                height: 58,
                outClickCallBack: () {
                  audioPlayerHelper.pause();
                },
              )
            else
              AssetButton(
                asset: Assets.images.play.playCir,
                height: 58,
                outClickCallBack: () {
                  audioPlayerHelper.play();
                },
              ),
            AssetButton(
              asset: Assets.images.play.next,
              height: 16,
              boxHeight: 30,
              boxWidth: 30,
              outClickCallBack: () {
                audioPlayerHelper.skipToNext();
                model.getStar();
              },
            ),
            AssetButton(
              asset: Assets.images.play.list,
              height: 26,
              boxHeight: 30,
              boxWidth: 30,
              outClickCallBack: () {
                showList(context);
              },
            ),
          ],
        );
      },
    );
  }

  ///歌曲列表
  void showList(BuildContext context) {
    zzShowModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.only(left: 18, right: 18, bottom: 20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(9),
            ),
            color: Color(0xff1A1A1A),
          ),
          child: ChangeNotifierProvider<PlayingModel>.value(
            value: model,
            child: Consumer<PlayingModel>(
              builder: (
                BuildContext context,
                PlayingModel value,
                Widget? child,
              ) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: audioPlayerHelper.nowMusicList?.length,
                  itemBuilder: (c, i) {
                    final song = audioPlayerHelper.nowMusicList?[i];

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        audioPlayerHelper.skipSong(i);
                        appRouter.pop();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (song?.title ?? '').noWideSpace,
                                    style: song?.id ==
                                            audioPlayerHelper.nowSongModel?.id
                                        ? FSUtils.weight500_15_D0F91B
                                        : FSUtils.weight500_15_FFFFFF, //
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    (song?.artist ?? '').noWideSpace,
                                    style: FSUtils.normal_12_969898,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            AssetButton(
                              asset: Assets.images.play.delFromPlayinglist,
                              height: 14.h,
                              boxHeight: 30.h,
                              boxWidth: 30.w,
                              outClickCallBack: () {
                                audioPlayerHelper
                                    .delFromPlayingList(i, song)
                                    .then((len) {
                                  if (len == 0) {
                                    appRouter.pop();
                                  } else {
                                    value.notifyListeners();
                                  }
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  ///广告
  Widget _buildAd() {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: 69.h,
      margin: EdgeInsets.only(bottom: 20.h),
    );
  }
}
