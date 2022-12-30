import 'package:musico/widgets/file_select/image_preview_page.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:musico/const/app_common.dart';
import 'package:musico/http/api_provider.dart';
import 'package:musico/http/app_exception.dart';
import 'package:musico/utils/image_utils.dart';

///歌曲图片
class MusicImageWidget extends StatelessWidget {
  const MusicImageWidget({
    Key? key,
    required this.imgUrl,
    this.urls,
    this.quantity,
    this.width = 60,
    this.height = 60,
    this.radius = 4,
    this.goodsId,
    this.useFullPath = false,
    this.borderColor,
  }) : super(key: key);

  ///图片Url
  final String imgUrl;
  final List<String>? urls;
  final num? quantity;
  final double width;
  final double height;
  final double radius;
  final num? goodsId;
  final bool useFullPath;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ImageWrapper(
      imageUrl: imgUrl,
      goodsId: goodsId,
      useFullPath: useFullPath,
      urls: urls,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: borderColor != null
              ? Border.all(
                  color: borderColor!,
                )
              : const Border(),
        ),
        clipBehavior: Clip.hardEdge,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: ImageUtils.loadImage(
            imgUrl,
            width: width,
            height: height,
            fit: BoxFit.fill,
            useFullPath: useFullPath,
          ),
        ),
      ),
    );
  }
}

class ImageWrapper extends StatelessWidget {
  const ImageWrapper({
    Key? key,
    required this.child,
    required this.imageUrl,
    this.urls,
    this.goodsId,
    this.useFullPath = false,
  }) : super(key: key);

  final String imageUrl;
  final List<String>? urls;
  final Widget child;
  final num? goodsId;
  final bool useFullPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (ObjectUtil.isEmpty(imageUrl)) return;
        final list = await getImages();
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return ImagePreViewPage(
              galleryItems: list,
            );
          },
        );
      },
      child: child,
    );
  }

  Future<List<String>> getImages() async {
    if (goodsId != null && goodsId! > 0) {
      var request = {'gid': goodsId};
      var apiResponse = await ApiModel().post(
        '',
        request,
      );
      final result = apiResponse.when(
        success: (data) => data,
        error: (error) {
          return error;
        },
      );
      if (result is AppException || ObjectUtil.isEmpty(result.data)) {
        return [imageUrl];
      }
      final list = result.data;
      return list.map<String>((e) => e['url']).toList();
    }
    final imgUrls = <String>[];
    if (urls != null) {
      for (final url in urls!) {
        if (useFullPath) {
          imgUrls.add(url);
        } else {
          imgUrls.add('${appCommon.baseOssUrl}$url');
        }
      }
    } else {
      if (useFullPath) {
        imgUrls.add(imageUrl);
      } else {
        imgUrls.add('${appCommon.baseOssUrl}$imageUrl');
      }
    }
    return imgUrls;
  }
}
