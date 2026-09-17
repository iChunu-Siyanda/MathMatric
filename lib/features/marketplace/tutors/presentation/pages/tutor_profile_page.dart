import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/profile/tutor_profile_bloc.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/profile/tutor_profile_event.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/profile/tutor_profile_state.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/widgets/booking_button.dart';

class TutorProfilePage extends StatefulWidget {
  final String tutorId;
  const TutorProfilePage({super.key, required this.tutorId});

  @override
  State<TutorProfilePage> createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends State<TutorProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<TutorProfileBloc>().add(TutorProfileRequested(widget.tutorId));
  }

  String _formatPrice(double cents) {
    return 'R${(cents / 100).toStringAsFixed(0)}/hr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      body: BlocBuilder<TutorProfileBloc, TutorProfileState>(
        builder: (context, state) {
          if (state is TutorProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColours.primaryAccent),
            );
          }

          if (state is TutorProfileError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: AppColours.errorRed)),
            );
          }

          if (state is TutorProfileLoaded) {
            final tutor = state.tutor;

            return Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      // Hero Floating Header
                      SliverAppBar(
                        expandedHeight: 240,
                        pinned: true,
                        backgroundColor: AppColours.cobaltBlue,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            decoration: const BoxDecoration(
                              gradient: AppColours.softHeaderGradient,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 40),
                                CircleAvatar(
                                  radius: 44,
                                  backgroundColor: AppColours.surface,
                                  backgroundImage: tutor.photoUrl != null
                                      ? NetworkImage(tutor.photoUrl!)
                                      : null,
                                  child: tutor.photoUrl == null
                                      ? const Icon(Icons.person, size: 40, color: AppColours.textMuted)
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      tutor.displayName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColours.textPrimary,
                                      ),
                                    ),
                                    if (tutor.isVerified) ...[
                                      const SizedBox(width: 4),
                                      const Icon(Icons.check_circle_rounded, color: AppColours.cobaltBlue, size: 20),
                                    ],
                                  ],
                                ),
                                if (tutor.headline != null)
                                  Text(
                                    tutor.headline!,
                                    style: const TextStyle(color: AppColours.textSecondary, fontSize: 13),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Profile Details Content
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Ratings & Experience Overview Container
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColours.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColours.border),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        const Icon(Icons.star_rounded, color: AppColours.warningAmber),
                                        const SizedBox(height: 4),
                                        Text('${tutor.rating} (${tutor.reviewCount} reviews)',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      ],
                                    ),
                                    Container(height: 30, width: 1, color: AppColours.border),
                                    Column(
                                      children: [
                                        const Icon(Icons.workspace_premium_rounded, color: AppColours.cobaltBlue),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${tutor.experienceYears} Years Exp.',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // About Section
                              if (tutor.bio != null) ...[
                                const Text('About', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColours.textPrimary)),
                                const SizedBox(height: 6),
                                Text(tutor.bio!, style: const TextStyle(color: AppColours.textSecondary, height: 1.4)),
                                const SizedBox(height: 16),
                              ],

                              // Qualifications & Institution
                              const Text('Qualifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColours.textPrimary)),
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColours.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColours.border),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(tutor.qualification ?? 'Degree / Certification pending', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    if (tutor.institution != null)
                                      Text(tutor.institution!, style: const TextStyle(color: AppColours.textSecondary, fontSize: 13)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Rates Section
                              const Text('Teaching Rates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColours.textPrimary)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColours.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColours.border),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Online Session'),
                                        Text(_formatPrice(tutor.onlinePriceCents), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColours.cobaltBlue)),
                                      ],
                                    ),
                                    const Divider(color: AppColours.border),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('In-Person Session'),
                                        Text(_formatPrice(tutor.inPersonPriceCents), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColours.electricViolet)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Sticky Bottom Bar: Book Action
                BookingButton(),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
