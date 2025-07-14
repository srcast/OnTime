import 'package:get_it/get_it.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/services/points_service.dart';
import 'package:on_time/viewmodel/configurations/define_hour_value_config_page_vm.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';

GetIt locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton(() => AppDatabase());
  locator.registerLazySingleton(() => PointsService(locator<AppDatabase>()));
  locator.registerFactory(
    () => HomePageVM(locator<PointsService>(), locator<ConfigsService>()),
  );
  locator.registerLazySingleton(() => ConfigsService(locator<AppDatabase>()));
  locator.registerFactory(
    () => DefineHourValueConfigPageVM(locator<ConfigsService>()),
  );
}
