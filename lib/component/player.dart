import 'dart:math';

import '../index.dart';

class Player extends SpriteComponent
    with HasGameReference<CitizenGame>, CollisionCallbacks {
  final Cape cape;
  final Color color;

  Player(this.cape, this.color, {super.position})
      : super(anchor: Anchor.bottomCenter, key: ComponentKey.named("Player"));

  late double onTime = 0;
  late double speedRate = 0; // 速度比
  late double speedRatio = 1.0; // 速度衰减
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

    _aniFrames = AnimationStore().byEvent(event, StickSymbol.self, direction);
    debugPrint("onLoad => $_aniFrames");
    add(
      RectangleHitbox()
        ..debugMode = true
        ..debugColor = Colors.purple,
    );

    add(ColorEffect(color, EffectController(duration: 0)));
  }

  // 接受新的键盘输入按键
  onChange() {
    final skillKey = List<LocalGameKey>.from(KeyStore().keys).where((key) =>
        SkillStore().skills.containsKey(key.key) && KeyStore().isDown(key.key));

    if (skillKey.isNotEmpty) {
      // 技能攻击
      speedRate = 0;
      skill = SkillStore().skills[skillKey.last.key]!;
      debugPrint("Skill Key ${skillKey.last.key.debugName}, Skill $skill");
      event = StickAnimationEvent.skill;
    } else if (KeyStore().isDown(AnimationStore().handAttackKey)) {
      // 手攻击
      speedRate = 0;
      event = StickAnimationEvent.handAttack;
      KeyStore().remove(AnimationStore().handAttackKey);
    } else if (KeyStore().isDown(AnimationStore().footAttackKey)) {
      // 脚攻击
      speedRate = 0;
      event = StickAnimationEvent.footAttack;
      KeyStore().remove(AnimationStore().footAttackKey);
    } else if (KeyStore().isRepeat(LogicalKeyboardKey.arrowLeft)) {
      // 向左跑
      speedRate = -2.0;
      event = StickAnimationEvent.run;
      direction = StickDirection.left;
    } else if (KeyStore().isRepeat(LogicalKeyboardKey.arrowRight)) {
      // 向右跑
      speedRate = 2.0;
      event = StickAnimationEvent.run;
      direction = StickDirection.right;
    } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowLeft)) {
      // 向左走
      speedRate = -1.0;
      event = StickAnimationEvent.walk;
      direction = StickDirection.left;
    } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowRight)) {
      // 向右走
      speedRate = 1.0;
      event = StickAnimationEvent.walk;
      direction = StickDirection.right;
    } else if (KeyStore().isDown(LogicalKeyboardKey.arrowUp)) {
      // 向上跳
      speedRate = 0;
      event = StickAnimationEvent.jumpUp;
    } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowDown)) {
      // 向下蹲
      speedRate = 0;
      event = StickAnimationEvent.squatHalf;
    }
  }

  late int dx = 0;

  AnimationFrames get aniFrames => _aniFrames;

  set aniFrames(AnimationFrames newFrames) {
    // debugPrint("$_aniFrames => $newFrames");
    if ("$newFrames" == "$_aniFrames") {
      return;
    }

    // 帧发生变化时，计算中间移动的距离差
    int index = (onTime * 12).floor();
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
      debugPrint("Player 每秒帧数降至 ${(1 / dt).toStringAsFixed(2)}");
    }

    if (event == StickAnimationEvent.idle) {
      speedRate = 0;
      onChange();

      // 重置动画序列
      if (event != StickAnimationEvent.idle) {
        onTime = 0;
        if (event == StickAnimationEvent.skill) {
          aniFrames =
              AnimationStore().byName(skill, StickSymbol.self, direction);
        } else {
          aniFrames =
              AnimationStore().byEvent(event, StickSymbol.self, direction);
        }
      }

      // 按帧播放
      if (event == StickAnimationEvent.idle) {
        aniFrames =
            AnimationStore().byEvent(event, StickSymbol.self, direction);
      }
    } else if (event == StickAnimationEvent.walk) {
      if (KeyStore().isDouble(LogicalKeyboardKey.arrowLeft)) {
        speedRate = 0;
        event = StickAnimationEvent.move;
        direction = StickDirection.left;

        aniFrames =
            AnimationStore().byEvent(event, StickSymbol.self, direction);
      } else if (KeyStore().isDouble(LogicalKeyboardKey.arrowRight)) {
        speedRate = 0;
        event = StickAnimationEvent.move;
        direction = StickDirection.right;

        aniFrames =
            AnimationStore().byEvent(event, StickSymbol.self, direction);
      } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowLeft) &&
          direction == StickDirection.left) {
        // 什么都不需要做
      } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowRight) &&
          direction == StickDirection.right) {
        // 什么都不需要做
      } else {
        onTime = 0;
        speedRate = 0;
        if (KeyStore().isRepeat(LogicalKeyboardKey.arrowLeft)) {
          // 向左跑
          speedRate = -2.0;
          event = StickAnimationEvent.run;
          direction = StickDirection.left;
        } else if (KeyStore().isRepeat(LogicalKeyboardKey.arrowRight)) {
          // 向右跑
          speedRate = 2.0;
          event = StickAnimationEvent.run;
          direction = StickDirection.right;
        } else {
          event = StickAnimationEvent.idle;
        }

        aniFrames =
            AnimationStore().byEvent(event, StickSymbol.self, direction);
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
          speedRate = direction == StickDirection.left ? -2.0 : 2.0;
          event = StickAnimationEvent.jumpUp;
        } else {
          event = StickAnimationEvent.idle;
        }

        aniFrames =
            AnimationStore().byEvent(event, StickSymbol.self, direction);
      }
    }

    onTime = onTime + dt;
    final index = (onTime * 12).floor();
    final refreshNext = index >= aniFrames.frames.length;

    sprite = refreshNext ? aniFrames.frames.last : aniFrames.frames[index];
    cape.sprite =
        refreshNext ? aniFrames.capeFrames.last : aniFrames.capeFrames[index];
    frame =
        refreshNext ? aniFrames.framesData.last : aniFrames.framesData[index];

    // Position
    position.x = position.x + speedRate * speedRatio * 100 * dt + dx;
    cape.position.x = cape.position.x + speedRate * speedRatio * 100 * dt + dx;
    dx = 0;

    refreshNext ? refresh() : ();
  }

  refresh() {
    debugPrint("refresh $event");
    if (event == StickAnimationEvent.skill) {
      event = StickAnimationEvent.idle;
      aniFrames = AnimationStore().byEvent(event, StickSymbol.self, direction);
    } else if (event == StickAnimationEvent.move) {
      event = StickAnimationEvent.idle;
      aniFrames = AnimationStore().byEvent(event, StickSymbol.self, direction);
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

        aniFrames =
            AnimationStore().byEvent(event, StickSymbol.self, direction);
      } else if (event == StickAnimationEvent.jumpDown ||
          event == StickAnimationEvent.jumpHandAttack ||
          event == StickAnimationEvent.jumpFootAttack) {
        event = StickAnimationEvent.idle;

        aniFrames =
            AnimationStore().byEvent(event, StickSymbol.self, direction);
      } else if (event == StickAnimationEvent.squatHalf) {
        if (KeyStore().isDown(LogicalKeyboardKey.arrowDown)) {
          event = StickAnimationEvent.squat;
        } else {
          event = StickAnimationEvent.idle;
        }

        aniFrames =
            AnimationStore().byEvent(event, StickSymbol.self, direction);
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

        aniFrames =
            AnimationStore().byEvent(event, StickSymbol.self, direction);
      } else if (event == StickAnimationEvent.squatHandAttack ||
          event == StickAnimationEvent.squatFootAttack) {
        event = StickAnimationEvent.squat;

        aniFrames =
            AnimationStore().byEvent(event, StickSymbol.self, direction);
      } else if (event == StickAnimationEvent.handAttack ||
          event == StickAnimationEvent.footAttack) {
        event = StickAnimationEvent.idle;

        aniFrames =
            AnimationStore().byEvent(event, StickSymbol.self, direction);
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Enemy) {
      if (other.byFrame.name == frame.name) {
        return;
      }

      final List<ImageRectangle> playerAttacks = [];
      playerAttacks.addAll(frame.attackHand);
      playerAttacks.addAll(frame.attackFoot);

      final List<ImageRectangle> enemyExpose = [];
      enemyExpose.addAll(other.frame.exposeHead);
      enemyExpose.addAll(other.frame.exposeBody);
      enemyExpose.addAll(other.frame.exposeHand);
      enemyExpose.addAll(other.frame.exposeFoot);

      // 玩家所在的世界坐标，以左下角为基点
      final p0 = position.clone()..sub(Vector2(frame.width / 2, 0));
      final p1 = other.position.clone()..sub(Vector2(frame.width / 2, 0));

      if (playerAttacks.any(
          (f0) => enemyExpose.any((f1) => (isCollision(p0, f0, p1, f1))))) {
        other.byFrame = frame;

        debugPrint("敌人被攻击，当前攻击帧序号 ${frame.name} ${frame.sequence}");
        other.direction = direction.reverse();
        other.aniFrames = AnimationStore().byNameStartEnd(aniFrames.name,
            StickSymbol.enemy, direction, frame.sequence, aniFrames.end);
      } else {
        other.byFrame = AnimationFrameData.invalid();

        // 推动敌方移动
        final List<ImageRectangle> playerExpose = [];
        playerExpose.addAll(frame.exposeHead);
        playerExpose.addAll(frame.exposeBody);
        playerExpose.addAll(frame.exposeHand);
        playerExpose.addAll(frame.exposeFoot);

        if (playerExpose.any(
            (f0) => enemyExpose.any((f1) => (isCollision(p0, f0, p1, f1))))) {
          // 推动对方，但速度减半
          if (direction == StickDirection.right) {
            // int maxX = 0;
            // aniFrames.framesData.forEach((e) {
            //   if (e.stickSize.max.x > maxX) {
            //     maxX = e.stickSize.max.x;
            //   }
            // });

            // final p0MaxX = ImagePoint(x: maxX, y: 5).toGlobal(p0).x;

            final p0MaxX = frame.stickSize.max.toGlobal(p0).x;
            final p1MinX = other.frame.stickSize.min.toGlobal(p1).x;

            // speedRate = 0.5;
            // other.speedRate = 0.5;
            other.dx = other.dx + (p0MaxX - p1MinX).toInt();
          }
          debugPrint("playerExpose Collision with enemyExpose");
        } else {
          // other.speedRate = 0;
        }
      }
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
            (min1.y - max1.y) + (min2.y - max2.y);
  }
}
