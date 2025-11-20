import 'package:flutter/material.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Padding(
        padding: EdgeInsetsGeometry.only(top: 50,left: 40,bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Icon(Icons.group),
                  ),
                ), 

                SizedBox(width: 10,),

                Text(
                  "Your Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),

            Column(
              children: [
                DrawerRow(icon: Icons.error_outline, text: 'Settings',),

                SizedBox(height: 20,),

                DrawerRow(icon: Icons.lightbulb_outline, text: 'Hints',),

                SizedBox(height: 20,),

                DrawerRow(icon: Icons.person_outline, text: 'Profile',),

                SizedBox(height: 20,),

                DrawerRow(icon: Icons.favorite_border, text: 'Favourites',),

                SizedBox(height: 20,),

                DrawerRow(icon: Icons.history_edu_outlined, text: 'History',),

                SizedBox(height: 20,),
              ],
            ),

            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.white.withValues(alpha: 0.5),
                ),

                SizedBox(width: 20,),

                Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }  
}

class DrawerRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const DrawerRow({
    super.key,
    required this.icon,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
    
        SizedBox(width: 20,),
    
        Text(
          text ,
          style: TextStyle(
            color: Colors.white
          ),
        )
      ],
    );
  }
}  