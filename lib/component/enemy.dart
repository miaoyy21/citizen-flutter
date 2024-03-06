import '../index.dart';

class Enemy extends SpriteComponent
    with HasGameReference<CitizenGame>, CollisionCallbacks {
  final int id;

  Enemy(this.id, {super.position}) : super(anchor: Anchor.bottomCenter);

  late double onTime = 0;

  late AnimationFrameData frame;
  late AnimationFrames aniFrames;

  final _defaultColor = Colors.blue;
  final _collisionColor = Colors.red;

  @override
  FutureOr<void> onLoad() async {
    final empty = await Flame.images.load("empty.png");
    sprite = SpriteComponent.fromImage(empty).sprite;

    aniFrames =
        AnimationStore().byEvent(StickAnimationEvent.idle, StickDirection.left);
    add(
      RectangleHitbox()
        ..debugMode = true
        ..debugColor = _defaultColor,
    );
  }

  @override
  void update(double dt) {
    onTime = onTime + dt;

    final index = (onTime * 12).floor() % aniFrames.frames.length;
    sprite = aniFrames.frames[index];
    frame = aniFrames.framesData[index];
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Player) {
      debugPrint("Player");
    } else if (other is Enemy) {
      debugPrint("Enemy");
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
  }
}
