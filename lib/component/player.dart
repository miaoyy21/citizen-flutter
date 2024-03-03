import 'package:citizen/store/skill.dart';

import '../index.dart';

class Player extends SpriteComponent
    with HasGameReference<CitizenGame>, CollisionCallbacks {
  Player({super.position})
      : super(anchor: Anchor.bottomLeft, key: ComponentKey.named("Player"));

  final double designFPS = 12;

  late double speed = 0; // 初始速度
  late double onTime = 0;
  late AnimationFrames _aniFrames;

  late StickDirection direction = StickDirection.right;
  late StickAnimationEvent event = StickAnimationEvent.idle;
  late String skill;

  @override
  Future<void> onLoad() async {
    // 初始帧为向右站立
    final empty = await Flame.images.load("empty.png");
    sprite = SpriteComponent.fromImage(empty).sprite;

    _aniFrames = AnimationStore().byEvent(event, direction);
  }

  // 接受新的键盘输入按键
  onChange() {
    final skillKey = List.from(KeyStore().keys)
        .where((key) =>
            SkillStore().skills.containsKey(key.key) &&
            KeyStore().isDown(key.key))
        .toList();

    if (skillKey.isNotEmpty) {
      // 技能攻击
      speed = 0;
      debugPrint("Skill Key is $skillKey");
      skill = SkillStore().skills[skillKey.last.key]!;
      event = StickAnimationEvent.skill;
    } else if (KeyStore().isDown(LogicalKeyboardKey.digit1)) {
      // 手攻击
      speed = 0;
      event = StickAnimationEvent.handAttack;
    } else if (KeyStore().isDown(LogicalKeyboardKey.digit2)) {
      // 脚攻击
      speed = 0;
      event = StickAnimationEvent.footAttack;
    } else if (KeyStore().isRepeat(LogicalKeyboardKey.arrowLeft)) {
      // 向左跑
      speed = -200;
      event = StickAnimationEvent.run;
      direction = StickDirection.left;
    } else if (KeyStore().isRepeat(LogicalKeyboardKey.arrowRight)) {
      // 向右跑
      speed = 200;
      event = StickAnimationEvent.run;
      direction = StickDirection.right;
    } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowLeft)) {
      // 向左走
      speed = -100;
      event = StickAnimationEvent.walk;
      direction = StickDirection.left;
    } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowRight)) {
      // 向右走
      speed = 100;
      event = StickAnimationEvent.walk;
      direction = StickDirection.right;
    } else if (KeyStore().isDown(LogicalKeyboardKey.arrowUp)) {
      // 向上跳
      speed = 0;
      event = StickAnimationEvent.jumpUp;
    } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowDown)) {
      // 向下蹲
      speed = 0;
      event = StickAnimationEvent.squatHalf;
    }
  }

  late int dx = 0;

  AnimationFrames get aniFrames => _aniFrames;

  set aniFrames(AnimationFrames newFrames) {
    if ("$newFrames" == "$_aniFrames") {
      return;
    }

    // 帧发生变化时，计算中间移动的距离差
    int index = (onTime * designFPS).floor();
    index = index >= _aniFrames.framesData.length
        ? _aniFrames.framesData.length - 1
        : index;
    final frame = _aniFrames.framesData[index];

    final x1 = frame.position.x;
    final x2 = _aniFrames.framesData.first.position.x;
    if (x1 - x2 > 20) {
      dx = x1 - x2;
      debugPrint("$_aniFrames -> $newFrames : $dx");
    }

    _aniFrames = newFrames;
  }

  @override
  void update(double dt) {
    if (1 / dt < 50) {
      debugPrint("每秒帧数降至 ${(1 / dt).toStringAsFixed(2)}");
    }

    if (event == StickAnimationEvent.idle) {
      speed = 0;
      onChange();

      // 重置动画序列
      if (event != StickAnimationEvent.idle) {
        onTime = 0;
        if (event == StickAnimationEvent.skill) {
          aniFrames = AnimationStore().byName(skill, direction);
        } else {
          aniFrames = AnimationStore().byEvent(event, direction);
        }
      }

      // 按帧播放
      if (event == StickAnimationEvent.idle) {
        aniFrames = AnimationStore().byEvent(event, direction);
      }
    } else if (event == StickAnimationEvent.walk) {
      if (KeyStore().isDouble(LogicalKeyboardKey.arrowLeft)) {
        speed = 0;
        event = StickAnimationEvent.move;
        direction = StickDirection.left;

        aniFrames = AnimationStore().byEvent(event, direction);
      } else if (KeyStore().isDouble(LogicalKeyboardKey.arrowRight)) {
        speed = 0;
        event = StickAnimationEvent.move;
        direction = StickDirection.right;

        aniFrames = AnimationStore().byEvent(event, direction);
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

        aniFrames = AnimationStore().byEvent(event, direction);
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

        aniFrames = AnimationStore().byEvent(event, direction);
      }
    }

    onTime = onTime + dt;
    final index = (onTime * designFPS).floor();
    final refreshNext = index >= aniFrames.frames.length;

    sprite = refreshNext ? aniFrames.frames.last : aniFrames.frames[index];
    position.x = position.x + speed * dt + dx;
    // if (dx != 0) {
    //   final Camera? camera = game.findByKey(ComponentKey.named("Camera"));
    //   if (camera != null) {
    //     camera.dx = dx;
    //   }
    // }
    dx = 0;

    refreshNext ? refresh() : ();
  }

  refresh() {
    if (event == StickAnimationEvent.skill) {
      event = StickAnimationEvent.idle;
      aniFrames = AnimationStore().byEvent(event, direction);
    } else if (event == StickAnimationEvent.move) {
      event = StickAnimationEvent.idle;
      aniFrames = AnimationStore().byEvent(event, direction);
    } else {
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

        aniFrames = AnimationStore().byEvent(event, direction);
      } else if (event == StickAnimationEvent.jumpDown ||
          event == StickAnimationEvent.jumpHandAttack ||
          event == StickAnimationEvent.jumpFootAttack) {
        event = StickAnimationEvent.idle;

        aniFrames = AnimationStore().byEvent(event, direction);
      } else if (event == StickAnimationEvent.squatHalf) {
        if (KeyStore().isDown(LogicalKeyboardKey.arrowDown)) {
          event = StickAnimationEvent.squat;
        } else {
          event = StickAnimationEvent.idle;
        }

        aniFrames = AnimationStore().byEvent(event, direction);
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

        aniFrames = AnimationStore().byEvent(event, direction);
      } else if (event == StickAnimationEvent.squatHandAttack ||
          event == StickAnimationEvent.squatFootAttack) {
        event = StickAnimationEvent.squat;

        aniFrames = AnimationStore().byEvent(event, direction);
      } else if (event == StickAnimationEvent.handAttack ||
          event == StickAnimationEvent.footAttack) {
        event = StickAnimationEvent.idle;

        aniFrames = AnimationStore().byEvent(event, direction);
      }
    }
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
