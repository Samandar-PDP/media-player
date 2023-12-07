import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late AudioPlayer _audioPlayer;
  double _value = 0.0;

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

  @override
  Widget build(BuildContext context) {
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
              Row(
                children: [
                  FutureBuilder(future: _audioPlayer.getCurrentPosition(), builder: (context, snapshot) {
                    return Text("${snapshot.data?.inMinutes}:${snapshot.data?.inSeconds}",style: TextStyle(
                        color: Colors.white
                    ));
                  }),
                  Expanded(
                    child: StreamBuilder(
                      stream: _audioPlayer.onPositionChanged,
                      builder: (context, snapshot) {
                        return Slider(value: (snapshot.data?.inSeconds)?.toDouble() ?? 0.0, onChanged: (v) => setState(() {
                          _audioPlayer.seek(snapshot.data ?? const Duration(microseconds: 0));
                          setState(() {

                          });
                        }),activeColor: Colors.white,thumbColor: Colors.white);
                      },
                    ),
                  ),
                  FutureBuilder(future: _audioPlayer.getDuration(), builder: (context, snapshot) {
                    return Text("${snapshot.data?.inMinutes}:${snapshot.data?.inSeconds}",style: TextStyle(
                    color: Colors.white
                    ));
                  })
                ],
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.backward_end_alt),color: Colors.white,),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white,width: 2)
                    ),
                    child: IconButton(onPressed: _playOrStop, icon: Icon(_audioPlayer.state == PlayerState.playing ? CupertinoIcons.pause : CupertinoIcons.play,color: Colors.white)),
                  ),
                  IconButton(onPressed: () {

                  }, icon: Icon(CupertinoIcons.forward_end_alt),color: Colors.white,),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }



  void _playOrStop() async {
    if(_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource('audio/interworld.mp3'));
    }
    setState(() {});
  }
}
