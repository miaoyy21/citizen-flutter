import 'package:citizen/index.dart';

extension ExtensionObject on Object {
  double currentTime() {
    return DateTime.now().microsecondsSinceEpoch.toDouble() /
        Duration.microsecondsPerSecond;
  }
}

extension ExtensionImagePoint on ImagePoint {
  // 与地面存在5像素的固定差值
  Vector2 toGlobal(Vector2 p0) => Vector2(p0.x + x, p0.y - y);
}
