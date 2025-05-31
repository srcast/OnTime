import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/views/configurations/define_hour_value_config_page.dart';

import '../layout/layout_scaffold.dart';
import '../../views/analysis_page.dart';
import '../../views/configurations_page.dart';
import '../../views/home_page.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.homePage,
    routes: [
      StatefulShellRoute.indexedStack(
        builder:
            (context, state, navigationShell) =>
                LayoutScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.homePage,
                builder: (context, state) => HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.analysisPage,
                builder: (context, state) => AnalysisPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.configurationsPage,
                builder: (context, state) => ConfigurationsPage(),
              ),
              GoRoute(
                path: Routes.configDegineHourValuePage,
                builder: (context, state) => DefineValorHoraPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
