import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/core/network/services/sync_progress_manager.dart';
import 'package:math_matric/features/progress/studysession/bloc/study_session_bloc.dart';
import 'package:math_matric/features/ui/home/presentation/bloc/study_history_bloc.dart';
import 'package:math_matric/features/ui/streak/presentation/bloc/habit_bloc.dart';
import 'package:math_matric/shared/registrations/ui/register_analytics_streak_module.dart';
import '../shared/app_routes/router.dart';

class MathMatricApp extends StatefulWidget {
  const MathMatricApp({super.key});

  @override
  State<MathMatricApp> createState() => _MathMatricAppState();
}

class _MathMatricAppState extends State<MathMatricApp> {
  late final SyncProgressManager syncManager;

  @override
  void initState() {
    super.initState();

    syncManager = getIt<SyncProgressManager>();
    syncManager.start();
  }

  @override
  void dispose() {
    syncManager.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<HabitBloc>(),),
        BlocProvider(create: (context) => getIt<StudyHistoryBloc>(),),
        BlocProvider(create: (context) => getIt<StudySessionBloc>(),),
      ],
      child: MaterialApp.router(
        title: 'MathMatric',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        theme: ThemeData(
          useMaterial3: true,
        ),
      ),
    );
  }
}  

// Lifecycle foundation:
// main()
//   ↓
// Firebase.initializeApp()
//   ↓
// setupLocator()
//   ↓
// SyncProgressManager.start()
//   ↓
// MathMatricApp
