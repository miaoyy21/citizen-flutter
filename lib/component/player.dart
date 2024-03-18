import '../index.dart';

class Player extends SpriteComponent
    with HasGameReference<CitizenGame>, CollisionCallbacks {
  final Stage stage;

  final StickCape cape;
  final StickEffect effect;
  final Color color;

  Player(this.stage, this.cape, this.effect, this.color, {super.position})
      : super(anchor: Anchor.bottomCenter, key: ComponentKey.named("Player"));

  late double onTime = 0;
  late double speedRate = 0;
  late AnimationFrameData frame;
  late AnimationFrames _aniFrames;

  late StickDirection direction = StickDirection.right;
  late StickAnimationEvent event = StickAnimationEvent.idle;
  late AnimationFrames idle;
  late String skill;

  World get world => game.world;

  @override
  Future<void> onLoad() async {
    // 初始帧为向右站立
    final empty = await Flame.images.load("empty.png");
    sprite = SpriteComponent.fromImage(empty).sprite;

    idle = AnimationStore().byEvent(event, StickSymbol.self, direction);
    _aniFrames = idle;
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

      event = StickAnimationEvent.skill;
      aniFrames = AnimationStore().byName(skill, StickSymbol.self, direction);

      final prepareFrame =
          aniFrames.framesData.firstWhere((v) => v.step == StickStep.prepare);
      final hitFrame =
          aniFrames.framesData.firstWhere((v) => v.step == StickStep.hit);
      debugPrint("技能快捷键 ${skillKey.last.key.debugName} , "
          "技能编号 $skill ，"
          "攻击距离 ${((stage.prepareSpeedRate * stage.speed / stage.fps) * (hitFrame.sequence - prepareFrame.sequence)).toStringAsFixed(2)} ");
    } else {
      speedRate = 0;
      if (KeyStore().isRepeat(LogicalKeyboardKey.arrowLeft)) {
        // 向左跑
        speedRate = -stage.runSpeedRate;
        event = StickAnimationEvent.run;
        direction = StickDirection.left;
      } else if (KeyStore().isRepeat(LogicalKeyboardKey.arrowRight)) {
        // 向右跑
        speedRate = stage.runSpeedRate;
        event = StickAnimationEvent.run;
        direction = StickDirection.right;
      } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowLeft)) {
        // 向左走
        speedRate = -stage.walkSpeedRate;
        event = StickAnimationEvent.walk;
        direction = StickDirection.left;
      } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowRight)) {
        // 向右走
        speedRate = stage.walkSpeedRate;
        event = StickAnimationEvent.walk;
        direction = StickDirection.right;
      } else if (KeyStore().isDown(LogicalKeyboardKey.arrowUp)) {
        // 向上跳
        event = StickAnimationEvent.jump;
      } else {
        event = StickAnimationEvent.idle;
      }

      aniFrames = AnimationStore().byEvent(event, StickSymbol.self, direction);
    }
  }

  late int dx = 0;

  AnimationFrames get aniFrames => _aniFrames;

  set aniFrames(AnimationFrames newFrames) {
    if ("$newFrames" == "$_aniFrames") {
      return;
    }

    // 帧发生变化时，计算中间移动的距离差
    int index = (onTime * stage.fps).floor();
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

    onTime = 0;
    _aniFrames = newFrames;
  }

  @override
  void update(double dt) {
    if (1 / dt < 50) {
      debugPrint("Player 每秒帧数降至 ${(1 / dt).toStringAsFixed(2)}");
    }

    if (event == StickAnimationEvent.idle) {
      onChange();
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
        if (KeyStore().isRepeat(LogicalKeyboardKey.arrowLeft)) {
          // 向左跑
          speedRate = -stage.runSpeedRate;
          event = StickAnimationEvent.run;
          direction = StickDirection.left;

          aniFrames =
              AnimationStore().byEvent(event, StickSymbol.self, direction);
        } else if (KeyStore().isRepeat(LogicalKeyboardKey.arrowRight)) {
          // 向右跑
          speedRate = stage.runSpeedRate;
          event = StickAnimationEvent.run;
          direction = StickDirection.right;

          aniFrames =
              AnimationStore().byEvent(event, StickSymbol.self, direction);
        } else {
          speedRate = 0;
          event = StickAnimationEvent.idle;
          aniFrames = idle;

          onChange();
        }
      }
    } else if (event == StickAnimationEvent.run) {
      if (KeyStore().isDown(LogicalKeyboardKey.arrowLeft) &&
          direction == StickDirection.left) {
        // 什么都不需要做
      } else if (KeyStore().isDown(LogicalKeyboardKey.arrowRight) &&
          direction == StickDirection.right) {
        // 什么都不需要做
      } else {
        if (KeyStore().isDown(LogicalKeyboardKey.arrowUp)) {
          event = StickAnimationEvent.jump;

          aniFrames =
              AnimationStore().byEvent(event, StickSymbol.self, direction);
        } else {
          event = StickAnimationEvent.idle;
          aniFrames = idle;

          onChange();
        }
      }
    } else if (event == StickAnimationEvent.skill) {
      final index = ((onTime + dt) * stage.fps).floor();
      if (index < aniFrames.frames.length) {
        speedRate = 0;

        final newFrame = aniFrames.framesData[index];
        if (newFrame.step == StickStep.prepare) {
          speedRate = direction == StickDirection.left
              ? -stage.prepareSpeedRate
              : stage.prepareSpeedRate;

          // 第1个攻击帧
          final hitIndex =
              aniFrames.framesData.indexWhere((v) => v.step == StickStep.hit);
          if (hitIndex >= 0) {
            final hitFrame = aniFrames.framesData.elementAt(hitIndex);
            final enemy = stage.isPlayerCollision(hitFrame);
            if (enemy != null) {
              debugPrint(
                  "攻击准备中：检测到可攻击敌方单位 ${enemy.id} ，当前帧序号${index + 1}，跳转至攻击帧${hitFrame.sequence}");

              // 跳转到攻击帧
              aniFrames = AnimationStore().byNameStartEnd(
                  aniFrames.name,
                  StickSymbol.self,
                  direction,
                  hitFrame.sequence - 1,
                  aniFrames.end);

              // 让敌方单位与玩家的帧同步
              enemy.aniFrames = AnimationStore().byNameStartEnd(
                  aniFrames.name,
                  StickSymbol.enemy,
                  direction,
                  hitFrame.sequence - 1,
                  aniFrames.end);
              enemy.direction = direction.reverse();
              enemy.dx = position.x - enemy.position.x;
            }
          }
        } else if (newFrame.step == StickStep.hit) {
          final enemy = stage.isPlayerCollision(frame);
          if (enemy != null) {
            debugPrint("攻击进行中：检测到可攻击敌方单位 ${enemy.id} ，当前攻击帧${frame.sequence}");

            // 跳转到攻击帧
            aniFrames = AnimationStore().byNameStartEnd(aniFrames.name,
                StickSymbol.self, direction, frame.sequence - 1, aniFrames.end);

            // 让敌方单位与玩家的帧同步
            enemy.aniFrames = AnimationStore().byNameStartEnd(
                aniFrames.name,
                StickSymbol.enemy,
                direction,
                frame.sequence - 1,
                aniFrames.end);
            enemy.direction = direction.reverse();
            enemy.dx = position.x - enemy.position.x;
          }
        }
      }
    }

    onTime = onTime + dt;
    final index = (onTime * stage.fps).floor();

    // Frame
    final refreshNext = index >= aniFrames.frames.length;
    frame =
        refreshNext ? aniFrames.framesData.last : aniFrames.framesData[index];

    // Sprite
    sprite = refreshNext ? aniFrames.frames.last : aniFrames.frames[index];
    cape.sprite =
        refreshNext ? aniFrames.capeFrames.last : aniFrames.capeFrames[index];
    if (aniFrames.effectFrames!.isNotEmpty) {
      effect.sprite = refreshNext
          ? aniFrames.effectFrames?.last
          : aniFrames.effectFrames?[index];
    }

    // Position
    position.x = position.x + speedRate * stage.speed * dt + dx;
    cape.position = position;
    effect.position = position;
    dx = 0;

    refreshNext ? onNext() : ();
  }

  onNext() {
    if (event == StickAnimationEvent.skill) {
      event = StickAnimationEvent.idle;
      aniFrames = idle;

      onChange();
    } else if (event == StickAnimationEvent.move) {
      event = StickAnimationEvent.idle;
      aniFrames = idle;

      onChange();
    } else {
      if (event == StickAnimationEvent.jump) {
        event = StickAnimationEvent.idle;
        aniFrames = idle;

        onChange();
      } else {
        onTime = 0;
      }
    }
  }
}
