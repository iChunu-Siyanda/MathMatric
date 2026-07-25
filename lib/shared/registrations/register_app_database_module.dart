import 'package:get_it/get_it.dart';
import 'package:math_matric/core/database/app_database.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton<AppDatabase>(
    () => AppDatabase(),
  );
}
