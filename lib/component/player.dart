import 'dart:math';

import '../index.dart';

class Player extends SpriteComponent
    with HasGameReference<CitizenGame>, CollisionCallbacks {
  Player({super.position})
      : super(anchor: Anchor.bottomLeft, key: ComponentKey.named("player"));

  late Direction direction = Direction.right;
  late Animation animation = Animation.idleRight;

  // 空闲
  late List<Sprite?> idleLeft;
  late List<Sprite?> idleRight;

  // 走路
  late List<Sprite?> walkLeft;
  late List<Sprite?> walkRight;

  // 奔跑
  late List<Sprite?> runLeft;
  late List<Sprite?> runRight;

  // 跳跃
  late List<Sprite?> jumpLeft;
  late List<Sprite?> jumpRight;

  // 蹲
  late List<Sprite?> squatLeft;
  late List<Sprite?> squatRight;

  // 手脚攻击
  late List<Sprite?> handFootLeft;
  late List<Sprite?> handFootRight;

  late double onTime = 0;

  static const int designFPS = 12;
  List<Sprite?> frames = [];

  @override
  Future<void> onLoad() async {
    final l4 = List.generate(4, (i) => i + 1);
    final l6 = List.generate(6, (i) => i + 1);
    final l12 = List.generate(12, (i) => i + 1);
    final l57 = List.generate(57, (i) => i + 1); // 4个动作
    final idleFiles = l6.map((i) => "2001_$i.png").toList();
    final walkFiles = l6.map((i) => "2002_$i.png").toList();
    final runFiles = l6.map((i) => "2003_$i.png").toList();
    final handFootFiles = l57.map((i) => "2004_$i.png").toList();
    final jumpFiles = l12.map((i) => "2005_$i.png").toList();
    final squatFiles = l4.map((i) => "2006_$i.png").toList();

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
    handFootLeft = (await Flame.images.loadAll(handFootFiles))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();
    handFootRight = (await Flame.images.loadAll(handFootFiles))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();
    jumpLeft = (await Flame.images.loadAll(jumpFiles))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();
    jumpRight = (await Flame.images.loadAll(jumpFiles))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();
    squatLeft = (await Flame.images.loadAll(squatFiles.sublist(1, 2)))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();
    squatRight = (await Flame.images.loadAll(squatFiles.sublist(1, 2)))
        .map((img) => SpriteComponent.fromImage(img).sprite)
        .toList();

    // 初始帧为向右站立
    final empty = await Flame.images.load("empty.png");
    sprite = SpriteComponent.fromImage(empty).sprite;
    resetFrames(idleRight);
  }

  bool repeat = false;

  finished() {
    repeat = false;
  }

  resetFrames(List<Sprite?> newFrames) {
    frames.clear();
    frames.addAll(newFrames);
  }

  // 按方向键产生的角色动作
  arrowAnimation(AnimationEvent event, Direction newDirection) {
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
        resetFrames(walkLeft);
      } else {
        animation = Animation.walkRight;
        resetFrames(walkRight);
      }
    } else if (event == AnimationEvent.run) {
      if (direction == Direction.left) {
        animation = Animation.runLeft;
        resetFrames(runLeft);
      } else {
        animation = Animation.runRight;
        resetFrames(runRight);
      }
    } else if (event == AnimationEvent.jump) {
      if (direction == Direction.left) {
        animation = Animation.jumpLeft;
        resetFrames(jumpLeft);
      } else {
        animation = Animation.jumpRight;
        resetFrames(jumpRight);
      }
    } else if (event == AnimationEvent.squat) {
      if (direction == Direction.left) {
        animation = Animation.squatLeft;
        resetFrames(squatLeft);
      } else {
        animation = Animation.squatRight;
        resetFrames(squatRight);
      }
    }
  }

  // 按快捷键产生的角色动作，包括手拳、脚、投掷
  shortcutSpecialEvent(ShortcutAnimationEvent event) {
    if (animation != Animation.idleLeft && animation != Animation.idleRight) {
      // 是否可以将跳跃改为跳跃用手或用脚攻击
      if (animation == Animation.jumpLeft || animation == Animation.jumpRight) {
        final index = (onTime * designFPS).floor();
        if (index <= 5) {
          // 随机1个动作
          final List<Sprite?> switchFrames;
          if (event == ShortcutAnimationEvent.hand) {
            if (Random.secure().nextBool()) {
              if (direction == Direction.left) {
                switchFrames = handFootLeft.sublist(6, 13);
              } else {
                switchFrames = handFootRight.sublist(6, 13);
              }
            } else {
              if (direction == Direction.left) {
                switchFrames = handFootLeft.sublist(33, 43);
              } else {
                switchFrames = handFootRight.sublist(33, 43);
              }
            }
          } else {
            if (Random.secure().nextBool()) {
              if (direction == Direction.left) {
                switchFrames = handFootLeft.sublist(19, 27);
              } else {
                switchFrames = handFootRight.sublist(19, 27);
              }
            } else {
              if (direction == Direction.left) {
                switchFrames = handFootLeft.sublist(49, 57);
              } else {
                switchFrames = handFootRight.sublist(49, 57);
              }
            }
          }

          repeat = false;
          animation = Animation.attack;
          frames.removeRange(6, 12);
          frames.addAll(switchFrames);
        }
      }

      return;
    }

    // 站立攻击
  }

  @override
  void update(double dt) {
    onTime = onTime + dt;
    final index = (onTime * designFPS).floor();
    sprite = frames[index];

    // 如果是最后一帧，并且不再重复（动作已完成），切换到空闲状态
    if (index + 1 == frames.length) {
      onTime = 0;
      if (!repeat) {
        if (direction == Direction.left) {
          animation = Animation.idleLeft;
          resetFrames(idleLeft);
        } else if (direction == Direction.right) {
          animation = Animation.idleRight;
          resetFrames(idleRight);
        }
      }
    }

    // 水平移动
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
