import 'package:musico/base/base_page.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/pages/with_data/selector/select_playlist/select_playlist_model.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/image_utils.dart';
import 'package:flutter/material.dart';

///SelectPlaylist
class DSelectPlaylistPage extends BasePage {
  DSelectPlaylistPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<DSelectPlaylistPage> createState() => _DSelectPlaylistPageState();
}

class _DSelectPlaylistPageState extends BasePageState<DSelectPlaylistPage>
    with
        ListMoreSearchPageStateMixin<DSelectPlaylistPage,
            DSelectPlaylistModel> {
  @override
  DSelectPlaylistModel initModel() {
    return DSelectPlaylistModel(requestParam: widget.requestParams);
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }

  @override
  Widget getListViewWidget() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //横轴元素个数
          crossAxisCount: 2,
          //纵轴间距
          mainAxisSpacing: 6,
          //横轴间距
          crossAxisSpacing: 10,
          //子组件宽高长度比例
          childAspectRatio: 12 / 16,
        ),
        itemCount: model.list.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 0,
              ),
              ImageUtils.loadImageWithRadius(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSb2GfJ31vpitjNhewH1PtgtXW4p9C-05bEmHBSixeZnA&s',
                r: 4,
                height: 160,
                width: 160,
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
    );
  }

  @override
  Widget getItemWidget(item, index) {
    return const SizedBox.shrink();
  }
}
