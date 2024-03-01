import '../index.dart';

class Player extends SpriteComponent
    with HasGameReference<CitizenGame>, CollisionCallbacks {
  Player({super.position})
      : super(anchor: Anchor.bottomLeft, key: ComponentKey.named("player"));

  static const int designFPS = 12;

  late double speed = 0; // 初始速度
  late double onTime = 0;
  final List<Sprite?> frames = [];

  late StickDirection direction = StickDirection.right;
  late StickAnimationEvent event = StickAnimationEvent.idle;

  @override
  Future<void> onLoad() async {
    // 初始帧为向右站立
    final empty = await Flame.images.load("empty.png");
    sprite = SpriteComponent.fromImage(empty).sprite;
  }

  onChange() {
    // 接受新的键盘输入按键
    if (KeyStore().isRepeat(LogicalKeyboardKey.arrowLeft)) {
      // 向左跑
      speed = -200;
      event = StickAnimationEvent.run;
      direction = StickDirection.left;

      debugPrint("向左跑");
    } else if (KeyStore().isRepeat(LogicalKeyboardKey.arrowRight)) {
      // 向右跑
      speed = 200;
      event = StickAnimationEvent.run;
      direction = StickDirection.right;

      debugPrint("向右跑");
    } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowLeft)) {
      // 向左走
      speed = -100;
      event = StickAnimationEvent.walk;
      direction = StickDirection.left;

      debugPrint("向左走");
    } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowRight)) {
      // 向右走
      speed = 100;
      event = StickAnimationEvent.walk;
      direction = StickDirection.right;

      debugPrint("向右走");
    } else if (KeyStore().isDown(LogicalKeyboardKey.arrowUp)) {
      // 向上跳
      speed = 0;
      event = StickAnimationEvent.jumpUp;

      debugPrint("向上跳");
    } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowDown)) {
      // 向下蹲
      speed = 0;
      event = StickAnimationEvent.squatHalf;

      debugPrint("向下蹲");
    }
  }

  @override
  void update(double dt) {
    if (event == StickAnimationEvent.idle) {
      speed = 0;
      onChange();

      // 重置动画序列
      if (event != StickAnimationEvent.idle) {
        onTime = 0;

        frames.clear();
        frames.addAll(AnimationStore().getFrames(event, direction)!);
      }

      // 按帧播放
      if (frames.isEmpty) {
        onTime = 0;
        frames.addAll(
            AnimationStore().getFrames(StickAnimationEvent.idle, direction)!);
      }
    } else if (event == StickAnimationEvent.walk) {
      if (KeyStore().isDouble(LogicalKeyboardKey.arrowLeft)) {
        debugPrint("面向左侧，向左侧跳动");

        // TODO 向左跳跃
        // speed = -150;
        // event = StickAnimationEvent.walk;
        // direction = StickDirection.left;

        debugPrint("TODO 向左跳跃 => 向左走");
      } else if (KeyStore().isDouble(LogicalKeyboardKey.arrowRight)) {
        debugPrint("面向右侧，向右侧跳动");

        // TODO 向右跳跃
        // speed = 150;
        // event = StickAnimationEvent.walk;
        // direction = StickDirection.right;

        debugPrint("TODO 向右跳跃 => 向右走");
      } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowLeft) &&
          direction == StickDirection.left) {
        // 什么都不需要做
      } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowRight) &&
          direction == StickDirection.right) {
        // 什么都不需要做
      } else {
        onTime = 0;
        speed = 0;
        if (KeyStore().isRepeat(LogicalKeyboardKey.arrowLeft)) {
          // 向左跑
          speed = -200;
          event = StickAnimationEvent.run;
          direction = StickDirection.left;
        } else if (KeyStore().isRepeat(LogicalKeyboardKey.arrowRight)) {
          // 向右跑
          speed = 200;
          event = StickAnimationEvent.run;
          direction = StickDirection.right;
        } else {
          event = StickAnimationEvent.idle;
        }

        frames.clear();
        frames.addAll(AnimationStore().getFrames(event, direction)!);
      }
    } else if (event == StickAnimationEvent.run) {
      if (KeyStore().isDown(LogicalKeyboardKey.arrowLeft) &&
          direction == StickDirection.left) {
        // 什么都不需要做
      } else if (KeyStore().isDown(LogicalKeyboardKey.arrowRight) &&
          direction == StickDirection.right) {
        // 什么都不需要做
      } else {
        onTime = 0;
        if (KeyStore().isDown(LogicalKeyboardKey.arrowUp)) {
          speed = direction == StickDirection.left ? -200 : 200;
          event = StickAnimationEvent.jumpUp;
        } else {
          event = StickAnimationEvent.idle;
        }

        frames.clear();
        frames.addAll(AnimationStore().getFrames(event, direction)!);
      }
    }

    onTime = onTime + dt;

    final index = (onTime * designFPS).floor();
    sprite = frames[index];

    // 动作结束
    if (((onTime + dt * 5) * designFPS).floor() >= frames.length) {
      onTime = 0;
      if (event == StickAnimationEvent.jumpUp) {
        if (KeyStore().isDown(LogicalKeyboardKey.digit1)) {
          event = StickAnimationEvent.jumpHandAttack;
          KeyStore().remove(LogicalKeyboardKey.digit1);
        } else if (KeyStore().isDown(LogicalKeyboardKey.digit2)) {
          event = StickAnimationEvent.jumpFootAttack;
          KeyStore().remove(LogicalKeyboardKey.digit2);
        } else {
          event = StickAnimationEvent.jumpDown;
        }

        frames.clear();
        frames.addAll(AnimationStore().getFrames(event, direction)!);
      } else if (event == StickAnimationEvent.jumpDown ||
          event == StickAnimationEvent.jumpHandAttack ||
          event == StickAnimationEvent.jumpFootAttack) {
        event = StickAnimationEvent.idle;

        frames.clear();
        frames.addAll(AnimationStore().getFrames(event, direction)!);
      } else if (event == StickAnimationEvent.squatHalf) {
        if (KeyStore().isDown(LogicalKeyboardKey.arrowDown)) {
          event = StickAnimationEvent.squat;
        } else {
          event = StickAnimationEvent.idle;
        }

        frames.clear();
        frames.addAll(AnimationStore().getFrames(event, direction)!);
      } else if (event == StickAnimationEvent.squat) {
        if (KeyStore().isDown(LogicalKeyboardKey.digit1)) {
          event = StickAnimationEvent.squatHandAttack;
          KeyStore().remove(LogicalKeyboardKey.digit1);
        } else if (KeyStore().isDown(LogicalKeyboardKey.digit2)) {
          event = StickAnimationEvent.squatFootAttack;
          KeyStore().remove(LogicalKeyboardKey.digit2);
        } else if (KeyStore().isDown(LogicalKeyboardKey.arrowDown)) {
          event = StickAnimationEvent.squat;
        } else {
          event = StickAnimationEvent.squatHalf;
        }

        frames.clear();
        frames.addAll(AnimationStore().getFrames(event, direction)!);
      } else if (event == StickAnimationEvent.squatHandAttack ||
          event == StickAnimationEvent.squatFootAttack) {
        event = StickAnimationEvent.squat;

        frames.clear();
        frames.addAll(AnimationStore().getFrames(event, direction)!);
      }
    }

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
