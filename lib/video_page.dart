import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _playerController;

  @override
  void initState() {
    _playerController = VideoPlayerController.asset('assets/video/video1.mp4')..initialize().then((value) {
      setState(() {

      });
    });
    // _playerController = VideoPlayerController.networkUrl(
    //   Uri.parse('https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4')
    // )..initialize().then((value) {
    //   setState(() {
    //
    //   });
    // });
    _playerController.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _playerController.value.isInitialized ?
      Center(child: SizedBox(height: 340,child: VideoPlayer(_playerController),)) : const Center(child: CircularProgressIndicator(),)
    );
  }
}
