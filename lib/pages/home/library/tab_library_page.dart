import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/pages/home/library/library_model.dart';
import 'package:musico/widgets/music/mini_player.dart';
import 'package:musico/widgets/music/music_item.dart';
import 'package:on_audio_query/on_audio_query.dart';

///Library
class TabLibraryPage extends BasePage {
  TabLibraryPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<TabLibraryPage> createState() => _TabLibraryPageState();
}

class _TabLibraryPageState extends BasePageState<TabLibraryPage>
    with ListMoreSearchPageStateMixin<TabLibraryPage, LibraryModel> {
  @override
  LibraryModel initModel() {
    return LibraryModel(requestParam: widget.requestParams);
  }

  @override
  Widget buildAppBar() {
    return AppBar(
      leadingWidth: 200,
      leading: Container(
        height: 20.h,
        margin: const EdgeInsets.only(left: 16),
        alignment: Alignment.centerLeft,
        child: Assets.images.appbar.appbarLibrary
            .image(fit: BoxFit.fill, height: 20.h),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            model.createPlayList(context);
          },
          child: Container(
            height: 18.h,
            padding: const EdgeInsets.only(right: 16),
            alignment: Alignment.centerLeft,
            child: Assets.images.options.optionsCreatePlaylist
                .image(fit: BoxFit.fill, height: 18.h),
          ),
        )
      ],
    );
  }

  @override
  Widget getItemWidget(item, index) {
    PlaylistModel m = item;
    return MusicItem(
      playlistModel: item,
      needOptions: m.playlist != 'favorite',
      optionsClickCallBack: () {
        model.clickItemOptions(item, context);
      },
      outClickCallBack: () {
        model.clickItem(item, context);
      },
    );
  }

  @override
  Widget buildFooter() {
    return const MiniPlayer();
  }
}
