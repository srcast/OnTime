import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/app_feedback.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/tutorial/tutorial_flow.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/router/app_router.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/services/points_service.dart';
import 'package:on_time/viewmodel/analysis_page_vm.dart';
import 'package:on_time/viewmodel/configurations/configurations_config_page_vm.dart';
import 'package:on_time/viewmodel/configurations/define_hour_value_config_page_vm.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  final db = AppDatabase();
  final pointsService = PointsService(db);
  final configsService = ConfigsService(db);

  final config = await configsService.ensureConfigExists();
  final tutorialFlow = TutorialFlow(
    configsService,
    hasSeenTutorial: config.hasSeenTutorial,
  );
  GenericHelper.selectedCurrencyCode = config.currencyCode;
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
          // services
          Provider.value(value: db),
          Provider.value(value: pointsService),
          Provider.value(value: configsService),
          ChangeNotifierProvider.value(value: tutorialFlow),

          // view models -> one per page for the whole app (state kept between visits)
          ChangeNotifierProvider(
            create:
                (context) => HomePageVM(
                  context.read<PointsService>(),
                  context.read<ConfigsService>(),
                ),
          ),
          ChangeNotifierProvider(
            create: (context) => AnalysisPageVM(context.read<PointsService>()),
          ),
          ChangeNotifierProvider(
            create:
                (context) =>
                    DefineHourValueConfigPageVM(context.read<ConfigsService>()),
          ),
          ChangeNotifierProvider(
            create:
                (context) =>
                    ConfigConfigurationsPageVM(context.read<ConfigsService>()),
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
