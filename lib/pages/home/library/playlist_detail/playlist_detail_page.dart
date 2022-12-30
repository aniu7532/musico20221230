import 'package:musico/base/base_page.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/pages/home/library/playlist_detail/playlist_detail_model.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/widgets/music/mini_player.dart';
import 'package:musico/widgets/music/music_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///playlist detail
class PlaylistDetailPage extends BasePage {
  PlaylistDetailPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends BasePageState<PlaylistDetailPage>
    with ListMoreSearchPageStateMixin<PlaylistDetailPage, PlaylistDetailModel> {
  @override
  PlaylistDetailModel initModel() {
    return PlaylistDetailModel(requestParam: widget.requestParams);
  }

  @override
  Widget buildHeader() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        model.playAll();
      },
      child: Container(
        height: 52.h,
        padding: EdgeInsets.only(
          left: 16.w,
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Assets.images.trackPlay.image(fit: BoxFit.fill, height: 32.h),
            SizedBox(
              width: 12.w,
            ),
            Text(
              '${model.list.length} Songs',
              style: FSUtils.normal_16_969898,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget getItemWidget(item, index) {
    return MusicItem(
      musicItemBean: item,
      outClickCallBack: () {
        model.clickItem(item, index);
      },
      optionsClickCallBack: () {
        model.clickItemOptions(item, context, index);
      },
    );
  }

  @override
  Widget buildFooter() {
    return const MiniPlayer();
  }

/*  @override
  Widget buildHeader() {
    return SafeArea(
      child: Container(
        height: 44.h,
        padding: EdgeInsets.only(left: 16.w),
        color: ColorName.themeColor,
        alignment: Alignment.centerLeft,
        child: Assets.images.appbar.appbarTrack
            .image(fit: BoxFit.fill, height: 18.h),
      ),
    );
  }*/

  /*
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        SafeArea(
          child: Container(
            height: 44.h,
            padding: EdgeInsets.only(left: 16.w),
            color: ColorName.themeColor,
            alignment: Alignment.centerLeft,
            child: Assets.images.appbar.appbarTrack
                .image(fit: BoxFit.fill, height: 18.h),
          ),
        ),
        _buildBody(),
      ],
    );
  }

  Widget _buildBody() {
    return _noData();
  }*/
  ///无数据的情况
  @override
  Widget buildEmptyWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 88.h,
          ),
          Assets.images.noData.defaultNoTrack
              .image(fit: BoxFit.fill, height: 158.h),
          SizedBox(
            height: 17.h,
          ),
          Text(
            'empty',
            style: FSUtils.normal_14_5E5E5E,
          ),
          /*     Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'There,Open',
                style: FSUtils.normal_14_5E5E5E,
              ),
              Text(
                ' Import ',
                style: FSUtils.normal_14_92DD13,
              ),
              Text(
                'and select a ',
                style: FSUtils.normal_14_5E5E5E,
              ),
            ],
          ),
          Text(
            'source to add music',
            style: FSUtils.normal_14_5E5E5E,
          ),
          SizedBox(
            height: 27.h,
          ),
          Container(
            height: 48.h,
            margin: EdgeInsets.symmetric(horizontal: 112.w),
            child: PrimaryButton.singleWithBorder(
              text: 'Import Song',
              onPressed: () {
                print('Import');
              },
            ),
          ),*/
        ],
      ),
    );
  }
}
