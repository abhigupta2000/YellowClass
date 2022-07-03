import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerRemote extends StatefulWidget {
  final String url;
  VideoPlayerRemote({required this.url});
  @override
  _VideoPlayerRemoteState createState() => _VideoPlayerRemoteState();
}

class _VideoPlayerRemoteState extends State<VideoPlayerRemote> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.url, //to access its parent class constructor or variable
    );

    _controller.addListener(() {
    });
    _controller.setLooping(true); //loop through video
    _controller.initialize(); //initialize the VideoPlayer
  }

  @override
  void dispose() {
    _controller.dispose(); //dispose the VideoPlayer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  VideoPlayer(_controller),
                  _PlayPauseOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({required this.controller});

  final VideoPlayerController controller;
  @override
  Widget build(BuildContext context) {
    controller.play();
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            controller.pause();
          },
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 50),
            reverseDuration: Duration(milliseconds: 200),
            child: controller.value.isPlaying
                ? SizedBox.shrink()
                : Container(
              color: Colors.black26,
              
            ),
          ),
        ),
      ],
    );
  }
}
