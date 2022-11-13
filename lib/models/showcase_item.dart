import 'package:flutter/material.dart';

class ShowcaseItem {
  final String name;
  final WidgetBuilder pageBuilder;

  ShowcaseItem({
    required this.name,
    required this.pageBuilder,
  });

  @override
  String toString() => '$name Page';
}
