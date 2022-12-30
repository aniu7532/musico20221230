import 'package:musico/app/myapp.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/pages/home/track/track_model.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/widgets/music/mini_player.dart';
import 'package:musico/widgets/music/music_item.dart';
import 'package:musico/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Track
class TabTrackPage extends BasePage {
  TabTrackPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<TabTrackPage> createState() => _TabTrackPageState();
}

class _TabTrackPageState extends BasePageState<TabTrackPage>
    with ListMoreSearchPageStateMixin<TabTrackPage, TrackModel> {
  @override
  TrackModel initModel() {
    return TrackModel(requestParam: widget.requestParams);
  }

  @override
  Widget build(BuildContext context) {
    AppData.rootContext = context;
    return super.build(context);
  }

  @override
  Widget buildAppBar() {
    return AppBar(
      leadingWidth: 200,
      leading: Container(
        height: 18.h,
        margin: const EdgeInsets.only(left: 16),
        alignment: Alignment.centerLeft,
        child: Assets.images.appbar.appbarTrack
            .image(fit: BoxFit.fill, height: 18.h),
      ),
    );
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
        model.clickItemOptions(item, index, context);
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
          const Text(
            'There are currently no tracks ',
            style: FSUtils.normal_14_5E5E5E,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'here,Open',
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
          const Text(
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
                appRouter.push(ImportFromPhoneRoute(
                  requestParams: const {'title': 'Import'},
                ));
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
