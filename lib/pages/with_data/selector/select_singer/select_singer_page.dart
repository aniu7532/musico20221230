import 'package:musico/base/base_page.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/pages/with_data/selector/select_singer/select_singer_model.dart';
import 'package:flutter/material.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/image_utils.dart';
import 'package:musico/widgets/music/music_item.dart';

///SelectSinger
class SelectSingerPage extends BasePage {
  SelectSingerPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<SelectSingerPage> createState() => _SelectSingerPageState();
}

class _SelectSingerPageState extends BasePageState<SelectSingerPage>
    with ListMoreSearchPageStateMixin<SelectSingerPage, SelectSingerModel> {
  @override
  SelectSingerModel initModel() {
    return SelectSingerModel(requestParam: widget.requestParams);
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }

  @override
  Widget getItemWidget(item, index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: [
            ImageUtils.loadImageWithRadius(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSb2GfJ31vpitjNhewH1PtgtXW4p9C-05bEmHBSixeZnA&s',
              r: 180,
              height: 60,
              width: 60,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'x',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FSUtils.normal_15_FFFFFF,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'xxxx',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FSUtils.normal_14_969898,
                  )
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: Assets.images.play.starBoder
                    .image(fit: BoxFit.fill, height: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
