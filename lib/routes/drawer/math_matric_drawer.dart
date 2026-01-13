import 'package:flutter/material.dart';
import 'package:math_matric/routes/drawer/components/drawer_item.dart';
import 'package:math_matric/routes/drawer/components/streak_indicator.dart';

class MathMatricDrawer extends StatelessWidget {
  final int streak;

  const MathMatricDrawer({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Drawer(
      elevation: 0,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 39, 128, 200), colors.primaryContainer],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/x.png',
                      height: 42,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "MathMatric",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Mathematics Excellence",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          
              /// STREAK
              StreakIndicator(streak: streak),
          
              const SizedBox(height: 16),
              const Divider(),
          
              /// NAVIGATION
              DrawerItem(
                icon: Icons.home_outlined,
                label: "Home",
                onTap: () {},
              ),
              DrawerItem(
                icon: Icons.functions,
                label: "Topics",
                onTap: () {},
              ),
              DrawerItem(
                icon: Icons.edit_note_outlined,
                label: "Practice",
                onTap: () {},
              ),
              DrawerItem(
                icon: Icons.description_outlined,
                label: "Past Papers",
                onTap: () {},
              ),
              DrawerItem(
                icon: Icons.trending_up,
                label: "Progress",
                onTap: () {},
              ),
              DrawerItem(
                icon: Icons.forum_outlined,
                label: "Discussions",
                onTap: () {},
              ),
          
              const Spacer(),
              const Divider(),
          
              // FOOTER
              DrawerItem(
                icon: Icons.settings_outlined,
                label: "Settings",
                onTap: () {},
              ),
              DrawerItem(
                icon: Icons.logout,
                label: "Logout",
                onTap: () {},
              ),
          
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
