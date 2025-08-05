import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/viewmodel/analysis_page_vm.dart';
import 'package:on_time/viewmodel/configurations/define_hour_value_config_page_vm.dart';
import 'package:on_time/viewmodel/configurations_page_vm.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:provider/provider.dart';

import '../../models/tabs/destinations.dart';
import '../../utils/colors.dart';

class LayoutScaffold extends StatefulWidget {
  const LayoutScaffold({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  State<LayoutScaffold> createState() => _LayoutScaffoldState();
}

class _LayoutScaffoldState extends State<LayoutScaffold> {
  int _currentIndex = 0;

  late final Map<int, VoidCallback> _onTabReselected = {
    0: () => context.read<HomePageVM>().getSessionPoints(),
    1: () => context.read<AnalysisPageVM>().getData(),
    //2: () => context.read<ConfigurationsPageVM>().cleanSubPagesStack(),
  };

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.navigationShell.currentIndex;
  }

  void _onDestinationSelected(int index) {
    if (index != _currentIndex) {
      // faz reload aos dados chamando o método definido
      _onTabReselected[index]?.call();
      // } else {
      //   if (_currentIndex == 2) {
      //     _onTabReselected[index]?.call(); // if is configs page, close sub pages
      //   }
    }

    setState(() {
      _currentIndex = index;
    });

    widget.navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          backgroundColor: AppColors.white,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                color: AppColors.strongBlue,
                fontWeight: FontWeight.w600,
              );
            }
            return const TextStyle(color: AppColors.labelMediumGray);
          }),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.strongBlue);
            }
            return const IconThemeData(color: AppColors.labelMediumGray);
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
                      label: destination.label,
                      selectedIcon: Icon(
                        destination.icon,
                        color: AppColors.strongBlue,
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

// class LayoutScaffold extends StatelessWidget {
//   const LayoutScaffold({required this.navigationShell, Key? key})
//     : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

//   final StatefulNavigationShell navigationShell;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: navigationShell,
//       bottomNavigationBar: NavigationBarTheme(
//         data: NavigationBarThemeData(
//           indicatorColor: Colors.transparent,
//           backgroundColor: AppColors.white,
//           labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
//             if (states.contains(WidgetState.selected)) {
//               return TextStyle(
//                 color: AppColors.strongBlue,
//                 fontWeight: FontWeight.w600,
//               );
//             }
//             return const TextStyle(color: AppColors.labelMediumGray);
//           }),
//           iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
//             if (states.contains(WidgetState.selected)) {
//               return const IconThemeData(color: AppColors.strongBlue);
//             }
//             return const IconThemeData(
//               color: AppColors.labelMediumGray,
//             ); // Cor quando não selecionado
//           }),
//         ),
//         child: NavigationBar(
//           selectedIndex: navigationShell.currentIndex,
//           onDestinationSelected: navigationShell.goBranch,
//           destinations:
//               destinations
//                   .map(
//                     (destination) => NavigationDestination(
//                       icon: Icon(destination.icon),
//                       label: destination.label,
//                       selectedIcon: Icon(
//                         destination.icon,
//                         color: AppColors.strongBlue,
//                       ),
//                     ),
//                   )
//                   .toList(),
//         ),
//       ),
//     );
//   }
// }
