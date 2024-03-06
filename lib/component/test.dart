import 'package:citizen/index.dart';

class TestComponent extends PositionComponent
    with HasGameReference<CitizenGame> {
  final Color debugColor;

  TestComponent({super.position, super.size, required this.debugColor})
      : super(anchor: Anchor.bottomLeft);

  @override
  FutureOr<void> onLoad() {
    // 示例：
    // final min1 = other.frame.exposeHead.first.min.toGlobal(p1);
    // final max1 = other.frame.exposeHead.first.max.toGlobal(p1);
    //
    // final ttt = TestComponent(
    //     position: Vector2(min1.x, min1.y),
    //     size: Vector2(max1.x - min1.x, min1.y - max1.y));
    // world.add(ttt);

    add(
      RectangleHitbox()
        ..debugMode = true
        ..debugColor = debugColor,
    );
  }
}
