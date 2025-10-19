import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/database/locator.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/helpers/tutorial_helper.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/router/app_router.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/viewmodel/analysis_page_vm.dart';
import 'package:on_time/viewmodel/configurations/configurations_config_page_vm.dart';
import 'package:on_time/viewmodel/configurations/define_hour_value_config_page_vm.dart';
import 'package:on_time/viewmodel/configurations_page_vm.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:on_time/views/configurations_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  setup();

  final config = await locator<ConfigsService>().ensureConfigExists();
  TutorialHelper.hasSeenTutorial = config.hasSeenTutorial;

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('pt', 'PT'), Locale('en'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      startLocale: GenericHelper.getLocaleFromDBLang(
        GenericHelper.getALanguageOptfromString(config.language),
      ),
      child: MultiProvider(
        providers: [
          Provider(
            create: (context) => AppDatabase(),
            dispose: (context, AppDatabase db) => db.close(),
          ),
          ChangeNotifierProvider(create: (_) => locator<HomePageVM>()),
          ChangeNotifierProvider(create: (_) => locator<AnalysisPageVM>()),
          ChangeNotifierProvider(
            create: (_) => locator<DefineHourValueConfigPageVM>(),
          ),
          ChangeNotifierProvider(
            create: (_) => locator<ConfigConfigurationsPageVM>(),
          ),
        ],
        child: DevicePreview(
          builder: (context) {
            return MyApp();
          },
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = ConfigConfigurationsPageVM(locator<ConfigsService>());

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (vm.appLanguage != null && context.locale != vm.appLanguage) {
            context.setLocale(vm.appLanguage);
          }
        });

        return vm;
      },
      child: Consumer<ConfigConfigurationsPageVM>(
        builder: (context, vm, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (vm.appLanguage != null && context.locale != vm.appLanguage) {
              context.setLocale(vm.appLanguage);
            }
          });

          return MaterialApp.router(
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            builder: DevicePreview.appBuilder,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: vm.flutterThemeMode,
          );
        },
      ),
    );
  }
}
