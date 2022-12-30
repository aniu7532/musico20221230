import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:musico/app/zz_icon.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/utils/size_utils.dart';
import 'package:musico/widgets/zz_back_button.dart';
import 'package:musico/widgets/zz_scaffold.dart';

///视频预览
class VideoPreviewPage extends StatefulWidget {
  const VideoPreviewPage({
    Key? key,
    required this.url,
    this.autoPlay = false,
  }) : super(key: key);

  final String url;
  final bool autoPlay;

  @override
  _VideoPreviewPageState createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return ZzScaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            LoadVideo(
              autoPlay: widget.autoPlay,
              url: widget.url,
            ),
            Positioned(
              left: 10,
              top: 40,
              child: Container(
                width: sizeUtil.w40,
                height: sizeUtil.w40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: ColorName.themeColor.withAlpha(50),
                ),
                child: const ZzBackButton(color: Colors.white, margin: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///视频播放
class LoadVideo extends StatefulWidget {
  const LoadVideo({
    Key? key,
    required this.url,
    this.autoPlay = false,
    this.showPlayIcon = true,
  }) : super(key: key);

  final String url;
  final bool autoPlay;
  final bool showPlayIcon;

  @override
  _LoadVideoState createState() => _LoadVideoState();
}

class _LoadVideoState extends State<LoadVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        if (widget.autoPlay) _controller.play();
      });
  }

  Widget _buildHint(hintText) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          hintText,
          style: const TextStyle(color: Color(0xFF999999), fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? _buildVideoPlayer()
          : const CupertinoActivityIndicator(),
    );
  }

  Widget _buildVideoPlayer() {
    return GestureDetector(
      onTap: () {
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
        setState(() {});
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          if (!_controller.value.isPlaying && widget.showPlayIcon)
            const Icon(
              ZzIcons.icon_shipinbofang,
              size: 100,
              color: Colors.white,
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
