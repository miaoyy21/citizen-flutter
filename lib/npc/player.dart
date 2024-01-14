import '../index.dart';

class JoystickPlayer extends SpriteComponent
    with HasGameRef, CollisionCallbacks {
  final JoystickComponent joystick;

  JoystickPlayer(this.joystick)
      : super(size: Vector2.all(56), anchor: Anchor.center);

  double maxSpeed = 128;
  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();

  late List<SpriteAnimationFrame> _frames;

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load("Hero.png");
    _frames = await SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.25,
        textureSize: size,
      ),
    ).frames;

    sprite = _frames[0].sprite;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      position.add(joystick.relativeDelta * maxSpeed * dt);
      angle = joystick.delta.screenAngle();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    transform.setFrom(_lastTransform);
    size.setFrom(_lastSize);
  }
}
