import 'package:get_it/get_it.dart';
import 'package:on_time/database/database.dart';

GetIt db = GetIt.instance;

void setup() {
  db.registerLazySingleton(() => AppDatabase());
}
