import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:protek_tracker/shared_preferences_init.dart';
import 'package:video_player/video_player.dart';

class CoverPage extends StatefulWidget {
  const CoverPage({Key? key}) : super(key: key);

  @override
  State<CoverPage> createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> {
  late VideoPlayerController _controller;

  // void loadInitRoute() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // This code will be executed after the current frame has finished building
  //     bool? isLocalAuth(String key) {
  //       return SharedPrefs().prefs.getBool(key);
  //     }

  //     if (mounted) {
  //       bool? isValidated = isLocalAuth('isAuth');
  //       if (isValidated == true) {
  //         context.go('/start');
  //       } else {
  //         context.go('/');
  //       }
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('lib/images/protek_video.mp4');

    // _controller.addListener(() {
    //   setState(() {});
    // });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //loadInitRoute();
  }

  // create a function that will get the preivious shared preferences (if not exited)
  String? loadData(String key) {
    return SharedPrefs().prefs.getString(key);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
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
          Container(
            height: 500,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  tileMode: TileMode.clamp),
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
                      context.go('/start');
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
