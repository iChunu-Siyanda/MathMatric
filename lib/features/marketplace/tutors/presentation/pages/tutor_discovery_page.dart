import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_search_criteria.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/search/tutor_search_bloc.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/search/tutor_search_event.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/search/tutor_search_state.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/tutor/tutor_bloc.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/tutor/tutor_event.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/tutor/tutor_states.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/widgets/build_tutor_sliver_list.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/widgets/teaching_mode_header_delegate.dart';

class TutorDiscoveryPage extends StatefulWidget {
  const TutorDiscoveryPage({super.key});

  @override
  State<TutorDiscoveryPage> createState() => _TutorDiscoveryPageState();
}

class _TutorDiscoveryPageState extends State<TutorDiscoveryPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TutorBloc>().add(const LoadTutors());
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.pixels >= notification.metrics.maxScrollExtent * 0.8) {
      final searchState = context.read<TutorSearchBloc>().state;
      if (searchState is TutorSearchLoaded) {
        context.read<TutorSearchBloc>().add(const SearchTutorsLoadMore());
      } else {
        context.read<TutorBloc>().add(const LoadMoreTutors());
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: RefreshIndicator(
          color: AppColours.cobaltBlue,
          onRefresh: () async {
            final searchState = context.read<TutorSearchBloc>().state;
            if (searchState is TutorSearchLoaded) {
              context.read<TutorSearchBloc>().add(const SearchTutorsRefresh());
            } else {
              context.read<TutorBloc>().add(const RefreshTutors());
            }
          },
          child: CustomScrollView(
            slivers: [
              // Sticky App Bar with Search Input
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: AppColours.surface,
                elevation: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(70),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (query) {
                        if (query.trim().isNotEmpty) {
                          context.read<TutorSearchBloc>().add(
                                SearchTutorsRequested(
                                  TutorSearchCriteria(curriculumKey: query.trim()),
                                ),
                              );
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Search tutors, subjects, or qualifications...',
                        hintStyle: const TextStyle(color: AppColours.textMuted, fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColours.primaryAccent),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.tune_rounded, color: AppColours.textSecondary),
                          onPressed: () {
                            // Trigger Filter Bottom Sheet
                          },
                        ),
                        filled: true,
                        fillColor: AppColours.surfaceSecondary,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                title: const Text(
                  'Find a Math Tutor',
                  style: TextStyle(
                    color: AppColours.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Sticky Mode Filter Selector (All, Online, In-Person)
              SliverPersistentHeader(
                pinned: true,
                delegate: TeachingModeHeaderDelegate(),
              ),

              // Tutor List Feed
              BlocBuilder<TutorSearchBloc, TutorSearchState>(
                builder: (context, searchState) {
                  if (searchState is TutorSearchLoaded) {
                    return BuildTutorSliverList(
                      tutors: searchState.filteredTutors,
                      isLoadingMore: searchState.isLoadingMore,
                      hasMore: searchState.hasMore,
                    );
                  }

                  if (searchState is TutorSearchLoading) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(color: AppColours.primaryAccent),
                      ),
                    );
                  }

                  return BlocBuilder<TutorBloc, TutorState>(
                    builder: (context, tutorState) {
                      if (tutorState is TutorLoaded) {
                        return BuildTutorSliverList(
                          tutors: tutorState.tutors,
                          isLoadingMore: tutorState.isLoadingMore,
                          hasMore: tutorState.hasMore,
                        );
                      }

                      if (tutorState is TutorError) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Text(
                              tutorState.message,
                              style: const TextStyle(color: AppColours.errorRed),
                            ),
                          ),
                        );
                      }

                      return const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(color: AppColours.primaryAccent),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
