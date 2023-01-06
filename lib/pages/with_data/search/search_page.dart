import 'package:flutter/material.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/base_page_mixin.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/pages/with_data/search/search_model.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/widgets/music/asset_button.dart';
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

  bool get wantKeepAlive => true;

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
}
