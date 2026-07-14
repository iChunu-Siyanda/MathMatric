import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/papers/presentation/bloc/papers_bloc.dart';
import 'package:math_matric/features/papers/papers/presentation/pages/papers_page.dart';
import 'package:math_matric/shared/registrations/register_exams_module.dart';

class PaperTypeRoutes {
  const PaperTypeRoutes._();

  static Route<dynamic> paperTypeRoute(RouteSettings settings) {
    final paperType = settings.arguments as PaperType; 
    
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => BlocProvider(
        create: (_) => getIt<PapersBloc>(),
        child: PapersPage(paperType: paperType),
      ),
    );
  }
}
