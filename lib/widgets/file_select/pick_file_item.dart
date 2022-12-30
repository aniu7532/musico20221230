import 'dart:math';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musico/app/zz_icon.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/size_utils.dart';
import 'package:musico/widgets/file_select/file_state.dart';
import 'package:musico/widgets/file_select/load_image_widget.dart';
import 'package:musico/widgets/file_select/video_preview_page.dart';
import 'package:musico/widgets/fixed_scale_text_widget.dart';

///文件选择选择Item
class FilePickItemWidget extends StatelessWidget {
  const FilePickItemWidget({
    Key? key,
    required this.path,
    this.text = '',
    this.index = 0,
    this.canAdd = true,
    this.canDelete = true,
    this.canPreview = true,
    this.canMulti = true,
    this.canCover = false,
    this.hasCover = false,
    this.showMainTag = false,
    this.onAdd,
    this.onAddCover,
    this.onDelete,
    this.onPreview,
    this.onPreviewVideo,
    this.addText = '添加图片',
    this.icon = ZzIcons.icon_tianjia1,
    this.state = FileState.none,
  }) : super(key: key);

  final String path; //图片地址(本地,网络)
  final String text; //提示语
  final int index; //索引
  final bool canAdd; //是否可编辑
  final bool canDelete; //是否可删除
  final bool canPreview; //是否可预览
  final bool canMulti; //是否使用多选
  final bool canCover; //是否使用封面
  final bool hasCover; //是否已有封面
  final bool showMainTag; //是否显示是主图
  final Function? onAdd;
  final Function? onAddCover;
  final Function? onDelete;
  final Function(int)? onPreview;
  final Function(String)? onPreviewVideo;
  final String addText;
  final IconData icon;
  final FileState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, right: 5),
      child: Stack(
        children: <Widget>[
          //文件选择或者于预览
          SizedBox(
            width: double.maxFinite,
            child: canAdd ? _buildAddWidget() : _buildPreviewWidget(),
          ),
          //删除按钮
          _buildDeleteWidget(),
          //上传封面
          _buildCoverWidget(),
          //主图
          _buildMainWidget(),
          //加载
          if (state == FileState.loading && ObjectUtil.isEmpty(path))
            const Center(
              child: CupertinoActivityIndicator(
                color: ColorName.themeColor,
              ),
            )
          else
            const SizedBox.shrink()
        ],
      ),
    );
  }

  ///删除按钮
  Widget _buildDeleteWidget() {
    if (!canDelete) {
      return const SizedBox.shrink();
    }
    return Positioned(
      top: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          if (onDelete != null) {
            onDelete!();
          }
        },
        child: Container(
          width: sizeUtil.h20,
          height: sizeUtil.h20,
          child: Stack(
            children: [
              CustomPaint(
                painter: _MyPainter(),
                child: SizedBox(
                  width: sizeUtil.h20,
                  height: sizeUtil.h20,
                ),
              ),
              Positioned(
                right: sizeUtil.h4,
                top: sizeUtil.h4,
                child: const Icon(
                  ZzIcons.icon_bianzu,
                  color: Color(0xFFCCCCCC),
                  size: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///新增按钮
  Widget _buildAddWidget() {
    return FixedScaleTextWidget(
      child: InkWell(
        onTap: () {
          if (onAdd != null) {
            onAdd!();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: ColorName.bgColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            // Color(0xFF999999)
            child: Container(
              decoration: BoxDecoration(
                color: ColorName.bgColor,
                borderRadius: BorderRadius.circular(5),
              ),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                //添加
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      icon,
                      size: 18,
                      color: const Color(0xFFCCCCCC),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      addText,
                      style: FSUtils.font_normal_14_colorFF999999,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///显示主图
  Widget _buildMainWidget() {
    if (!showMainTag || index > 0) {
      return const SizedBox.shrink();
    }
    if (ObjectUtil.isEmpty(path)) {
      return const SizedBox.shrink();
    }
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: double.infinity,
        height: sizeUtil.h20,
        color: const Color(0xff000000).withOpacity(0.5),
        alignment: Alignment.center,
        child: const Text(
          '主图',
          style: FSUtils.font_normal_12_colorFFFFFFFF,
        ),
      ),
    );
  }

  ///上传封面
  Widget _buildCoverWidget() {
    if (!canCover || ObjectUtil.isEmpty(path)) {
      return const SizedBox.shrink();
    }
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          if (onAddCover != null) {
            onAddCover!();
          }
        },
        child: Container(
          width: double.infinity,
          height: sizeUtil.h20,
          color: const Color(0xff000000).withOpacity(0.5),
          alignment: Alignment.center,
          child: Text(
            hasCover ? '修改封面' : '上传封面',
            style: hasCover
                ? FSUtils.font_normal_12_colorFF2B83FA
                : FSUtils.font_normal_12_colorFFFFFFFF,
          ),
        ),
      ),
    );
  }

  ///预览
  Widget _buildPreviewWidget() {
    var isVideo = false;
    if (path.contains('mp4')) {
      if (path.contains('?')) {
        final split = path.split('?');
        if (ObjectUtil.isNotEmpty(split) && split.first.endsWith('mp4')) {
          isVideo = true;
        }
      } else {
        if (ObjectUtil.isNotEmpty(path) && path.endsWith('mp4')) {
          isVideo = true;
        }
      }
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (canPreview && onPreview != null) {
          onPreview!(index);
        }
        if (canPreview && onPreviewVideo != null && path.endsWith('mp4')) {
          onPreviewVideo!(path);
        }
      },
      child: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: isVideo
            ? IgnorePointer(
                child: LoadVideo(
                  url: path,
                  showPlayIcon: false,
                ),
              )
            : LoadImage(
                path,
                height: 50,
              ),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF000000).withOpacity(0.5)
      ..style = PaintingStyle.fill;
    final arcRect = Rect.fromCircle(
        center: size.topRight(Offset.zero), radius: size.shortestSide);
    canvas.drawArc(arcRect, getRadians(0.25), getRadians(0.25), true, paint);
  }

  double getRadians(double value) {
    return (360 * value) * pi / 180;
  }

  @override
  bool shouldRepaint(_MyPainter oldDelegate) => false;
}
