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

  CameraComponent get camera => game.camera;

  @override
  Future<void> onLoad() async {
    // 初始帧为向右站立
    final empty = await Flame.images.load("empty.png");
    sprite = SpriteComponent.fromImage(empty).sprite;

    idle = AnimationStore().byEvent(event, StickSymbol.self, direction);
    _aniFrames = idle;
    frame = _aniFrames.framesData.first;
    debugPrint("onLoad => $_aniFrames");
    add(
      RectangleHitbox()
        ..debugMode = true
        ..debugColor = Colors.purple,
    );

    add(ColorEffect(color, EffectController(duration: 0)));
  }

  bool onSkill() {
    final skillKey = List<LocalGameKey>.from(KeyStore().keys).where((key) =>
        SkillStore().skills.containsKey(key.key) && KeyStore().isDown(key.key));

    // 技能攻击
    if (skillKey.isNotEmpty) {
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
          "攻击距离 ${((stage.prepareSpeedRate * AnimationStore().getPrepareRate(aniFrames) * stage.speed / stage.fps) * (hitFrame.sequence - prepareFrame.sequence)).toStringAsFixed(2)} ");

      return true;
    }

    return false;
  }

  // 接受新的键盘输入按键
  onChange() {
    final isSkill = onSkill();
    if (!isSkill) {
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
    if (x.abs() > 10) {
      dx = dx + x;
    }

    onTime = 0;
    _aniFrames = newFrames;

    /*** TODO 释放技能判定
     * 在玩家释放技能处于Finished阶段，
     * 可在接触地面的前一帧刷新时检测是否可释放新的技能，
     * 释放新的技能如果帧数小于9帧，直接进入新技能的Prepare阶段 ***/

    /*** TODO 攻击判定
     * 在释放技能的Start、Prepare和Finished阶段，可以收到敌方单位的攻击中断，
     * 在释放技能的Hit阶段，无法被敌方单位的技能中断，
     * 在被攻击过程中，可以被其他敌方单位再次攻击，
     ***/

    /*** TODO 被攻击判定
     * 在被攻击结束后，如果玩家躺在地上（玩家尺寸的Y轴坐标点小于或等于55），那么进入倒地站起来动画
     ***/
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
    } else if (event == StickAnimationEvent.move) {
      final index =
          aniFrames.framesData.indexWhere((f) => f.sequence == frame.sequence);

      // 滚地过程中释放技能
      if (index >= 3) onSkill();
    } else if (event == StickAnimationEvent.skill) {
      final index = ((onTime + dt) * stage.fps).floor();
      if (index < aniFrames.frames.length) {
        speedRate = 0;

        final newFrame = aniFrames.framesData[index];
        if (newFrame.step == StickStep.prepare) {
          speedRate = (direction == StickDirection.left
                  ? -stage.prepareSpeedRate
                  : stage.prepareSpeedRate) *
              AnimationStore().getPrepareRate(aniFrames);

          // 第1个攻击帧
          final hitIndex =
              aniFrames.framesData.indexWhere((v) => v.step == StickStep.hit);
          if (hitIndex >= 0) {
            final hitFrame = aniFrames.framesData.elementAt(hitIndex);
            final enemy = stage.isPlayerCollision(hitFrame);
            if (enemy != null) {
              if (!aniFrames.breakPrepare) {
                debugPrint(
                    "攻击准备中：检测到可攻击敌方单位 ${enemy.id} ，当前帧序号${index + 1}，不可跳过准备阶段，移动速度设为0");
                speedRate = 0;
              } else {
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

                // 修改层次
                final last = game.children.last;
                priority = last.priority + 1;
                cape.priority = last.priority + 2;
                effect.priority = last.priority + 3;
              }
            }
          }
        } else if (newFrame.step == StickStep.hit) {
          final enemy = stage.isPlayerCollision(frame);
          if (enemy != null) {
            // 跳转到攻击帧
            aniFrames = AnimationStore().byNameStartEnd(aniFrames.name,
                StickSymbol.self, direction, frame.sequence - 1, aniFrames.end);

            // 获取敌方单位的攻击结束帧
            final enemyFinished = AnimationStore()
                .byName(aniFrames.name, StickSymbol.enemy, direction)
                .framesData
                .lastIndexWhere((f) =>
                    f.sequence > frame.sequence && f.exposeBody.isNotEmpty);

            debugPrint("攻击进行中：检测到可攻击敌方单位 ${enemy.id} ，"
                "当前攻击帧${frame.sequence}，攻击结束帧${enemyFinished + 1}");

            // 让敌方单位与玩家的帧同步
            enemy.aniFrames = AnimationStore().byNameStartEnd(
                aniFrames.name,
                StickSymbol.enemy,
                direction,
                frame.sequence - 1,
                enemyFinished + 1);
            enemy.direction = direction.reverse();
            enemy.dx = position.x - enemy.position.x;

            // 修改层次
            final last = game.children.last;
            priority = last.priority + 1;
            cape.priority = last.priority + 2;
            effect.priority = last.priority + 3;
          }
        }
      }
    }

    final lastIndex = (onTime * stage.fps).floor();

    onTime = onTime + dt;
    final index = (onTime * stage.fps).floor();
    if (lastIndex != index) {
      // 播放挥舞动作
      final soundSwing = SoundStore()
          .sound(aniFrames.name, frame.sequence, SoundCategory.swing);
      if (soundSwing != null) {
        debugPrint("Play Swing Audio $soundSwing");
        FlameAudio.play(soundSwing, volume: 0.5);
      }

      final soundBlow = SoundStore()
          .sound(aniFrames.name, frame.sequence, SoundCategory.attack);
      if (soundBlow != null) {
        debugPrint("Play Blow Audio $soundBlow");
        FlameAudio.play(soundBlow, volume: 0.5);
      }
    }

    // Frame
    final refreshNext = index >= aniFrames.frames.length;
    frame =
        refreshNext ? aniFrames.framesData.last : aniFrames.framesData[index];

    // Sprite
    sprite = refreshNext ? aniFrames.frames.last : aniFrames.frames[index];
    cape.sprite =
        refreshNext ? aniFrames.capeFrames.last : aniFrames.capeFrames[index];
    if (aniFrames.effectFrames != null && aniFrames.effectFrames!.isNotEmpty) {
      effect.sprite = refreshNext
          ? aniFrames.effectFrames?.last
          : aniFrames.effectFrames?[index];
    } else {
      effect.sprite = null;
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
