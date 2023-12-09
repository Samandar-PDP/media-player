import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late AudioPlayer _audioPlayer;
  Duration maxDuration = const Duration(seconds: 0);
  late ValueListenable<Duration> progress;
  int _index = 0;
  final _musicList = [
    'dvrs',
    'interworld',
    'braz'
  ];

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  getDuration() {
    _audioPlayer.getDuration().then((value) {
      maxDuration = value ?? const Duration(seconds: 0);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    getDuration();
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('assets/anim/anim_1.json',height: 250,width: 250, animate: _audioPlayer.state == PlayerState.playing),
              const SizedBox(height: 150),
              StreamBuilder(
                  stream: _audioPlayer.onPositionChanged,
                  builder: (context, snapshot) {
                    return ProgressBar(
                      thumbColor: Colors.white,
                      thumbGlowColor: Colors.white,
                      progress: snapshot.data ?? const Duration(seconds: 0),
                      total: maxDuration,
                      onSeek: (duration) {
                        _audioPlayer.seek(duration);
                        setState(() {});
                      },
                    );
                  }),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () {
                    if(_index > 0) {
                      setState(() {
                        _index--;
                      });
                    }
                    _playOrStop();
                  }, icon: const Icon(CupertinoIcons.backward_end_alt),color: Colors.white,),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white,width: 2)
                    ),
                    child: IconButton(onPressed: _playOrStop, icon: Icon(_audioPlayer.state == PlayerState.playing ? CupertinoIcons.pause : CupertinoIcons.play,color: Colors.white)),
                  ),
                  IconButton(onPressed: () {
                    if(_index < _musicList.length) {
                      setState(() {
                        _index++;
                      });
                    _playOrStop();
                    }
                  }, icon: const Icon(CupertinoIcons.forward_end_alt),color: Colors.white,),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }



  void _playOrStop() async {
    print(_index);
    if(_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource('audio/${_musicList[_index]}.mp3'));
    }
    setState(() {});
  }
}
