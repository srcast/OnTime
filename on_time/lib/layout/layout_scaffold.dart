import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/analysis_page_vm.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:provider/provider.dart';

import '../../models/tabs/destinations.dart';

class LayoutScaffold extends StatefulWidget {
  const LayoutScaffold({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  State<LayoutScaffold> createState() => _LayoutScaffoldState();
}

class _LayoutScaffoldState extends State<LayoutScaffold> {
  //int _currentIndex = 0;

  late final Map<int, VoidCallback> _onTabReselected = {
    0: () => context.read<HomePageVM>().verifyDate(),
    1: () => context.read<AnalysisPageVM>().getData(),
    //2: () => context.read<ConfigurationsPageVM>().cleanSubPagesStack(),
  };

  @override
  void initState() {
    super.initState();
    //_currentIndex = widget.navigationShell.currentIndex;
  }

  void goToHomePage(DateTime selectedDay) {
    final index = destinations.indexWhere((d) => d.label == Labels.homeTab);
    context.read<HomePageVM>().refreshDay(selectedDay);
    //setState(() => _currentIndex = index);
    widget.navigationShell.goBranch(index);
  }

  void _onDestinationSelected(int index) {
    if (index == widget.navigationShell.currentIndex) {
      if (index == 2 && Navigator.canPop(context)) {
        // configurations tab
        context.pop();
      }
    } else {
      if (widget.navigationShell.currentIndex == 0) {
        // is leaving home page
        // set timer false
        context.read<HomePageVM>().timerRunning(false);
      }
      _onTabReselected[index]?.call();
      //setState(() => _currentIndex = index);
      widget.navigationShell.goBranch(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.scaffoldBackground,
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          backgroundColor: context.colors.tabBarBackground,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                color: context.colors.focusColor,
                fontWeight: FontWeight.w600,
              );
            }
            return TextStyle(color: context.colors.titleText);
          }),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: context.colors.focusColor);
            }
            return IconThemeData(color: context.colors.titleText);
          }),
        ),
        child: NavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations:
              destinations
                  .map(
                    (destination) => NavigationDestination(
                      icon: Icon(destination.icon),
                      label: destination.label.tr(),
                      selectedIcon: Icon(
                        destination.icon,
                        color: context.colors.focusColor,
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
