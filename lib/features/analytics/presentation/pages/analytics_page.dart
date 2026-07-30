import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:math_matric/features/analytics/presentation/bloc/analytics_state.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final int _selectedTimeframe = 0; // 0: 7 Days, 1: 30 Days, 2: All Time
  bool _showLineGraph = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        backgroundColor: AppColours.background,
        elevation: 0,
        //scaffoldWillScaffold: false,
        title: const Text(
          'Analytics',
          style: TextStyle(
            color: AppColours.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.menu,
            color: AppColours.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.tune_rounded,
              color: AppColours.textSecondary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: BlocBuilder<AnalyticsBloc,AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return SizedBox.shrink();
        },),
      ),
    );
  }
}
