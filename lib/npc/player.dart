import 'dart:math';

import '../index.dart';

class JoystickPlayer extends SpriteComponent
    with HasGameReference, CollisionCallbacks {
  final JoystickComponent joystick;

  JoystickPlayer(this.joystick)
      : super(size: Vector2(16, 32), anchor: Anchor.center);

  double maxSpeed = 64;

  Direction direction = Direction.right;

  late Map<Direction, SpriteAnimation> animations;

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load("Hero.png");
    final spriteSheet = SpriteSheet(image: image, srcSize: size);

    animations = {
      Direction.left:
          spriteSheet.createAnimation(row: 2, stepTime: 0.25, from: 0, to: 6),
      Direction.left:
      spriteSheet.createAnimation(row: 2, stepTime: 0.25, from: 0, to: 6),
      Direction.left:
      spriteSheet.createAnimation(row: 2, stepTime: 0.25, from: 0, to: 6),
      Direction.left:
      spriteSheet.createAnimation(row: 2, stepTime: 0.25, from: 0, to: 6),
    };

    // _frames = SpriteAnimation.fromFrameData(
    //   image,
    //   SpriteAnimationData.sequenced(
    //     amount: 4,
    //     stepTime: 0.25,
    //     textureSize: size,
    //   ),
    // ).frames;

    // sprite = _frames[0].sprite;
    sprite = spriteAnimation.frames[0].sprite;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
      position.add(joystick.relativeDelta * maxSpeed * dt);

      debugPrint("joystick.direction ${joystick.direction}");

      nn++;
      if (joystick.isDragged) {
        sprite = spriteAnimation.frames[(nn ~/ 10) % 6].sprite;
      } else {
        sprite = spriteAnimation.frames[5].sprite;
      }

      final sAngle = joystick.delta.screenAngle();
      if (sAngle > -pi / 4 && sAngle <= pi / 4) {
        // Top
        // sprite = _frames[1].sprite;
      } else if (sAngle > pi / 4 && sAngle <= pi * 3 / 4) {
        // Right
        // sprite = _frames[0].sprite;
      } else if (sAngle < -pi * 3 / 4 || sAngle >= pi * 3 / 4) {
        // Bottom
        // sprite = _frames[3].sprite;
      } else if (sAngle < -pi / 4 && sAngle >= -pi * 3 / 4) {
        // Left
        // sprite = _frames[2].sprite;
      }
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    debugPrint("onCollisionStart");
  }
}
