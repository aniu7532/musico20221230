import 'package:musico/app/myapp.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef GetText = String Function();

///左边：标题
///右边：点击选择
class NormalClickItem extends StatelessWidget {
  NormalClickItem({
    Key? key,
    required this.title,
    required this.icon,
    this.text,
    this.onTap,
  }) : super(key: key);

  final String title;

  final AssetGenImage icon;

  final String? text;

  final GestureTapCallback? onTap; //点击

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(AppData.rootContext).requestFocus();
        if (onTap != null) {
          onTap!.call();
        } else {
          MyToast.showToast(title);
          appRouter.pop();
        }
      },
      child: Container(
        height: 55.h,
        child: Row(
          children: [
            Container(
              height: 18.h,
              margin: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              child: icon.image(fit: BoxFit.fill, height: 18.h),
            ),
            SizedBox(
              width: 20.w,
            ),
            Text(
              title,
              style: FSUtils.normal_14_FFFFFF,
            )
          ],
        ),
      ),
    );
  }
}
