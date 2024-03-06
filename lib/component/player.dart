import 'dart:math';

import '../index.dart';

class Player extends SpriteComponent
    with HasGameReference<CitizenGame>, CollisionCallbacks {
  Player({super.position})
      : super(anchor: Anchor.bottomCenter, key: ComponentKey.named("Player"));

  final double designFPS = 12;

  late double speed = 0; // 初始速度
  late double onTime = 0;
  late AnimationFrameData frame;
  late AnimationFrames _aniFrames;

  late StickDirection direction = StickDirection.right;
  late StickAnimationEvent event = StickAnimationEvent.idle;
  late String skill;

  World get world => game.world;

  @override
  Future<void> onLoad() async {
    // 初始帧为向右站立
    final empty = await Flame.images.load("empty.png");
    sprite = SpriteComponent.fromImage(empty).sprite;

    _aniFrames = AnimationStore().byEvent(event, direction);
    add(
      RectangleHitbox()
        ..debugMode = true
        ..debugColor = Colors.purple,
    );
  }

  // 接受新的键盘输入按键
  onChange() {
    final skillKey = List<LocalGameKey>.from(KeyStore().keys).where((key) =>
        SkillStore().skills.containsKey(key.key) && KeyStore().isDown(key.key));

    if (skillKey.isNotEmpty) {
      // 技能攻击
      speed = 0;
      skill = SkillStore().skills[skillKey.last.key]!;
      debugPrint("Skill Key ${skillKey.last.key.debugName}, Skill $skill");
      event = StickAnimationEvent.skill;
    } else if (KeyStore().isDown(AnimationStore().handAttackKey)) {
      // 手攻击
      speed = 0;
      event = StickAnimationEvent.handAttack;
      KeyStore().remove(AnimationStore().handAttackKey);
    } else if (KeyStore().isDown(AnimationStore().footAttackKey)) {
      // 脚攻击
      speed = 0;
      event = StickAnimationEvent.footAttack;
      KeyStore().remove(AnimationStore().footAttackKey);
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

    late int x = 0;

    final x1 = _aniFrames.framesData.first.position.x; // 旧 开始
    final x2 = frame.position.x; // 旧 结束
    final x3 = newFrames.framesData.first.position.x; // 新 开始
    debugPrint(
        "$_aniFrames [$index] -> $newFrames x1 = $x1, x2 = $x2, x3 = $x3 ");

    x = x2 - x3;
    if (x.abs() > 20) {
      dx = dx + x;
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
    frame =
        refreshNext ? aniFrames.framesData.last : aniFrames.framesData[index];

    position.x = position.x + speed * dt + dx;
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
        if (KeyStore().isDown(AnimationStore().handAttackKey)) {
          event = StickAnimationEvent.jumpHandAttack;
          KeyStore().remove(AnimationStore().handAttackKey);
        } else if (KeyStore().isDown(AnimationStore().footAttackKey)) {
          event = StickAnimationEvent.jumpFootAttack;
          KeyStore().remove(AnimationStore().handAttackKey);
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
        if (KeyStore().isDown(AnimationStore().handAttackKey)) {
          event = StickAnimationEvent.squatHandAttack;
          KeyStore().remove(AnimationStore().handAttackKey);
        } else if (KeyStore().isDown(AnimationStore().footAttackKey)) {
          event = StickAnimationEvent.squatFootAttack;
          KeyStore().remove(AnimationStore().handAttackKey);
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
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Enemy) {
      // 玩家所在的世界坐标，以左下角为基点
      final p0 = position.clone()..sub(Vector2(frame.width / 2, 0));
      final p1 = other.position.clone()..sub(Vector2(frame.width / 2, 0));

      // frame.attackHand.any((f0) {
      //   if (other.frame.exposeHead.any((f1) => isCollision(p0, f0, p1, f1))) {
      //     debugPrint("使用手攻击对方的头部");
      //     return true;
      //   }
      //
      //   if (other.frame.exposeBody.any((f1) => isCollision(p0, f0, p1, f1))) {
      //     debugPrint("使用手攻击对方的身体");
      //     return true;
      //   }
      //
      //   if (other.frame.exposeHand.any((f1) => isCollision(p0, f0, p1, f1))) {
      //     debugPrint("使用手攻击对方的手");
      //     return true;
      //   }
      //
      //   if (other.frame.exposeFoot.any((f1) => isCollision(p0, f0, p1, f1))) {
      //     debugPrint("使用手攻击对方的脚");
      //     return true;
      //   }
      //
      //   return false;
      // });

      frame.attackFoot.any((f0) {
        if (other.frame.exposeHead.any((f1) => (isCollision(p0, f0, p1, f1)))) {
          debugPrint("使用脚攻击对方的头部");
          return true;
        }

        if (other.frame.exposeBody.any((f1) => isCollision(p0, f0, p1, f1))) {
          debugPrint("使用脚攻击对方的身体");
          return true;
        }

        if (other.frame.exposeHand.any((f1) => isCollision(p0, f0, p1, f1))) {
          debugPrint("使用脚攻击对方的手");
          return true;
        }

        if (other.frame.exposeFoot.any((f1) => isCollision(p0, f0, p1, f1))) {
          debugPrint("使用脚攻击对方的脚");
          return true;
        }

        return false;
      });
    }
  }

  bool isCollision(
      Vector2 p1, ImageRectangle rect1, Vector2 p2, ImageRectangle rect2) {
    final min1 = rect1.min.toGlobal(p1);
    final max1 = rect1.max.toGlobal(p1);

    final min2 = rect2.min.toGlobal(p2);
    final max2 = rect2.max.toGlobal(p2);

    return (max(max1.x, max2.x) - min(min1.x, min2.x)).abs() <
            (max1.x - min1.x) + (max2.x - min2.x) &&
        (max(min1.y, min2.y) - min(max1.y, max2.y)).abs() <
            (min1.x - max1.y) + (min2.y - max2.y);
  }
}
