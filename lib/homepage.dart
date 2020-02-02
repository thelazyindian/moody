import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:mdy/camera.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        SizedBox.expand(
          child: FlareActor("assets/loading.flr",
              animation: "Alarm",),
        ),
        CameraExampleHome(),
      ],
    ));
  }
}
