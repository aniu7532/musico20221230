import 'package:musico/base/base_page.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/pages/home/setting/setting_model.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/widgets/music/mini_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Setting
class TabSettingPage extends BasePage {
  TabSettingPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<TabSettingPage> createState() => _TabSettingPageState();
}

class _TabSettingPageState extends BasePageState<TabSettingPage>
    with ListMoreSearchPageStateMixin<TabSettingPage, SettingModel> {
  @override
  SettingModel initModel() {
    return SettingModel(requestParam: widget.requestParams);
  }

  @override
  Widget buildAppBar() {
    return AppBar(
      leadingWidth: 200,
      leading: Container(
        height: 18.h,
        margin: const EdgeInsets.only(left: 16),
        alignment: Alignment.centerLeft,
        child:
            Assets.images.appbar.appbarMe.image(fit: BoxFit.fill, height: 18.h),
      ),
    );
  }

/*  @override
  Widget buildHeader() {
    return Container(
      height: 85.h,
      margin: EdgeInsets.only(top: 16.h),
      child: Stack(
        children: [
          Assets.images.setting.settingBg.image(fit: BoxFit.fill, height: 85.h),
          Positioned(
              left: 22.w,
              top: 16.h,
              child: Assets.images.setting.iconNoads
                  .image(fit: BoxFit.fill, height: 26.h)),
               Positioned(
            left: 22.w,
            bottom: 16.h,
            child: const Text(
              'Get Musico Premium',
              style: FSUtils.weight500_14_000000,
            ),
          ),
          Positioned(
              right: 22.w,
              bottom: 16.h,
              child: Assets.images.setting.iconBalckArrow
                  .image(fit: BoxFit.fill, height: 12.h)),
        ],
      ),
    );
  }*/

  @override
  Widget getItemWidget(item, index) {
    final ImportItemBean bean = item;
    return InkWell(
      onTap: () {
        model.click(index);
      },
      child: Container(
        height: 75.h,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            bean.icon.image(fit: BoxFit.fill, height: 26.h),
            const SizedBox(
              width: 18,
            ),
            Expanded(
              child: Text(
                bean.title,
                style: FSUtils.weight500_14_FFFFFF,
              ),
            ),
            Assets.images.setting.iconNormalArrowRight
                .image(fit: BoxFit.fill, height: 16.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildFooter() {
    return const MiniPlayer();
  }

  @override
  bool get wantKeepAlive => true;
}
