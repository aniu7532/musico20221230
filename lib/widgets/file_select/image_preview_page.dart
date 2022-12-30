import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/widgets/file_select/load_image_widget.dart';
import 'package:musico/widgets/file_select/video_preview_page.dart';
import 'package:musico/widgets/zz_back_button.dart';
import 'package:musico/widgets/zz_scaffold.dart';

class ImagePreViewPage extends StatefulWidget {
  ImagePreViewPage({
    Key? key,
    this.initialIndex = 0,
    required this.galleryItems,
    this.backgroundDecoration,
    this.scrollDirection = Axis.horizontal,
  })  : pageController = PageController(initialPage: initialIndex),
        super(key: key);

  final Decoration? backgroundDecoration;
  final int initialIndex;
  final PageController pageController;
  final List<String> galleryItems;
  final Axis scrollDirection;

  @override
  State<ImagePreViewPage> createState() => _ImagePreViewPageState();
}

class _ImagePreViewPageState extends State<ImagePreViewPage> {
  late int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZzScaffold(
      body: Container(
        decoration: widget.backgroundDecoration ??
            const BoxDecoration(color: Colors.black),
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            (event.expectedTotalBytes ?? 1),
                  ),
                ),
              ),
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            if (widget.galleryItems.length > 1)
              Positioned(
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Center(
                              child: Text(
                                '${currentIndex + 1} / ${widget.galleryItems.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
            Positioned(
              left: 10,
              top: 10 + 40.0,
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: ColorName.themeColor.withAlpha(0),
                ),
                child: const ZzBackButton(color: Colors.white, margin: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    var url = '';
    if (widget.galleryItems.length > index) {
      url = widget.galleryItems[index];
    }
    var isVideo = false;
    if (url.contains('mp4')) {
      final split = url.split('?');
      if (ObjectUtil.isNotEmpty(split) && split.first.endsWith('mp4')) {
        isVideo = true;
      }
    }
    return PhotoViewGalleryPageOptions.customChild(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: isVideo
            ? LoadVideo(
                url: url,
              )
            : LoadImage(
                url,
                fit: BoxFit.contain,
              ),
      ),
      childSize: Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
      minScale: PhotoViewComputedScale.contained * 0.2,
      maxScale: PhotoViewComputedScale.covered * 2,
      heroAttributes: PhotoViewHeroAttributes(tag: 'tag$url'),
    );
  }
}
