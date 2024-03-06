import 'package:citizen/index.dart';

class TestComponent extends PositionComponent
    with HasGameReference<CitizenGame> {
  TestComponent({super.position, super.size})
      : super(anchor: Anchor.bottomLeft);

  @override
  FutureOr<void> onLoad() {
    add(
      RectangleHitbox()
        ..debugMode = true
        ..isSolid = true
        ..debugColor = Colors.redAccent,
    );
  }
}
