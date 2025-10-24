import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:on_time/helpers/ads_helper.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/utils/ads.dart';
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
  BannerAd? _bannerAd;
  bool _isBannerReady = false;

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

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // Só carrega o banner se ainda não tiver carregado
    if (_bannerAd == null && (Platform.isAndroid || Platform.isIOS)) {
      await _loadAdaptiveBanner();
    }
  }

  Future<void> _loadAdaptiveBanner() async {
    _bannerAd = await AdsHelper.getBannerAdd(context);

    if (_bannerAd != null) {
      setState(() {
        _isBannerReady = true;
      });
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.only(bottom: 0),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                indicatorColor: Colors.transparent,
                backgroundColor: context.colors.tabBarBackground,
                labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
                  states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return TextStyle(
                      color: context.colors.focusColor,
                      fontWeight: FontWeight.w600,
                    );
                  }
                  return TextStyle(color: context.colors.titleText);
                }),
                iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
                  states,
                ) {
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
          ),

          if (_isBannerReady && _bannerAd != null)
            ClipRRect(
              child: SizedBox(
                width: MediaQuery.of(context).size.width, // largura total
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
        ],
      ),
    );
  }
}
