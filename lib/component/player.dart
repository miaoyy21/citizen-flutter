import 'dart:ui';

import '../index.dart';

class JoystickPlayer extends SpriteComponent
    with HasGameReference<CitizenGame>, CollisionCallbacks {
  final JoystickComponent joystick;

  JoystickPlayer(this.joystick, {super.position})
      : super(anchor: Anchor.bottomLeft);

  late List<Sprite?> idle;
  late List<Sprite?> walkLeft;
  late List<Sprite?> walkRight;
  late List<Sprite?> runLeft;
  late List<Sprite?> runRight;

  late List<Sprite?> jump; // 向上跳，包括向左或向右
  late List<Sprite?> squat; // 蹲下
  late List<Sprite?> defenseLeft; // 向左防御
  late List<Sprite?> defenseRight; // 向右防御

  late JoystickDirection direction = JoystickDirection.right;
  late double onTime = 0;

  @override
  Future<void> onLoad() async {
    final l4 = List.generate(4, (i) => i + 1);
    final l6 = List.generate(6, (i) => i + 1);
    final l12 = List.generate(12, (i) => i + 1);
    final idleFiles = l6.map((i) => "2001_$i.png").toList();
    final walkFiles = l6.map((i) => "2002_$i.png").toList();
    final runFiles = l6.map((i) => "2003_$i.png").toList();
    final jumpFiles = l12.map((i) => "2005_$i.png").toList();
    final squatFiles = l4.map((i) => "2006_$i.png").toList();

    idle = (await Flame.images.loadAll(idleFiles))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();
    walkLeft = (await Flame.images.loadAll(walkFiles))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();
    walkRight = (await Flame.images.loadAll(walkFiles))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();
    runLeft = (await Flame.images.loadAll(runFiles))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();
    runRight = (await Flame.images.loadAll(runFiles))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();
    jump = (await Flame.images.loadAll(jumpFiles))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();
    squat = (await Flame.images.loadAll(squatFiles))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();
    ;
    defenseLeft = [idle.first];
    defenseRight = [idle.first];

    // 初始帧为向右站立
    sprite = idle.first;
    add(RectangleHitbox()..debugMode = true);
  }

  @override
  void update(double dt) {
    final direction_ = joystick.direction;
    if (direction_ == direction) {
      onTime = onTime + dt;
    } else {
      onTime = 0;
    }

    // 移动速度及使用的动画帧
    int speed = 0;
    List<Sprite?> frames;
    switch (joystick.direction) {
      case JoystickDirection.left:
        speed = -50;
        frames = walkLeft;
        break;
      case JoystickDirection.upLeft:
        speed = -75;
        frames = jump;
        break;
      case JoystickDirection.downLeft:
        frames = defenseLeft;
        break;
      case JoystickDirection.up:
        frames = jump;
        break;
      case JoystickDirection.right:
        speed = 50;
        frames = walkRight;
        break;
      case JoystickDirection.upRight:
        speed = 75;
        frames = jump;
        break;
      case JoystickDirection.downRight:
        frames = defenseRight;
        break;
      case JoystickDirection.down:
        frames = squat;
        break;
      default:
        frames = idle;
    }

    // 超过3秒行走，转为跑
    if (onTime > 3) {
      if (direction_ == JoystickDirection.left) {
        speed = -100;
        frames = runLeft;
      } else if (direction_ == JoystickDirection.right) {
        speed = 100;
        frames = runRight;
      }
    }

    sprite = frames[(onTime ~/ 0.08) % frames.length];
    direction = direction_;

    // 水平方向移动
    position.add(Vector2(speed * dt, 0));
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    // debugPrint("Player onCollisionStart ${(other as NPC).id}");
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    // debugPrint("Player onCollisionEnd ${(other as NPC).id}");
  }
}
