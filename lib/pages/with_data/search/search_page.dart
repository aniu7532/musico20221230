import 'package:carousel_slider/carousel_slider.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/base_page_mixin.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/pages/with_data/index/index_model.dart';
import 'package:musico/pages/with_data/search/search_model.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/divider_urils.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/image_utils.dart';
import 'package:musico/utils/size_utils.dart';
import 'package:musico/widgets/music/asset_button.dart';
import 'package:musico/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musico/widgets/search_textfield_widget.dart';
import 'package:musico/widgets/zz_app_bar.dart';

///Search
class TabSearchPage extends BasePage {
  TabSearchPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<TabSearchPage> createState() => _TabSearchPageState();
}

class _TabSearchPageState extends BasePageState<TabSearchPage>
    with BasePageMixin<TabSearchPage, SearchModel> {
  @override
  SearchModel initModel() {
    return SearchModel(requestParam: widget.requestParams);
  }

  @override
  Widget build(BuildContext context) {
    AppData.rootContext = context;
    return super.build(context);
  }

  @override
  Widget buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ZzAppBar(
        leading: AssetButton(
          asset: Assets.images.appbar.appbarSearch,
        ),
        leadingWidth: 84.5,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: AssetButton(
              asset: Assets.images.index.indexCrown,
              height: 30,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget buildContentWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 18,
          ),
          SearchTextFieldWidget(
            hintText: 'Search for songs/Album/musician',
            onSubmitCallback: (v) {
              model.gotoSearchRst(v);
            },
          ),
          const SizedBox(
            height: 18,
          ),
          const Text(
            'Recently search',
            style: FSUtils.w500_14_D3D3D3,
          ),
          Wrap(
            children: List<Widget>.generate(
              model.historySearch?.length ?? 0,
              (int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Ink(
                    decoration: const BoxDecoration(
                        color: Color(0xFF202020),
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: InkWell(
                      splashColor: ColorName.secondaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        child: Text(
                          '${model.historySearch?[index]}',
                          style: FSUtils.normal_13_FFFFFF,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;

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
}
