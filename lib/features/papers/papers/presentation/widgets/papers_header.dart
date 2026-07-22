import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_type.dart';
import 'package:math_matric/theme/app_colours.dart';

class PapersHeader extends StatelessWidget {
  final PaperType paperType;

  const PapersHeader({
    super.key,
    required this.paperType,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 140,
      backgroundColor: AppColours.background,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => context.pop(), 
        icon: Icon(Icons.arrow_back, color: AppColours.textPrimary,),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          paperType == PaperType.paper1
              ? 'Paper 1'
              : 'Paper 2',
          style: const TextStyle(
            color: AppColours.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
