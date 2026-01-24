import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';
import 'app/bloc_observer.dart';
import 'firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = AppBlocObserver();

  runApp(const MathMatricApp());
}

//UI → Bloc → PaperRepository (abstract) → PaperRepositoryImpl (data) → DataSource


// 🟦 EVENT → PapersBloc: Instance of 'LoadPaperRequested'
// 🟩 STATE → PapersBloc: Change { currentState: Instance of 'PapersInitial', nextState: Instance of 'PapersLoading' }
// 🟩 STATE → PapersBloc: Change { currentState: Instance of 'PapersLoading', nextState: Instance of 'PapersError' }
// 🟦 EVENT → PapersBloc: Instance of 'LoadPaperRequested'
// 🟩 STATE → PapersBloc: Change { currentState: Instance of 'PapersInitial', nextState: Instance of 'PapersLoading' }
// 🟩 STATE → PapersBloc: Change { currentState: Instance of 'PapersLoading', nextState: Instance of 'PapersError' }