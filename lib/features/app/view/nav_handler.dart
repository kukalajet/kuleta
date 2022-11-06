import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavHandler extends ChangeNotifier {
  NavHandler(GoRouter router) : _rootRouter = router;

  final GoRouter _rootRouter;
  int _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  set currentTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  final TabInfo _listingsTabInfo = TabInfo(
    id: 'listings',
    router: GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const Scaffold(
              body: Text('Listing Page'),
            ),
          ),
        ),
      ],
    ),
  );

  final TabInfo _overviewTabInfo = TabInfo(
    id: 'overview',
    router: GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const Scaffold(
              body: Text('Overview Page'),
            ),
          ),
        ),
      ],
    ),
  );

  final TabInfo _settingsTabInfo = TabInfo(
    id: 'settings',
    router: GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const Scaffold(
              body: Text('Settings Page'),
            ),
          ),
        ),
      ],
    ),
  );

  late final List<TabInfo> _tabInfos = [
    _listingsTabInfo,
    _overviewTabInfo,
    _settingsTabInfo,
  ];

  /// Navigate to root [location] and change the bottom nav index accordingly
  void goToRoot(String location, {Object? extra}) {
    if (!location.startsWith('/')) {
      throw Exception("Root location doesn't start with slash: $location");
    }
    if (!location.endsWith('/')) {
      // ignore: parameter_assignments
      location = '$location/';
    }

    for (final tabInfo in _tabInfos) {
      final id = tabInfo.id;
      if (location.startsWith('/$id/')) {
        final newTabIndex = _tabInfos.indexOf(tabInfo);
        currentTabIndex = newTabIndex;
        _handleRootRouteWithTab(newTabIndex, location, extra: extra);
        return;
      }
    }

    _rootRouter.go(location, extra: extra);
  }

  void _handleRootRouteWithTab(
    int tabIndex,
    String location, {
    Object? extra,
  }) {
    final splitted = location.split('/');

    // Remote first path (the tab id) to do a "relative" navigation
    var effectiveLocation = splitted.sublist(2).join('/');
    if (!effectiveLocation.startsWith('/')) {
      effectiveLocation = '/$effectiveLocation';
    }

    final currentRouter = _tabInfos[tabIndex].router;
    // ignore: cascade_invocations
    currentRouter.go(effectiveLocation, extra: extra);
  }
}

class TabInfo {
  const TabInfo({required this.id, required this.router});

  final String id;
  final GoRouter router;
}
