import '../index.dart';

class Enemy extends SpriteComponent
    with HasGameReference<CitizenGame>, CollisionCallbacks {
  final int id;
  final Cape cape;
  final Color color;

  Enemy(this.id, this.cape, this.color, {super.position})
      : super(anchor: Anchor.bottomCenter);

  late double onTime = 0;
  late StickDirection direction = StickDirection.left;
  late AnimationFrames aniFrames;

  late AnimationFrameData frame;
  late AnimationFrameData byFrame;

  @override
  FutureOr<void> onLoad() async {
    final empty = await Flame.images.load("empty.png");
    sprite = SpriteComponent.fromImage(empty).sprite;
    aniFrames = AnimationStore()
        .byEvent(StickAnimationEvent.idle, StickSymbol.self, direction);
    byFrame = AnimationFrameData.invalid();

    add(
      RectangleHitbox()
        ..debugMode = true
        ..debugColor = Colors.blue,
    );

    add(ColorEffect(color, EffectController(duration: 0)));
  }

  @override
  void update(double dt) {
    if (((onTime + dt) * 12).floor() >= aniFrames.frames.length) {
      aniFrames = AnimationStore()
          .byEvent(StickAnimationEvent.idle, StickSymbol.self, direction);
      onTime = 0;
    }

    onTime = onTime + dt;
    late int index = (onTime * 12).floor();

    sprite = aniFrames.frames[index];
    cape.sprite = aniFrames.capeFrames[index];

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
