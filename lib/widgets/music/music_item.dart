import 'package:musico/base/basebeans/music_item_bean.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/strings.dart';
import 'package:musico/widgets/music_item_image_widget.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:musico/gen/assets.gen.dart';

///
/// music listItem
///
class MusicItem extends StatelessWidget {
  MusicItem({
    Key? key,
    this.musicItemBean,
    this.playlistModel,
    this.outClickCallBack,
    this.optionsClickCallBack,
    this.needOptions = true,
    this.width = 60,
    this.height = 60,
  }) : super(key: key);

  //整体点击事件
  Function()? outClickCallBack;

  //列表选项点击事件
  Function()? optionsClickCallBack;

  //数据
  // MusicItemBean? musicItemBean;
  SongModel? musicItemBean;
  PlaylistModel? playlistModel;
  final bool needOptions;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    var name = '';
    var subName = '';

    if (ObjectUtil.isNotEmpty(musicItemBean) &&
        ObjectUtil.isEmpty(playlistModel)) {
      name = musicItemBean?.title ?? 'Unknown'.noWideSpace;
      subName = musicItemBean?.artist ?? 'Unknown'.noWideSpace;
    } else if (ObjectUtil.isEmpty(musicItemBean) &&
        ObjectUtil.isNotEmpty(playlistModel)) {
      name = playlistModel?.playlist ?? 'Unknown'.noWideSpace;
      subName = '${playlistModel?.numOfSongs ?? 0}';
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        outClickCallBack?.call();
      },
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: [
            /*   MusicImageWidget(
              imgUrl:  '',
              width: width,
              height: height,
            ),*/
            QueryArtworkWidget(
              id: musicItemBean?.id ?? 0,
              type: ArtworkType.AUDIO,
              artworkWidth: width,
              artworkHeight: height,
              artworkBorder: BorderRadius.circular(4),
              nullArtworkWidget: Assets.images.musicItemDefault.image(
                width: width,
                height: height,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FSUtils.normal_15_FFFFFF,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    subName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FSUtils.normal_14_969898,
                  )
                ],
              ),
            ),
            Visibility(
              visible: needOptions,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  optionsClickCallBack?.call();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: Assets.images.musicItemOptions
                      .image(fit: BoxFit.fill, height: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
