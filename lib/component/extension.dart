import 'dart:math';

import 'package:citizen/index.dart';

extension ExtensionObject on Object {
  double currentTime() {
    return DateTime.now().microsecondsSinceEpoch.toDouble() /
        Duration.microsecondsPerSecond;
  }
}
