import 'package:flutter/material.dart';

class AppState extends InheritedWidget {
  final int attendance;

  const AppState({
    super.key,
    required this.attendance,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppState>();
    assert(result != null, 'No AppState found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant AppState oldWidget) {
    return currentCourse != oldWidget.currentCourse;
  }
}
