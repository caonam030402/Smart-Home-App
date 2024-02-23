import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/screens/home_screen.dart';
import 'package:smart_home/widgets/bottom_navigation_item.dart';
import 'package:smart_home/constants/path_icons.dart';
import 'package:smart_home/styles/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum Menus {
  home,
  message,
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Menus currentIndex = Menus.home;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[currentIndex.index],
      bottomNavigationBar: MyBottomNavigation(
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          }),
    );
  }

  final pages = <Widget>[
    HomeScreen(),
    const Center(child: Text('Message')),
  ];
}

class MyBottomNavigation extends StatefulWidget {
  final Menus currentIndex;
  final ValueChanged<Menus> onTap;
  const MyBottomNavigation(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  State<MyBottomNavigation> createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  DatabaseReference ref = FirebaseDatabase.instance.ref("");
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  bool _isIgnor = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {
      _speechEnabled = false;
    });
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _speechEnabled = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _speechEnabled = false;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    ref.update({
      "voice_control": {"command": result.recognizedWords, "enforcement": true}
    });
    setState(() {
      _lastWords = result.recognizedWords;
    });
    Future.delayed(
      Duration(milliseconds: 3000),
      () {
        setState(() {
          _speechEnabled = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_lastWords);
    return Container(
      height: 100,
      child: Stack(
        children: [
          Positioned(
              top: 30,
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    color: Colors.white.withOpacity(1)),
                height: 50,
              )),
          Positioned(
              top: 10,
              right: 0,
              left: 0,
              child: AvatarGlow(
                glowShape: BoxShape.circle,
                animate: _speechEnabled,
                duration: Duration(milliseconds: 1000),
                glowColor: AppColors.primary,
                repeat: true,
                child: GestureDetector(
                  onTap: _speechToText.isNotListening
                      ? _startListening
                      : _stopListening,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                        color: AppColors.primary, shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      PathIcons.ic_voice,
                      color: AppColors.white,
                    ),
                  ),
                ),
              )),
          Positioned(
              right: 0,
              left: 0,
              top: 30,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Text(
                    //   _speechToText.isListening
                    //       ? '$_lastWords'
                    //       : _speechEnabled
                    //           ? 'Tap the microphone to start listening...'
                    //           : 'Speech not available',
                    // ),
                    BottomNavigationItem(
                        onPressed: () => widget.onTap(Menus.home),
                        index: widget.currentIndex,
                        name: Menus.home,
                        iconActive: PathIcons.ic_home_fill,
                        icon: PathIcons.ic_home_stroke),
                    const Spacer(),
                    BottomNavigationItem(
                        onPressed: () => widget.onTap(Menus.message),
                        index: widget.currentIndex,
                        name: Menus.message,
                        iconActive: PathIcons.ic_user_fill,
                        icon: PathIcons.ic_user_stroke),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
