import '../index.dart';

class Player extends SpriteComponent
    with HasGameReference<CitizenGame>, CollisionCallbacks {
  Player({super.position})
      : super(anchor: Anchor.bottomLeft, key: ComponentKey.named("player"));

  late Direction direction = Direction.right;
  late Animation animation = Animation.idleRight;

  late List<Sprite?> idleLeft;
  late List<Sprite?> idleRight;

  late List<Sprite?> walkLeft;
  late List<Sprite?> walkRight;

  late List<Sprite?> runLeft;
  late List<Sprite?> runRight;

  late List<Sprite?> jumpLeft;
  late List<Sprite?> jumpRight;

  late double onTime = 0;

  List<Sprite?> frames = [];

  @override
  Future<void> onLoad() async {
    final l6 = List.generate(6, (i) => i + 1);
    final l12 = List.generate(12, (i) => i + 1);
    final idleFiles = l6.map((i) => "2001_$i.png").toList();
    final walkFiles = l6.map((i) => "2002_$i.png").toList();
    final runFiles = l6.map((i) => "2003_$i.png").toList();
    final jumpFiles = l12.map((i) => "2005_$i.png").toList();

    idleLeft = (await Flame.images.loadAll(idleFiles))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();
    idleRight = (await Flame.images.loadAll(idleFiles))
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
    jumpLeft = (await Flame.images.loadAll(jumpFiles))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();
    jumpRight = (await Flame.images.loadAll(jumpFiles))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();

    // 初始帧为向右站立
    final empty = await Flame.images.load("empty.png");
    sprite = SpriteComponent.fromImage(empty).sprite;
    frames = idleRight;
  }

  bool repeat = false;

  finished() {
    repeat = false;
  }

  action(AnimationEvent event, Direction newDirection) {
    if (animation != Animation.idleLeft && animation != Animation.idleRight) {
      if (event == AnimationEvent.run) {
        if (animation != Animation.walkLeft &&
            animation != Animation.walkRight) {
          return;
        }
      } else {
        return;
      }
    }

    if (newDirection != Direction.repeat) {
      direction = newDirection;
    }

    onTime = 0;
    repeat = true;
    if (event == AnimationEvent.walk) {
      if (direction == Direction.left) {
        animation = Animation.walkLeft;
        frames = walkLeft;
      } else {
        animation = Animation.walkRight;
        frames = walkRight;
      }
    } else if (event == AnimationEvent.run) {
      if (direction == Direction.left) {
        animation = Animation.runLeft;
        frames = runLeft;
      } else {
        animation = Animation.runRight;
        frames = runRight;
      }
    } else if (event == AnimationEvent.jump) {
      if (direction == Direction.left) {
        animation = Animation.jumpLeft;
        frames = jumpLeft;
      } else {
        animation = Animation.jumpRight;
        frames = jumpRight;
      }
    }
  }

  @override
  void update(double dt) {
    onTime = onTime + dt;
    final index = (onTime * 12).floor();
    sprite = frames[index];

    // 是否是最后1帧
    if (index + 1 == frames.length) {
      onTime = 0;

      if (!repeat) {
        if (direction == Direction.left) {
          animation = Animation.idleLeft;
          frames = idleLeft;
        } else if (direction == Direction.right) {
          animation = Animation.idleRight;
          frames = idleRight;
        }
      }
    }

    // if (index + 1 == frames.length&&) {
    //   onTime = 0;
    //   if (direction == Direction.left) {
    //     animation = Animation.idleLeft;
    //
    //     frames.clear();
    //     frames.addAll(idleLeft);
    //   } else {
    //     animation = Animation.idleRight;
    //
    //     frames.clear();
    //     frames.addAll(idleRight);
    //   }
    // }

    // final direction_ = joystick.direction;
    // if (direction_ == direction) {
    //   onTime = onTime + dt;
    // } else {
    //   onTime = 0;
    // }
    //
    // // 移动速度及使用的动画帧
    // int speed = 0;
    // List<Sprite?> frames;
    // switch (joystick.direction) {
    //   case JoystickDirection.left:
    //     speed = -50;
    //     frames = walkLeft;
    //     break;
    //   case JoystickDirection.upLeft:
    //     speed = -75;
    //     frames = jump;
    //     break;
    //   case JoystickDirection.downLeft:
    //     frames = defenseLeft;
    //     break;
    //   case JoystickDirection.up:
    //     frames = jump;
    //     break;
    //   case JoystickDirection.right:
    //     speed = 50;
    //     frames = walkRight;
    //     break;
    //   case JoystickDirection.upRight:
    //     speed = 75;
    //     frames = jump;
    //     break;
    //   case JoystickDirection.downRight:
    //     frames = defenseRight;
    //     break;
    //   case JoystickDirection.down:
    //     frames = squat;
    //     break;
    //   default:
    //     frames = idle;
    // }
    //
    // // 超过3秒行走，转为跑
    // if (onTime > 3) {
    //   if (direction_ == JoystickDirection.left) {
    //     speed = -100;
    //     frames = runLeft;
    //   } else if (direction_ == JoystickDirection.right) {
    //     speed = 100;
    //     frames = runRight;
    //   }
    // }
    //
    // sprite = frames[(onTime ~/ 0.08) % frames.length];
    // direction = direction_;
    //
    // // 水平方向移动
    // position.add(Vector2(speed * dt, 0));
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
