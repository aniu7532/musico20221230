import 'package:carousel_slider/carousel_slider.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/pages/with_data/index/index_model.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/divider_urils.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/image_utils.dart';
import 'package:musico/utils/size_utils.dart';
import 'package:musico/widgets/music/asset_button.dart';
import 'package:musico/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musico/widgets/zz_app_bar.dart';

///Index
class TabIndexPage extends BasePage {
  TabIndexPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<TabIndexPage> createState() => _TabIndexPageState();
}

class _TabIndexPageState extends BasePageState<TabIndexPage>
    with ListMoreSearchPageStateMixin<TabIndexPage, IndexModel> {
  @override
  IndexModel initModel() {
    return IndexModel(requestParam: widget.requestParams);
  }

  @override
  Widget build(BuildContext context) {
    AppData.rootContext = context;
    return super.build(context);
  }

  @override
  Widget buildAppBarWithSearch() {
    return ZzAppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0.0,
      title: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {},
              radius: 20,
              borderRadius: BorderRadius.circular(20),
              focusColor: ColorName.secondaryColor,
              highlightColor: ColorName.secondaryColor,
              splashColor: ColorName.secondaryColor,
              hoverColor: ColorName.secondaryColor,
              child: Container(
                height: sizeUtil.h36,
                decoration: BoxDecoration(
                  color: const Color(0xff343434),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: AssetButton(
                        asset: Assets.images.index.searchGray,
                        height: 19,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: AssetButton(
              asset: Assets.images.index.indexCrown,
              height: 30,
            ),
          ),
        ],
      ),
      actions: <Widget>[],
    );
  }

  Widget _banner() {
    return SizedBox.shrink();
  }

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

  @override
  Widget getItemWidget(item, index) {
    switch (index) {
      case 0:
        return CarouselSlider.builder(
            itemCount: 4,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) =>
                    ImageUtils.loadImageWithRadius(
                      'https://linkstorage.linkfire.com/medialinks/images/0625f973-e5ce-41c1-b0da-450c7d895818/artwork-600x315.jpg',
                      width: double.infinity,
                      r: 6,
                    ),
            options: CarouselOptions(
              scrollPhysics: const BouncingScrollPhysics(),
              height: 168,
              initialPage: 0,
              aspectRatio: 16 / 9,
              enlargeFactor: 0.2, //旁边离中间的距离
              viewportFraction: 0.9, //中间这张占的比例
              enableInfiniteScroll: false, //能否循环
              reverse: false, //是否倒转
              autoPlay: true, //自动循环
              autoPlayInterval: const Duration(seconds: 8), //加载下一个间隔时间
              autoPlayAnimationDuration: const Duration(seconds: 800),
              enlargeCenterPage: true, //是否向中间突出
            ));
      case 1:
        return Container(
          padding: const EdgeInsets.only(top: 18),
          child: Column(
            children: [
              Row(
                children: const [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Trending',
                    style: FSUtils.weight500_18_ffffff,
                  ),
                  Spacer(),
                  Text(
                    'See All',
                    style: FSUtils.normal_14_CEF91C,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              CarouselSlider.builder(
                  itemCount: 5,
                  itemBuilder: (
                    BuildContext context,
                    int itemIndex,
                    int pageViewIndex,
                  ) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            children: [
                              ImageUtils.loadImageWithRadius(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZajEKVc_FJO8ZwACgPbdEvBHhej1083CHti4vuNGLMA&s',
                                width: 58,
                                height: 58,
                                r: 6,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Some name Some name ',
                                      style: FSUtils.normal_16_FFFFFF,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Artist Name',
                                      style: FSUtils.normal_12_969898,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  options: CarouselOptions(
                    height: 250,
                    initialPage: 0,
                    aspectRatio: 16 / 9,
                    enlargeFactor: 0.1, //旁边离中间的距离
                    viewportFraction: 0.9, //中间这张占的比例
                    enableInfiniteScroll: false, //能否循环
                    pageSnapping: false, //是否象viewpager一样翻页 否则是滑动
                    reverse: false, //是否倒转
                    autoPlay: false, //自动循环
                    autoPlayInterval: const Duration(seconds: 8), //加载下一个间隔时间
                    autoPlayAnimationDuration: const Duration(seconds: 800),
                    enlargeCenterPage: true, //是否向中间突出
                  )),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: divider0xFF1F1F1F,
              ),
            ],
          ),
        );
      case 2:
        return Container(
          padding: const EdgeInsets.only(top: 18),
          // height: 360,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Hottest Artist',
                    style: FSUtils.weight500_18_ffffff,
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        model.goToAllArtist();
                      },
                      child: Text(
                        'See All',
                        style: FSUtils.normal_14_CEF91C,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //横轴元素个数
                  crossAxisCount: 3,
                  //纵轴间距
                  mainAxisSpacing: 8,
                  //横轴间距
                  crossAxisSpacing: 0,
                  //子组件宽高长度比例
                  childAspectRatio: 12 / 16,
                ),
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      ImageUtils.loadImageWithRadius(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSb2GfJ31vpitjNhewH1PtgtXW4p9C-05bEmHBSixeZnA&s',
                        r: 180,
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        index.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FSUtils.normal_13_FFFFFF,
                      )
                    ],
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: divider0xFF1F1F1F,
              ),
            ],
          ),
        );
      case 3:
        return Container(
          padding: const EdgeInsets.only(top: 18),
          // height: 360,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Popular playlists',
                    style: FSUtils.weight500_18_ffffff,
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      model.goToAllPlaylist();
                    },
                    child: Text(
                      'See All',
                      style: FSUtils.normal_14_CEF91C,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //横轴元素个数
                  crossAxisCount: 3,
                  //纵轴间距
                  mainAxisSpacing: 8,
                  //横轴间距
                  crossAxisSpacing: 0,
                  //子组件宽高长度比例
                  childAspectRatio: 12 / 16,
                ),
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      ImageUtils.loadImageWithRadius(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXqjXxqDo4AvCGlZghEMw4DsTKrNEXPOhhTNHLsN_Hdg&s',
                        r: 8,
                        fit: BoxFit.fitHeight,
                        height: 102,
                        width: 102,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'playlist name',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FSUtils.normal_13_FFFFFF,
                      )
                    ],
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: divider0xFF1F1F1F,
              ),
            ],
          ),
        );
      case 4:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }
}
