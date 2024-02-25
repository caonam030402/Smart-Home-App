import 'package:flutter/material.dart';
import 'package:smart_home/components/list_devices.dart';
import 'package:smart_home/styles/app_colors.dart';

class TabBarHome extends StatefulWidget {
  const TabBarHome({Key? key}) : super(key: key);

  @override
  State<TabBarHome> createState() => _TabBarState();
}

class _TabBarState extends State<TabBarHome> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      const Tab(
        text: 'All Device',
      ),
      const Tab(
        text: 'Living Room',
      ),
      const Tab(
        text: 'Bedroom',
      ),
      const Tab(
        text: 'Bedroom',
      ),
      const Tab(
        text: 'Bedroom',
      ),
    ];

    return Column(
      children: [
        TabBar(
          labelColor: AppColors.primary,
          indicatorColor: AppColors.primary,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          controller: _tabController,
          tabs: tabs,
        ),
        Expanded(
          // Wrap TabBarView with Expanded
          child: TabBarView(
            controller: _tabController,
            children: [
              ListDevices(),
              ListDevices(),
              ListDevices(),
              ListDevices(),
              ListDevices()
            ],
          ),
        ),
      ],
    );
  }
}
