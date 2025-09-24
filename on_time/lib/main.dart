import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/database/locator.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/router/app_router.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:on_time/viewmodel/analysis_page_vm.dart';
import 'package:on_time/viewmodel/configurations/define_hour_value_config_page_vm.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_PT', null);

  setup();

  await locator<ConfigsService>().ensureConfigExists();

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => AppDatabase(),
          dispose: (context, AppDatabase db) => db.close(),
        ),
        ChangeNotifierProvider(create: (_) => locator<HomePageVM>()),
        ChangeNotifierProvider(
          create: (_) => locator<DefineHourValueConfigPageVM>(),
        ),
        ChangeNotifierProvider(create: (_) => locator<AnalysisPageVM>()),
      ],
      child: DevicePreview(
        builder: (context) {
          return MyApp();
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    locale: const Locale('pt', 'PT'),
    //locale: DevicePreview.locale(context),
    builder: DevicePreview.appBuilder,
    routerConfig: AppRouter.router,
    debugShowCheckedModeBanner: false,
    supportedLocales: const [Locale('pt', 'PT'), Locale('en')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    theme: lightTheme,
    darkTheme: darkTheme,
    themeMode: ThemeMode.system,
  );
}
