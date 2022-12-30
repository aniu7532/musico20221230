import 'package:musico/gen/assets.gen.dart';
import 'package:flutter/material.dart';

///
/// music listItem
///
class AssetButton extends StatelessWidget {
  AssetButton({
    Key? key,
    required this.asset,
    this.outClickCallBack,
    this.width,
    this.height,
    this.boxHeight,
    this.boxWidth,
    this.color,
  }) : super(key: key);

  //整体点击事件
  Function()? outClickCallBack;
  //数据
  AssetGenImage asset;
  final double? width;
  final double? height;
  final double? boxHeight;
  final double? boxWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        outClickCallBack?.call();
      },
      child: SizedBox(
        width: boxWidth ?? width,
        height: boxHeight ?? height,
        child: Center(
          child: asset.image(
            fit: BoxFit.fill,
            width: width,
            height: height,
            color: color,
          ),
        ),
      ),
    );
  }
}
