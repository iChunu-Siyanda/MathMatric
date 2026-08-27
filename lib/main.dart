import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:math_matric/core/dev/dev_seeder.dart';
import 'package:math_matric/core/network/services/sync_progress_manager.dart';
import 'package:math_matric/shared/registrations/ui/register_analytics_streak_module.dart';
import 'package:math_matric/shared/registrations/setup_locator.dart';
import 'package:path_provider/path_provider.dart';
import 'app/math_matric_app.dart';
import 'app/bloc_observer.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try{
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );
  }catch (e){
    debugPrint("Error initializing Firebase & dot_env: $e");
  }

  await setupLocator();

  //Uncomment DevSeeder when you want to reset/sync.
  await DevSeeder.seedDatabaseOnce();

  final syncManager = getIt<SyncProgressManager>(); //SyncProgressManager is an application-lifetime service
  await syncManager.start();

  Bloc.observer = AppBlocObserver();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationDocumentsDirectory()).path,
          ),
  );
  // ⚠️ UNCOMMENT THIS ONCE to completely purge old cached state from disk:
  // await HydratedBloc.storage.clear();

  runApp(MathMatricApp(),);
}


// main()
//  │
//  ├── Firebase.initializeApp()
//  │
//  ├── setupLocator()
//  │      │
//  │      └── registerServiceModule()
//  │              │
//  │              ├── ConnectivityService
//  │              ├── InternetChecker
//  │              ├── SyncCoordinator
//  │              └── SyncManager
//  │
//  └── runApp()
//         │
//         ▼
//  MathMatricApp
//         │
//         └── SyncManager.start()
//                 │
//                 ├── App resumed
//                 │
//                 ├── Internet returns
//                 │
//                 └── Initial startup
//                          │
//                          ▼
//                     Internet check
//                          │
//                          ▼
//                     10-min cooldown
//                          │
//                          ▼
//                   SyncCoordinator

// Sync:
// main()
//   ↓
// setupLocator()
//   ↓
// SyncProgressManager created
//   ↓
// start()
//   ↓
// listens for:
//   • internet changes
//   • app resume
//   • sync opportunities
//   ↓
// app runs