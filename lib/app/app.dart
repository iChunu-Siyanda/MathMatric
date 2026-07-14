import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/home/presentation/bloc/study_history_bloc.dart';
import 'package:math_matric/features/streak/presentation/bloc/habit_bloc.dart';
import 'package:math_matric/shared/app_routes/routes.dart';
import 'router.dart';

class MathMatricApp extends StatelessWidget {
  const MathMatricApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HabitBloc()),
        BlocProvider(create: (context) => StudyHistoryBloc()),
      ],
      child: MaterialApp(
        title: 'MathMatric',
        debugShowCheckedModeBanner: false,
      
        onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings,),
        initialRoute: Routes.initial,

        theme: ThemeData(
          useMaterial3: true,
        ),
      ),
    );
  }
}  
