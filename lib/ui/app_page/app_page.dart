import 'package:flutter/material.dart';

import '../calendar_page/calendar_page.dart';
import '../consts.dart';
import '../home_page/home_page.dart';
import '../notification_page/notification_page.dart';
import '../settings_page/settings_page.dart';
import '../subjects_page/subjects_page.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final PageController _controller = PageController(initialPage: 2);

  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: _pages,
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        scrollBehavior: const ScrollBehavior(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        iconSize: 30,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: kAccentColor,
        unselectedItemColor: kTextColor,
        type: BottomNavigationBarType.fixed,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFFF0F0F0),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_controller.hasClients) {
      // _controller.animateToPage(
      //   index,
      //   duration: const Duration(milliseconds: 400),
      //   curve: Curves.easeInOut,
      // );
      _controller.jumpToPage(index);
    }
  }

  final List<Widget> _pages = [
    const NotificationPage(),
    const CalendarPage(),
    const HomePage(),
    const SubjectsPage(),
    const SettingsPage(),
  ];
}
