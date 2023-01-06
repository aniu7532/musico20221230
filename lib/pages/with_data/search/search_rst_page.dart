import 'package:musico/app/myapp.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/base_page_mixin.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/pages/with_data/search/search_rst_model.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/widgets/common/cus_tabbar.dart';
import 'package:musico/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///SearchRst
class TabSearchRstPage extends BasePage {
  TabSearchRstPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<TabSearchRstPage> createState() => _TabSearchRstPageState();
}

class _TabSearchRstPageState extends BasePageState<TabSearchRstPage>
    with BasePageMixin<TabSearchRstPage, SearchRstModel> {
  @override
  SearchRstModel initModel() {
    return SearchRstModel(requestParam: widget.requestParams);
  }

  @override
  Widget build(BuildContext context) {
    AppData.rootContext = context;
    return super.build(context);
  }

  @override
  Widget buildContentWidget() {
    return DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
                isScrollable: true,
                indicator: TabSizeIndicator(
                  wantWidth: 15,
                  borderSide:
                      BorderSide(width: 2, color: ColorName.secondaryColor),
                ),
                tabs: [
                  Tab(
                    text: 'Tracks',
                  ),
                  Tab(icon: Icon(Icons.directions_transit)),
                  Tab(icon: Icon(Icons.directions_bike)),
                ]),
            Expanded(
              child: TabBarView(
                children: [
                  buildTrackList(),
                  Center(child: Text("Transit")),
                  Center(child: Text("Bike"))
                ],
              ),
            )
          ],
        ));
  }

  Widget buildTrackList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Container();
      },
    );
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
}
