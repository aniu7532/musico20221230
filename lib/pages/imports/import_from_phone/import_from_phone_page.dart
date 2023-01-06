import 'package:musico/base/base_page.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/pages/imports/import_from_phone/import_from_phone_model.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/strings.dart';
import 'package:musico/widgets/music/mini_player.dart';
import 'package:musico/widgets/zz_radio_button.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImportFromPhonePage extends BasePage {
  ImportFromPhonePage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<ImportFromPhonePage> createState() => _ImportFromPhonePageState();
}

class _ImportFromPhonePageState extends BasePageState<ImportFromPhonePage>
    with
        ListMoreSearchPageStateMixin<ImportFromPhonePage,
            ImportFromPhoneModel> {
  @override
  ImportFromPhoneModel initModel() {
    return ImportFromPhoneModel(requestParam: widget.requestParams);
  }

  @override
  List<Widget> getActions() {
    return [
      Visibility(
        visible: ObjectUtil.isNotEmpty(model.list),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            model.selectAll();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                model.isSelectedAll ? 'Select none' : 'Select All',
                style: FSUtils.weight500_16_46B012,
              ),
            ),
          ),
        ),
      )
    ];
  }

  @override
  Widget getItemWidget(item, index) {
    final SongModelWithOtherInfo bean = item;

    if (ObjectUtil.isEmpty(bean)) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        bean.isSelect = !bean.isSelect;
        model.notifyListeners();
      },
      child: Container(
        height: 66.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            ZzRadioButton(
              value: bean.isSelect,
              onChanged: (v) {
                bean.isSelect = v;
                model.notifyListeners();
              },
            ),
            SizedBox(
              width: 20.w,
            ),
            Assets.images.imports.iconMusicFile
                .image(fit: BoxFit.fill, height: 32.h),
            SizedBox(
              width: 12.w,
            ),
            Expanded(
              child: Text(
                '${bean.songModel.title}.mp3'.noWideSpace,
                style: FSUtils.normal_13_FFFFFF,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget buildFooter() {
    return Column(
      children: [
        Visibility(
          visible: ObjectUtil.isNotEmpty(model.list),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              model.upload(context);
            },
            child: Container(
              height: 50.h,
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 43.w, right: 43.w, bottom: 50.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: model.list.any((element) => element.isSelect)
                    ? const LinearGradient(
                        colors: [
                          Color(0xff46B112),
                          Color(0xffD0F91B),
                        ],
                      )
                    : const LinearGradient(
                        colors: [
                          Color(0xff2F2F2F),
                          Color(0xff2F2F2F),
                        ],
                      ),
              ),
              child: const Text(
                'Upload',
                style: FSUtils.weight500_18_ffffff,
              ),
            ),
          ),
        ),
        const MiniPlayer()
      ],
    );
  }

  ///无数据的情况
  @override
  Widget buildEmptyWidget() {
    return Center(
      child: Column(
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
            'empty',
            style: FSUtils.normal_14_5E5E5E,
          ),
          SizedBox(
            height: 27.h,
          ),
        ],
      ),
    );
  }
}
