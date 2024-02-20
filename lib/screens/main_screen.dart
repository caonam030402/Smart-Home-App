import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/screens/home_screen.dart';
import 'package:smart_home/widgets/bottom_navigation_item.dart';
import 'package:smart_home/constants/path_icons.dart';
import 'package:smart_home/styles/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum Menus { home, message, search }

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
    const Center(child: Text('Add')),
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
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
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
    print(result.recognizedWords);
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Stack(
        children: [
          Positioned(
              right: 0,
              left: 0,
              top: 30,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    color: Colors.white.withOpacity(0.4)),
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        // If listening is active show the recognized words
                        _speechToText.isListening
                            ? '$_lastWords'
                            // If listening isn't active but could be tell the user
                            // how to start it, otherwise indicate that speech
                            // recognition is not yet ready or not supported on
                            // the target device
                            : _speechEnabled
                                ? 'Tap the microphone to start listening...'
                                : 'Speech not available',
                      ),
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
                ),
              )),
          Positioned(
              top: 13,
              right: 0,
              left: 0,
              child: GestureDetector(
                onTap: _speechToText.isNotListening
                    ? _startListening
                    : _stopListening,
                child: AvatarGlow(
                  animate: _speechEnabled,
                  duration: Duration(milliseconds: 1000),
                  glowColor: AppColors.primary,
                  repeat: true,
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
              ))
        ],
      ),
    );
  }
}
