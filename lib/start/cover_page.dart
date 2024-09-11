import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:protek_tracker/main.dart';
import 'package:protek_tracker/shared_preferences_init.dart';
import 'package:video_player/video_player.dart';

class CoverPage extends StatefulWidget {
  const CoverPage({Key? key}) : super(key: key);

  @override
  State<CoverPage> createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> {
  late VideoPlayerController _controller;
  bool _isconnected = false;
  StreamSubscription<InternetStatus>? _internetSubscription;

  @override
  void initState() {
    super.initState();

    // Initialize the internet connection checker
    _checkInternetConnection();

    // Initialize and set up the video controller
    _controller = VideoPlayerController.asset('lib/images/protek_video.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  void _checkInternetConnection() async {
    // Check initial connection status
    _isconnected = await InternetConnection().hasInternetAccess;
    setState(() {});

    // Start listening to connection changes
    _internetSubscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      setState(() {
        _isconnected = status == InternetStatus.connected;
      });
    });
  }

  @override
  void dispose() {
    _internetSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // Video background
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          // Gradient overlay and content
          Container(
            height: 500,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 250,
                    padding: const EdgeInsets.only(top: 60),
                    child: const Image(
                      image: AssetImage('lib/images/text-logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 20,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                    ),
                    onPressed: () {
                      if (_isconnected) {
                        if (SharedPrefs().prefs.getBool('isAuth') == true) {
                          context.go('/restart');
                        } else {
                          context.go('/start');
                        }
                      } else {
                        context.go('/nointernet');
                      }
                    },
                    child: const Text(
                      'CONTINUE',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
