import 'package:get_it/get_it.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/services/points_service.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';

GetIt locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton(() => AppDatabase());
  locator.registerLazySingleton(() => PointsService(locator<AppDatabase>()));
  locator.registerFactory(() => HomePageVM(locator<PointsService>()));
}
