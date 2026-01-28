import 'package:flutter/material.dart';

class WeekdayHeader extends StatelessWidget {
  const WeekdayHeader({super.key});

  static const days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map(
            (day) => SizedBox(
              width: 18,
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Colors.grey),
              ),
            ),
          )
          .toList(),
    );
  }
}
