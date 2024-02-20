import 'package:flutter/material.dart';
import 'package:smart_home/screens/home_screen.dart';
import 'package:smart_home/widgets/bottom_navigation_item.dart';
import 'package:smart_home/constants/path_icons.dart';
import 'package:smart_home/styles/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class MyBottomNavigation extends StatelessWidget {
  final Menus currentIndex;
  final ValueChanged<Menus> onTap;
  const MyBottomNavigation(
      {super.key, required this.currentIndex, required this.onTap});

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
                      BottomNavigationItem(
                          onPressed: () => onTap(Menus.home),
                          index: currentIndex,
                          name: Menus.home,
                          iconActive: PathIcons.ic_home_fill,
                          icon: PathIcons.ic_home_stroke),
                      const Spacer(),
                      BottomNavigationItem(
                          onPressed: () => onTap(Menus.message),
                          index: currentIndex,
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
                onTap: () => onTap(Menus.search),
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
              ))
        ],
      ),
    );
  }
}
