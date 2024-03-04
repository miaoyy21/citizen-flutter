import 'dart:convert';
import 'dart:math';

import '../index.dart';

class StickAnimation {
  final String name;
  final int start;
  final int end;

  StickAnimation(this.name, this.start, this.end);

  @override
  String toString() => "{name:$name, start:$start, end:$end}";
}

class AnimationStore {
  static final AnimationStore _instance = AnimationStore._internal();

  factory AnimationStore() => _instance;

  AnimationStore._internal();

  late Map<String, AnimationData> _data = {};
  final Map<String, List<Sprite?>> _leftFrames = {};
  final Map<String, List<Sprite?>> _rightFrames = {};

  late LogicalKeyboardKey handAttackKey;
  late LogicalKeyboardKey footAttackKey;

  final Map<StickAnimationEvent, List<StickAnimation>> animations = {
    StickAnimationEvent.idle: [StickAnimation("9101", 0, 6)],
    StickAnimationEvent.walk: [StickAnimation("9101", 6, 11)],
    StickAnimationEvent.run: [StickAnimation("9202", 0, 7)],
    StickAnimationEvent.move: [
      StickAnimation("9401", 0, 12),
      StickAnimation("9402", 0, 11),
    ],
    StickAnimationEvent.handAttack: [
      StickAnimation("7001", 0, 5),
      StickAnimation("7001", 14, 22),
      StickAnimation("7002", 0, 7),
    ],
    StickAnimationEvent.footAttack: [
      StickAnimation("7001", 5, 14),
      StickAnimation("7001", 22, 33),
      StickAnimation("7002", 7, 20),
    ],
    StickAnimationEvent.jumpUp: [StickAnimation("8001", 0, 5)],
    StickAnimationEvent.jumpDown: [StickAnimation("8001", 5, 11)],
    StickAnimationEvent.jumpHandAttack: [
      StickAnimation("8001", 11, 19),
      StickAnimation("8001", 26, 34),
    ],
    StickAnimationEvent.jumpFootAttack: [
      StickAnimation("8001", 19, 26),
      StickAnimation("8001", 34, 42),
    ],
    StickAnimationEvent.squatHalf: [StickAnimation("9301", 0, 1)],
    StickAnimationEvent.squat: [StickAnimation("9301", 1, 2)],
    StickAnimationEvent.squatHandAttack: [
      StickAnimation("6001", 0, 4),
      StickAnimation("6001", 8, 14),
    ],
    StickAnimationEvent.squatFootAttack: [
      StickAnimation("6001", 4, 8),
      StickAnimation("6001", 14, 20),
    ],
  };

  AnimationFrames byName(String name, StickDirection direction) {
    final data = _data[name]!;

    return AnimationFrames(
      name: name,
      direction: direction,
      width: data.width,
      height: data.height,
      size: data.size,
      frames: (direction == StickDirection.left
          ? _leftFrames[name]
          : _rightFrames[name])!,
      framesData:
          direction == StickDirection.left ? data.leftFrames : data.rightFrames,
    );
  }

  AnimationFrames byEvent(StickAnimationEvent event, StickDirection direction) {
    final ele = animations[event]!;
    final animation = ele[Random.secure().nextInt(ele.length)];

    final data = _data[animation.name]!;

    return AnimationFrames(
      name: animation.name,
      direction: direction,
      width: data.width,
      height: data.height,
      size: data.size,
      frames: (direction == StickDirection.left
              ? _leftFrames[animation.name]
              : _rightFrames[animation.name])!
          .sublist(animation.start, animation.end),
      framesData: (direction == StickDirection.left
              ? data.leftFrames
              : data.rightFrames)
          .sublist(animation.start, animation.end),
    );
  }

  // 加载配置
  Future load(LogicalKeyboardKey handKey, LogicalKeyboardKey footKey) async {
    final js = await rootBundle.loadString('assets/animations.json');
    _data = (json.decode(js) as Map)
        .map((k, v) => MapEntry(k, AnimationData.fromJson(v)));

    // 左动画帧
    final leftFs = _data.map((k, v) => MapEntry(
        k, v.leftFrames.map((f) => "0_1_${k}_${f.sequence}.png").toList()));
    for (var k in leftFs.keys) {
      final fs = (await Flame.images.loadAll(leftFs[k]!))
          .map((img) => SpriteComponent.fromImage(img).sprite)
          .toList();

      _leftFrames[k] = fs;
    }

    // 右动画帧
    final rightFs = _data.map((k, v) => MapEntry(
        k, v.rightFrames.map((f) => "0_2_${k}_${f.sequence}.png").toList()));
    for (var k in rightFs.keys) {
      final fs = (await Flame.images.loadAll(rightFs[k]!))
          .map((img) => SpriteComponent.fromImage(img).sprite)
          .toList();

      _rightFrames[k] = fs;
    }

    // 设置手脚攻击按键
    handAttackKey = handKey;
    footAttackKey = footKey;

    debugPrint("加载动画帧完成");
  }
}
