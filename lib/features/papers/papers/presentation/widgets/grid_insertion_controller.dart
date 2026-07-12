import 'dart:async';
import 'package:flutter/material.dart';

class GridInsertionController {
  final SliverAnimatedGridState gridState;
  final int totalItems;
  final Duration delay;

  int insertedCount = 0;

  GridInsertionController({
    required this.gridState,
    required this.totalItems,
    this.delay = const Duration(milliseconds: 120),
  });

  Future<void> staggerInsert() async {
    for (var i = 0; i < totalItems; i++) {
      gridState.insertItem(insertedCount);
      insertedCount++;
      await Future.delayed(delay);
    }
  }
}
