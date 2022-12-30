import 'package:musico/app/myapp.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/pages/home/import/import_model.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/widgets/music/mini_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Import
class TabImportPage extends BasePage {
  TabImportPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<TabImportPage> createState() => _TabImportPageState();
}

class _TabImportPageState extends BasePageState<TabImportPage>
    with ListMoreSearchPageStateMixin<TabImportPage, ImportModel> {
  @override
  ImportModel initModel() {
    return ImportModel(requestParam: widget.requestParams);
  }

  @override
  Widget buildAppBar() {
    return AppBar(
      leadingWidth: 200,
      leading: Container(
        height: 18.h,
        margin: const EdgeInsets.only(left: 16),
        alignment: Alignment.centerLeft,
        child: Assets.images.appbar.appbarImport
            .image(fit: BoxFit.fill, height: 18.h),
      ),
    );
  }

  @override
  Widget buildList() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        appRouter.push(
          ImportFromPhoneRoute(requestParams: const {'title': 'Import'}),
        );
      },
      child: Container(
        width: 280.w,
        margin: EdgeInsets.only(top: 70, left: 46, right: 46, bottom: 260.h),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 40,
            ),
            Assets.images.imports.typePhone
                .image(fit: BoxFit.fill, height: 80.h),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Phone',
              style: FSUtils.weight500_15_FFFFFF,
            ),
            const SizedBox(
              height: 6,
            ),
            const Text(
              'import music from your Phone',
              style: FSUtils.normal_14_969898,
            ),
            const SizedBox(
              height: 32,
            ),
            Assets.images.play.arrowWhiteCircle
                .image(fit: BoxFit.fill, height: 26.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget getItemWidget(item, index) {
    final ImportItemBean bean = item;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        model.click(index);
      },
      child: Container(
        height: 114.h,
        margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            bean.icon.image(fit: BoxFit.fill, height: 80.h),
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bean.title,
                    style: FSUtils.weight500_15_FFFFFF,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    bean.description,
                    style: FSUtils.normal_14_969898,
                    maxLines: 2,
                  ),
                ],
              ),
            )
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
