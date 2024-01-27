import 'package:flutter_showcase/models/showcase_item.dart';
import 'package:flutter_showcase/showcases/circles_pattern.dart';
import 'package:flutter_showcase/showcases/circle_square_pattern.dart';
import 'package:flutter_showcase/showcases/minimal_colorful_progress_indicator.dart';

final showcaseItemsList = <ShowcaseItem>[
  ShowcaseItem(
    name: 'Circles Pattern',
    pageBuilder: (context) => const CirclesPatternShowcase(),
  ),
  ShowcaseItem(
    name: 'Circle Square Pattern',
    pageBuilder: (context) => const CircleSquarePatternShowcase(),
  ),
  ShowcaseItem(
    name: 'Minimal Progress Indicator Showcase',
    pageBuilder: (context) => const MinimalProgressIndicatorShowcase(),
  ),
];
