import 'dart:convert';
import 'dart:math';

import '../index.dart';

class ImagePoint {
  final int x;
  final int y;

  ImagePoint({required this.x, required this.y});

  factory ImagePoint.fromJson(Map<String, dynamic> js) =>
      ImagePoint(x: js['X'], y: js['Y']);

  @override
  String toString() => "{x:$x, y:$y}";
}

class ImageRectangle {
  final ImagePoint min;
  final ImagePoint max;

  ImageRectangle({required this.min, required this.max});

  factory ImageRectangle.fromJson(Map<String, dynamic> js) => ImageRectangle(
        min: ImagePoint.fromJson(js['Min']),
        max: ImagePoint.fromJson(js['Max']),
      );

  @override
  String toString() => "{min:$min}, max:$max}";
}

class AnimationFrame {
  final int sequence;

  final bool isLand;
  final ImagePoint position;
  final ImageRectangle size;

  final List<ImageRectangle> exposeHead;
  final List<ImageRectangle> exposeBody;
  final List<ImageRectangle> exposeHand;
  final List<ImageRectangle> exposeFoot;

  final List<ImageRectangle> attackHead;
  final List<ImageRectangle> attackBody;
  final List<ImageRectangle> attackHand;
  final List<ImageRectangle> attackFoot;

  AnimationFrame({
    required this.sequence,
    required this.isLand,
    required this.position,
    required this.size,
    required this.exposeHead,
    required this.exposeBody,
    required this.exposeHand,
    required this.exposeFoot,
    required this.attackHead,
    required this.attackBody,
    required this.attackHand,
    required this.attackFoot,
  });

  factory AnimationFrame.fromJson(Map<String, dynamic> js) => AnimationFrame(
        sequence: js["Sequence"],
        isLand: js["IsLand"],
        position: ImagePoint.fromJson(js["Position"]),
        size: ImageRectangle.fromJson(js["Size"]),
        exposeHead: (js["ExposeHead"] as List)
            .map((v) => ImageRectangle.fromJson(v))
            .toList(),
        exposeBody: (js["ExposeBody"] as List)
            .map((v) => ImageRectangle.fromJson(v))
            .toList(),
        exposeHand: (js["ExposeHand"] as List)
            .map((v) => ImageRectangle.fromJson(v))
            .toList(),
        exposeFoot: (js["ExposeFoot"] as List)
            .map((v) => ImageRectangle.fromJson(v))
            .toList(),
        attackHead: (js["AttackHead"] as List)
            .map((v) => ImageRectangle.fromJson(v))
            .toList(),
        attackBody: (js["AttackBody"] as List)
            .map((v) => ImageRectangle.fromJson(v))
            .toList(),
        attackHand: (js["AttackHand"] as List)
            .map((v) => ImageRectangle.fromJson(v))
            .toList(),
        attackFoot: (js["AttackFoot"] as List)
            .map((v) => ImageRectangle.fromJson(v))
            .toList(),
      );

  @override
  String toString() =>
      "{sequence:$sequence, isLand:$isLand, position:$position, size:$size, "
      "exposeHead:$exposeHead, exposeBody:$exposeBody, "
      "exposeHand:$exposeHand, exposeFoot:$exposeFoot, "
      "attackHead:$attackHead, attackBody:$attackBody, "
      "attackHand:$attackHand, attackFoot:$attackFoot}";
}

class AnimationData {
  final int width;
  final int height;
  final List<AnimationFrame> frames;

  AnimationData(
      {required this.width, required this.height, required this.frames});

  factory AnimationData.fromJson(Map<String, dynamic> js) => AnimationData(
        width: js["Width"],
        height: js["Height"],
        frames: (js["Frames"] as List)
            .map((v) => AnimationFrame.fromJson(v))
            .toList(),
      );

  @override
  String toString() => "{width:$width}, height:$height, frames:$frames}";
}

enum StickDirection { left, right, repeat }

enum StickAnimationEvent {
  idle,
  walk,
  run,
  runHandAttack,
  runFootAttack,
  jumpUp,
  jumpDown,
  jumpHandAttack,
  jumpFootAttack,
  squatHalf,
  squat,
  squatHandAttack,
  squatFootAttack,
}

class StickAnimation {
  final String name;
  final int start;
  final int end;

  StickAnimation(this.name, this.start, this.end);

  @override
  String toString() => "{name:$name, start:$start, end:$end}";
}

final class AnimationStore {
  static final AnimationStore _instance = AnimationStore._internal();

  factory AnimationStore() => _instance;

  AnimationStore._internal();

  late Map<String, AnimationData> data = {};
  final Map<String, List<Sprite?>> _leftFrames = {};
  final Map<String, List<Sprite?>> _rightFrames = {};

  final Map<StickAnimationEvent, List<StickAnimation>> animations = {
    StickAnimationEvent.idle: [StickAnimation("9101", 0, 6)],
    StickAnimationEvent.walk: [StickAnimation("9101", 6, 11)],
    StickAnimationEvent.run: [StickAnimation("9202", 0, 7)],
    StickAnimationEvent.jumpUp: [StickAnimation("8001", 0, 5)],
    StickAnimationEvent.jumpDown: [StickAnimation("8001", 5, 10)],
    StickAnimationEvent.jumpHandAttack: [
      StickAnimation("8001", 10, 17),
      StickAnimation("8001", 25, 34),
    ],
    StickAnimationEvent.jumpFootAttack: [
      StickAnimation("8001", 17, 25),
      StickAnimation("8001", 34, 42),
    ],
    StickAnimationEvent.squatHalf: [
      StickAnimation("9301", 0, 1),
      StickAnimation("9301", 2, 3),
    ],
    StickAnimationEvent.squat: [
      StickAnimation("9301", 1, 2),
      StickAnimation("9301", 3, 4),
    ],
    StickAnimationEvent.squatHandAttack: [
      StickAnimation("6001", 0, 4),
      StickAnimation("6001", 8, 14),
    ],
    StickAnimationEvent.squatFootAttack: [
      StickAnimation("6001", 4, 8),
      StickAnimation("6001", 14, 20),
    ],
  };

  List<Sprite?>? getFrames(
      StickAnimationEvent event, StickDirection direction) {
    final ele = animations[event]!;
    final animation = ele[Random.secure().nextInt(ele.length)];

    return (direction == StickDirection.left
            ? _leftFrames[animation.name]
            : _rightFrames[animation.name])
        ?.sublist(animation.start, animation.end);
  }

  Future load() async {
// 解析动画配置文件
    final js = await rootBundle.loadString('assets/animations.json');
    data = (json.decode(js) as Map)
        .map((k, v) => MapEntry(k, AnimationData.fromJson(v)));

// 生成动画序列帧
    final kfs = data.map((k, v) =>
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
    debugPrint("animations is ${data["6001"]}");
    debugPrint("animations is ${data["6001"]}");
  }
}
