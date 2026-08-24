import 'package:flutter/material.dart';

Color tileColorForMinutes(BuildContext context, int minutes) {
  final primary = Theme.of(context).colorScheme.primary;

  if (minutes == 0) {
    return Theme.of(context).colorScheme.surfaceContainerHighest;
  } else if (minutes < 20) {
    return primary.withValues(alpha: 0.15);
  } else if (minutes < 45) {
    return primary.withValues(alpha: 0.35);
  } else if (minutes < 90) {
    return primary.withValues(alpha: 0.6);
  } else {
    return primary;
  }
}
