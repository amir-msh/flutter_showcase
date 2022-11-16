import 'package:flutter_showcase/models/showcase_item.dart';
import 'package:flutter_showcase/showcases/circles_pattern.dart';

final showcaseItemsList = <ShowcaseItem>[
  ShowcaseItem(
    name: 'Circles Pattern',
    pageBuilder: (context) => const CirclesPatternShowcase(),
  ),
];
