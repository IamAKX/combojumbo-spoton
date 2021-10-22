import 'package:cjspoton/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key, required this.videoID}) : super(key: key);
  static const String VIDEO_PLAYER_ROUTE = '/videoPlayerScreen';
  final String videoID;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoID,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);

    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: widget.videoID,
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: primaryColor,
            topActions: <Widget>[
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  _controller.metadata.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
            onReady: () {
              _isPlayerReady = true;
            },
          ),
        ),
        // child: YoutubePlayerBuilder(
        //   onExitFullScreen: () {
        //     // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        //     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        //   },
        //   player: YoutubePlayer(
        //     controller: _controller,
        //     showVideoProgressIndicator: true,
        //     progressIndicatorColor: primaryColor,
        //     topActions: <Widget>[
        //       const SizedBox(width: 8.0),
        //       Expanded(
        //         child: Text(
        //           _controller.metadata.title,
        //           style: const TextStyle(
        //             color: Colors.white,
        //             fontSize: 18.0,
        //           ),
        //           overflow: TextOverflow.ellipsis,
        //           maxLines: 1,
        //         ),
        //       ),
        //     ],
        //     onReady: () {
        //       _isPlayerReady = true;
        //     },
        //   ),
        //   builder: (context, player) {
        //     return Column(
        //       children: [
        //         // some widgets
        //         player,
        //         //some other widgets
        //       ],
        //     );
        //   },
        // ),
      ),
    );
  }
}
