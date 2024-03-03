import 'dart:convert';
import 'dart:math';

import '../index.dart';

enum StickDirection { left, right, repeat }

enum StickAnimationEvent {
  idle,
  walk,
  run,
  move,
  handAttack,
  footAttack,
  jumpUp,
  jumpDown,
  jumpHandAttack,
  jumpFootAttack,
  squatHalf,
  squat,
  squatHandAttack,
  squatFootAttack,
  skill
}

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
      StickAnimation("7002", 0, 8),
    ],
    StickAnimationEvent.footAttack: [
      StickAnimation("7001", 5, 14),
      StickAnimation("7001", 22, 33),
      StickAnimation("7002", 8, 21),
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
// TODO 改为根据方向取
    final data =
        (direction == StickDirection.left ? _data[name]! : _data[name]!);

    return AnimationFrames(
      name: name,
      width: data.width,
      height: data.height,
      size: data.size,
      frames: (direction == StickDirection.left
          ? _leftFrames[name]
          : _rightFrames[name])!,
      framesData: data.frames,
    );
  }

  AnimationFrames byEvent(StickAnimationEvent event, StickDirection direction) {
    final ele = animations[event]!;
    final animation = ele[Random.secure().nextInt(ele.length)];

// TODO 改为根据方向取
    final data = (direction == StickDirection.left
        ? _data[animation.name]!
        : _data[animation.name]!);

    return AnimationFrames(
      name: animation.name,
      width: data.width,
      height: data.height,
      size: data.size,
      frames: (direction == StickDirection.left
              ? _leftFrames[animation.name]
              : _rightFrames[animation.name])!
          .sublist(animation.start, animation.end),
      framesData: data.frames.sublist(animation.start, animation.end),
    );
  }

// 加载配置
  Future load() async {
    final js = await rootBundle.loadString('assets/animations.json');
    _data = (json.decode(js) as Map)
        .map((k, v) => MapEntry(k, AnimationData.fromJson(v)));

// 生成动画序列帧
    final kfs = _data.map((k, v) =>
        MapEntry(k, v.frames.map((f) => "${k}_${f.sequence}.png").toList()));

    for (var k in kfs.keys) {
      final fs = (await Flame.images.loadAll(kfs[k]!))
          .map((img) => SpriteComponent.fromImage(img).sprite)
          .toList();

// TODO 变成 6001_1（向左）和 6001_2（向右） 两个动画
// if (k.endsWith("_1")) {
//   leftFrames[k.substring(k.length - 2)] = frames;
// } else if (k.endsWith("_1")) {
//   rightFrames[k.substring(k.length - 2)] = frames;
// } else {
//   assert(false);
// }
      _leftFrames[k] = fs;
      _rightFrames[k] = fs;
    }
    debugPrint("animations is ${_data["9401"]}");
  }
}
