import 'package:citizen/index.dart';

extension ExtensionObject on Object {
  double currentTime() {
    return DateTime.now().microsecondsSinceEpoch.toDouble() /
        Duration.microsecondsPerSecond;
  }
}

extension ExtensionImagePoint on ImagePoint {
  Vector2 toVector2(Vector2 p0) => Vector2(p0.x + x, p0.y - y);
}
