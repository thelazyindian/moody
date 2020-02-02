import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mdy/asset_audio_player_icons.dart';
import 'package:mdy/common.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  List songs = new List();
  List<String> assets;
  final assetsHappy = <String>["Aur Iss Dil Mein.mp3", "Ishq Na Karna.mp3"];
  final assetsSad = <String>[
    "LO MAAN LIYA.mp3",
    "Phir Bhi Tumko Chaahunga.mp3"
  ];
  String mood;
  final assetsAngry = <String>["Zaroori Tha.mp3", "Ye Dooriyan"];
  final cusTileColor = <Color>[
    Color(0xff58b3be),
    Color(0xfffcc78e),
    Color(0xffcccfd0),
    Color(0xff88d8d8)
  ];
  @override
  initState() {
    super.initState();
    if (emotion != null) {
      switch (emotion) {
        case '0':
          assets = assetsAngry;
          mood = "angry";
          break;
        case '4':
          assets = assetsSad;
          mood = "sad";
          break;
        case '3':
          assets = assetsHappy;
          mood = "happy";
          break;
        default:
          assets = ["Ghungroo.mp3", "Aas Paas Khuda.mp3"];
          break;
      }
    }
  }

  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  var _currentAssetPosition = -1;

  void _open(int assetIndex) {
    _currentAssetPosition = assetIndex % assets.length;
    _assetsAudioPlayer.open(
      AssetsAudio(
        asset: assets[_currentAssetPosition],
        folder: "assets/audios/",
      ),
    );
  }

  void _playPause() {
    _assetsAudioPlayer.playOrPause();
  }

  void _next() {
    _currentAssetPosition++;
    _open(_currentAssetPosition);
  }

  void _prev() {
    _currentAssetPosition--;
    _open(_currentAssetPosition);
  }

  @override
  void dispose() {
    _assetsAudioPlayer.stop();
    super.dispose();
  }

  String durationToString(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes =
        twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
    String twoDigitSeconds =
        twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed('/');
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: new Text(
                          'MOODY',
                          style: new TextStyle(
                              letterSpacing: 1.0,
                              fontSize: 18.0,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 50,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: StreamBuilder(
                            stream: _assetsAudioPlayer.current,
                            initialData: const PlayingAudio(),
                            builder: (BuildContext context,
                                AsyncSnapshot<PlayingAudio> snapshot) {
                              final PlayingAudio currentAudio = snapshot.data;
                              return ListView.builder(
                                itemBuilder: (context, position) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: InkWell(
                                        child: Container(
                                          height: 60,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: assets[position] ==
                                                        currentAudio
                                                            .assetAudio.asset
                                                    ? Colors.blue
                                                    : Colors.grey[400]),
                                            borderRadius:
                                                BorderRadius.horizontal(
                                              left: Radius.circular(10),
                                              right: Radius.circular(10),
                                            ),
                                            color: cusTileColor[position],
                                          ),
                                          child: Text(
                                            assets[position],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        onTap: () {
                                          _open(position);
                                        }),
                                  );
                                },
                                itemCount: assets.length,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 50,
                left: 115,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          StreamBuilder(
                            stream: _assetsAudioPlayer.currentPosition,
                            initialData: const Duration(),
                            builder: (BuildContext context,
                                AsyncSnapshot<Duration> snapshot) {
                              Duration duration = snapshot.data;
                              return Text(durationToString(duration));
                            },
                          ),
                          Text(" - "),
                          StreamBuilder(
                            stream: _assetsAudioPlayer.current,
                            builder: (BuildContext context,
                                AsyncSnapshot<PlayingAudio> snapshot) {
                              Duration duration = Duration();
                              if (snapshot.hasData) {
                                duration = snapshot.data.duration;
                              }
                              return Text(durationToString(duration));
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          IconButton(
                            onPressed: _prev,
                            icon: Icon(AssetAudioPlayerIcons.to_start),
                          ),
                          StreamBuilder(
                            stream: _assetsAudioPlayer.isPlaying,
                            initialData: false,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshot) {
                              return IconButton(
                                onPressed: _playPause,
                                icon: Icon(snapshot.data
                                    ? AssetAudioPlayerIcons.pause
                                    : AssetAudioPlayerIcons.play),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(AssetAudioPlayerIcons.to_end),
                            onPressed: _next,
                          ),
                        ],
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                          offset: Offset(
                            2.0,
                            2.0,
                          ),
                        )
                      ],
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Positioned(
                top: 60,
                right: 20,
                child: Container(
                  child: Text('Mood: $mood'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
