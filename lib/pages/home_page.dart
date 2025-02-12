// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quick_social/common/common.dart';
import 'package:quick_social/models/models.dart';
import 'package:quick_social/pages/main_page.dart';
import 'package:quick_social/pages/pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;
  late PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageView = _buildPageView();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: context.responsive(
        sm: pageView,
        md: Row(
          children: [
            _navigationRail(context),
            const VerticalDivider(width: 1, thickness: 1),
            Flexible(child: pageView),
          ],
        ),
      ),
      bottomNavigationBar: context.isMobile ? _navigationBar(context) : null,
    );
  }

  void _pageChanged(int value) {
    if (_pageIndex == value && _pageController.hasClients) return;
    setState(() => _pageIndex = value);
    _pageController.jumpToPage(value);
  }

  Widget _buildPageView() {
    _pageController = PageController(initialPage: _pageIndex);

    return PageView(
      controller: _pageController,
      onPageChanged: _pageChanged,
      children: [
        const MainPage(),
        const FeedPage(),
        ProfilePage(user: User.dummyUsers[0]),
      ],
    );
  }

  /// tablet & desktop screen
  NavigationRail _navigationRail(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return NavigationRail(
      selectedIndex: _pageIndex,
      onDestinationSelected: _pageChanged,
      extended: context.isDesktop,
      labelType: context.isDesktop
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      selectedLabelTextStyle: textTheme.bodyMedium?.copyWith(
        color: const Color(0xff020053),
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelTextStyle: textTheme.bodyMedium,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(
            Icons.home,
            color: Color(0xff020053),
          ),
          indicatorColor: Color(0xff020053),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.explore),
          selectedIcon: Icon(
            Icons.explore,
            color: Color(0xff020053),
          ),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outlined),
          selectedIcon: Icon(
            Icons.person,
            color: Color(0xff020053),
          ),
          label: Text('Profile'),
        ),
      ],
    );
  }

  NavigationBar _navigationBar(BuildContext context) {
    return NavigationBar(
      backgroundColor: const Color(0xff020053).withOpacity(0.1),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: _pageIndex,
      height: MediaQuery.of(context).size.height * 0.065,
      onDestinationSelected: _pageChanged,
      indicatorColor: const Color(0xff020053),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.explore),
          selectedIcon: Icon(
            Icons.explore,
            color: Colors.white,
          ),
          label: 'Add',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outlined),
          selectedIcon: Icon(
            Icons.person,
            color: Colors.white,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
