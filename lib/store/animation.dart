import 'dart:convert';

import '../index.dart';

class ImagePoint {
  final int x;
  final int y;

  ImagePoint({required this.x, required this.y});

  factory ImagePoint.fromJson(Map<String, dynamic> js) =>
      ImagePoint(x: js['X'], y: js['Y']);

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
}

final class AnimationStore {
  static final AnimationStore _instance = AnimationStore._internal();

  factory AnimationStore() => _instance;

  AnimationStore._internal();

  late Map<String, AnimationData> data = {};
  late Map<String, List<Sprite?>> leftFrames = {};
  late Map<String, List<Sprite?>> rightFrames = {};

  late Map<StickAnimationEvent, List<StickAnimation>> animations = {};

  load() async {
// 解析动画配置文件
    final js = await rootBundle.loadString('assets/animations.json');
    data = (json.decode(js) as Map)
        .map((k, v) => MapEntry(k, AnimationData.fromJson(v)));

// 生成动画序列帧
    data
        .map((k, v) =>
            MapEntry(k, v.frames.map((f) => "${k}_${f.sequence}.png").toList()))
        .forEach(
      (k, fs) async {
        final frames = (await Flame.images.loadAll(fs))
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
        leftFrames[k.substring(k.length - 2)] = frames;
        rightFrames[k.substring(k.length - 2)] = frames;
      },
    );

    debugPrint("animations is ${data["6001"]}");
    debugPrint("animations is ${leftFrames["6001"]?.length}");

// 基础动画
    animations = {
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
        StickAnimation("8001", 34, 41),
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
  }

  final Map<StickAnimationEvent, StickAnimationEvent Function()> onContinue = {
    StickAnimationEvent.idle: () {
      if (KeyStore().isLastRepeat(LogicalKeyboardKey.arrowLeft) ||
          KeyStore().isLastRepeat(LogicalKeyboardKey.arrowRight)) {
        if (KeyStore().isKey(LogicalKeyboardKey.arrowLeft)) {}
        return StickAnimationEvent.walk;
      }

      if (KeyStore().isKey(LogicalKeyboardKey.arrowLeft) ||
          KeyStore().isKey(LogicalKeyboardKey.arrowRight)) {
        if (KeyStore().isKey(LogicalKeyboardKey.arrowLeft)) {}
        return StickAnimationEvent.walk;
      }

      return StickAnimationEvent.idle;
    },
  };

  final Map<StickAnimationEvent, StickAnimationEvent Function()> onFinish = {
    StickAnimationEvent.walk: () {
      if (KeyStore().isKey(LogicalKeyboardKey.arrowLeft) ||
          KeyStore().isKey(LogicalKeyboardKey.arrowRight)) {
        return StickAnimationEvent.walk;
      }

      return StickAnimationEvent.idle;
    },
    StickAnimationEvent.run: () {
      if (KeyStore().isLastRepeat(LogicalKeyboardKey.arrowLeft) ||
          KeyStore().isLastRepeat(LogicalKeyboardKey.arrowRight)) {
        return StickAnimationEvent.run;
      }

      return StickAnimationEvent.idle;
    },
    StickAnimationEvent.jumpUp: () {
      if (KeyStore().isAnyRepeat(LogicalKeyboardKey.digit1)) {
        return StickAnimationEvent.jumpHandAttack;
      } else if (KeyStore().isAnyRepeat(LogicalKeyboardKey.digit2)) {
        return StickAnimationEvent.jumpFootAttack;
      }

      return StickAnimationEvent.jumpDown;
    },
    StickAnimationEvent.jumpDown: () => StickAnimationEvent.idle,
    StickAnimationEvent.jumpHandAttack: () => StickAnimationEvent.idle,
    StickAnimationEvent.jumpFootAttack: () => StickAnimationEvent.idle,
    StickAnimationEvent.squatHalf: () {
      if (KeyStore().isAnyRepeat(LogicalKeyboardKey.arrowDown)) {
        return StickAnimationEvent.squat;
      }

      return StickAnimationEvent.idle;
    },
    StickAnimationEvent.squat: () {
      if (KeyStore().isAnyRepeat(LogicalKeyboardKey.arrowDown)) {
        return StickAnimationEvent.squat;
      }

      return StickAnimationEvent.squatHalf;
    },
    StickAnimationEvent.squatHandAttack: () => StickAnimationEvent.squat,
    StickAnimationEvent.squatFootAttack: () => StickAnimationEvent.squat,
  };
}
