import 'dart:math';

import 'package:flame/src/experimental/geometry/shapes/shape.dart';

import '../index.dart';

class JoystickPlayer extends SpriteComponent
    with HasGameReference<CitizenGame>, CollisionCallbacks {
  final JoystickComponent joystick;
  final double maxSpeed;

  JoystickPlayer(this.joystick, this.maxSpeed, {super.position})
      : super(size: Vector2(16, 32), anchor: Anchor.center);

  static const double stepTime = 0.125;
  late Direction direction = Direction.right;

  late Map<Direction, Map<Animation, SpriteAnimation>> animations;
  late double onTime = 0;

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load("Hero.png");
    final spriteSheet = SpriteSheet(image: image, srcSize: size);

    animations = {
      Direction.left: {
        Animation.idle: spriteSheet.createAnimation(
            row: 1, stepTime: stepTime, from: 12, to: 17),
        Animation.run: spriteSheet.createAnimation(
            row: 2, stepTime: stepTime, from: 12, to: 17),
      },
      Direction.up: {
        Animation.idle: spriteSheet.createAnimation(
            row: 1, stepTime: stepTime, from: 6, to: 11),
        Animation.run: spriteSheet.createAnimation(
            row: 2, stepTime: stepTime, from: 6, to: 11)
      },
      Direction.right: {
        Animation.idle: spriteSheet.createAnimation(
            row: 1, stepTime: stepTime, from: 0, to: 5),
        Animation.run: spriteSheet.createAnimation(
            row: 2, stepTime: stepTime, from: 0, to: 5)
      },
      Direction.down: {
        Animation.idle: spriteSheet.createAnimation(
            row: 1, stepTime: stepTime, from: 18, to: 23),
        Animation.run: spriteSheet.createAnimation(
            row: 2, stepTime: stepTime, from: 18, to: 23)
      },
    };

    sprite = animations[direction]?[Animation.idle]?.frames[0].sprite;
    add(RectangleHitbox()..debugMode = true);
  }

  @override
  void update(double dt) {
    var animation = Animation.run;
    final preDirection = direction;
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        direction = Direction.left;
        break;
      case JoystickDirection.up:
        direction = Direction.up;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        direction = Direction.right;
        break;
      case JoystickDirection.down:
        direction = Direction.down;
        break;
      default:
        animation = Animation.idle;
    }

    // 延续前序动画
    if (preDirection == direction) {
      onTime = onTime + dt;
    } else {
      onTime = 0;
    }

    final frames = animations[direction]?[animation]?.frames;
    sprite = frames?[(onTime ~/ stepTime) % frames.length].sprite;

    position.add(joystick.relativeDelta * maxSpeed * dt);

    game.camera.follow(this);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    debugPrint("Player onCollisionStart ${(other as NPC).id}");
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    debugPrint("Player onCollisionEnd ${(other as NPC).id}");
  }
}
