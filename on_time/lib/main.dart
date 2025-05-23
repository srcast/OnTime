import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/database/locator.dart';
import 'package:on_time/router/app_router.dart';
import 'package:on_time/utils/colors.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_PT', null);

  setup();

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => AppDatabase(),
          dispose: (context, AppDatabase db) => db.close(),
        ),
        ChangeNotifierProvider(create: (_) => locator<HomePageViewModel>()),
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
    locale: DevicePreview.locale(context),
    builder: DevicePreview.appBuilder,
    routerConfig: AppRouter.router,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: AppColors.backgroundLightGray,
      splashColor:
          Colors
              .transparent, // remove animation when clicking button on navigation bar
    ),
  );
}
