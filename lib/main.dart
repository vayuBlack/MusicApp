import 'package:flutter/material.dart';            // Provides UI components for the app.
import 'package:music_player/screens/PlayListScreen.dart';
import 'package:flutter/services.dart';           // Import the services package for setting orientation

void main() {
  // Lock the app to portrait mode on startup
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MusicApp());
  });
}

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: PlaylistScreen(),
    );
  }
}
