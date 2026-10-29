import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:on_time/database/locator.dart';
import 'package:on_time/helpers/app_feedback.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/helpers/tutorial_helper.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/router/app_router.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/viewmodel/analysis_page_vm.dart';
import 'package:on_time/viewmodel/configurations/configurations_config_page_vm.dart';
import 'package:on_time/viewmodel/configurations/define_hour_value_config_page_vm.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // errors not handled in the view models -> at least they get logged
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    AppFeedback.logError(
      'FlutterError',
      details.exception,
      details.stack ?? StackTrace.current,
    );
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    AppFeedback.logError('PlatformDispatcher', error, stack);
    return true;
  };

  await EasyLocalization.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  setup();

  final config = await locator<ConfigsService>().ensureConfigExists();
  TutorialHelper.hasSeenTutorial = config.hasSeenTutorial;
  //GlobalData.showInterstitialAds = config.showAds; // ads

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
          enabled: !kReleaseMode, // only in debug/profile builds
          builder: (context) => MyApp(),
        ),
      ),
    ),
  );

  // ads
  // if (Platform.isAndroid || Platform.isIOS) {
  //   await AdsHelper.initialize();
  //   AdsHelper.loadInterstitialAd();
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // same instance used by the configurations page (MultiProvider in main)
    return Consumer<ConfigConfigurationsPageVM>(
      builder: (context, vm, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // before configs are loaded the vm has the default language
          if (vm.isLoaded && context.locale != vm.appLanguage) {
            context.setLocale(vm.appLanguage);
          }
        });

        return MaterialApp.router(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          builder: DevicePreview.appBuilder,
          routerConfig: AppRouter.router,
          scaffoldMessengerKey: AppFeedback.scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: vm.flutterThemeMode,
        );
      },
    );
  }
}
