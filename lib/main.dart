import 'package:flutter/material.dart';
import 'package:mdy/homepage.dart';
import 'package:camera/camera.dart';
import 'package:mdy/common.dart';
import 'package:mdy/player.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
         '/': (context) => HomePage(),
        '/player': (context) => Player(),
      },
    );
  }
}
