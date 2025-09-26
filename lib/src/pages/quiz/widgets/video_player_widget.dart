import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({required this.url, super.key});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Expanded(
            // color: Colors.black,
            // width: 500,
            // height: 200,
            child: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, VideoPlayerValue value, child) {
                if (value.isInitialized) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: SizedBox(
            // width: 100.w,
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  child: _buildVideoControls()),
              ],
            ),
          )),
      ],
    );
  }

  Widget _buildVideoControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.replay_10,color: Colors.white,),
          onPressed: () {
            _controller.seekTo(_controller.value.position - const Duration(seconds: 10));
          },
        ),
        IconButton(
          icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow,color: Colors.white,),
          onPressed: () {
            setState(() {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.forward_10,color: Colors.white,),
          onPressed: () {
            _controller.seekTo(_controller.value.position + const Duration(seconds: 10));
          },
        ),
      ],
    );
  }
}