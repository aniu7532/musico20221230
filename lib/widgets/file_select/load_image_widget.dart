import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/utils/image_utils.dart';

/// 加载图片（支持本地与网络图片）
class LoadImage extends StatelessWidget {
  const LoadImage(
    this.image, {
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.fitHeight,
    this.holderImg = const AssetGenImage('assets/images/holderImg.png'),
    this.thumbnail = false,
  }) : super(key: key);

  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AssetGenImage holderImg;
  final bool thumbnail;

  @override
  Widget build(BuildContext context) {
    if (TextUtil.isEmpty(image) || image == 'null') {
      return holderImg.image(width: width, height: height, fit: fit);
    } else {
      //网络路径
      if (image.startsWith('http')) {
        if (image.endsWith('mp4')) {
          return Assets.images.musicItemDefault
              .image(width: width, height: height, fit: fit);
        }
        return CachedNetworkImage(
          //网络图片
          imageUrl: image,
          placeholder: (context, url) =>
              holderImg.image(width: width, height: height, fit: fit),
          errorWidget: (context, url, error) =>
              holderImg.image(width: width, height: height, fit: fit),
          width: width,
          height: height,
          fit: fit,
        );
      } else {
        //本地手机文件
        if ((image.contains('/0/') ||
                image.contains('/mobile/') ||
                image.contains('zztx')) &&
            ImageUtils.isImageByPath(image)) {
          return Image.file(
            File(image),
            height: height,
            width: width,
            fit: fit,
          );
        } else {
          return Assets.images.musicItemDefault
              .image(width: width, height: height, fit: fit);
        }
      }
    }
  }
}
