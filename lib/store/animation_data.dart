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

class AnimationFrameData {
  final String name;
  final StickSymbol symbol;
  final StickDirection direction;
  final StickStep step;
  final int width;
  final int height;
  final int sequence;

  final bool isLand;
  final ImagePoint position;
  final ImageRectangle stickSize;

  final List<ImageRectangle> exposeHead;
  final List<ImageRectangle> exposeBody;
  final List<ImageRectangle> exposeHand;
  final List<ImageRectangle> exposeFoot;

  final List<ImageRectangle> attackHand;
  final List<ImageRectangle> attackFoot;

  AnimationFrameData({
    required this.name,
    required this.symbol,
    required this.direction,
    required this.step,
    required this.width,
    required this.height,
    required this.sequence,
    required this.isLand,
    required this.position,
    required this.stickSize,
    required this.exposeHead,
    required this.exposeBody,
    required this.exposeHand,
    required this.exposeFoot,
    required this.attackHand,
    required this.attackFoot,
  });

  bool get isValid => name != "0000";

  factory AnimationFrameData.invalid() => AnimationFrameData(
        name: "0000",
        symbol: StickSymbol.self,
        direction: StickDirection.repeat,
        step: StickStep.start,
        width: 0,
        height: 0,
        sequence: 0,
        isLand: false,
        position: ImagePoint(x: 0, y: 0),
        stickSize: ImageRectangle(
            min: ImagePoint(x: 0, y: 0), max: ImagePoint(x: 0, y: 0)),
        exposeHead: [],
        exposeBody: [],
        exposeHand: [],
        exposeFoot: [],
        attackHand: [],
        attackFoot: [],
      );

  factory AnimationFrameData.fromJson(Map<String, dynamic> js) =>
      AnimationFrameData(
        name: js["Name"],
        symbol: js["Symbol"] == "self" ? StickSymbol.self : StickSymbol.enemy,
        direction: js["Direction"] == "left"
            ? StickDirection.left
            : StickDirection.right,
        step: js["Step"] == "start"
            ? StickStep.start
            : js["Step"] == "prepare"
                ? StickStep.prepare
                : js["Step"] == "hit"
                    ? StickStep.hit
                    : StickStep.finish,
        width: js["Width"],
        height: js["Height"],
        sequence: js["Sequence"],
        isLand: js["IsLand"],
        position: ImagePoint.fromJson(js["Position"]),
        stickSize: ImageRectangle.fromJson(js["StickSize"]),
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
        attackHand: (js["AttackHand"] as List)
            .map((v) => ImageRectangle.fromJson(v))
            .toList(),
        attackFoot: (js["AttackFoot"] as List)
            .map((v) => ImageRectangle.fromJson(v))
            .toList(),
      );

  @override
  String toString() => "{name:$name, symbol:$symbol, direction:$direction, "
      "step:$step, width:$width, height:$height, "
      "sequence:$sequence, isLand:$isLand, "
      "position:$position, stickSize:$stickSize, "
      "exposeHead:$exposeHead, exposeBody:$exposeBody, "
      "exposeHand:$exposeHand, exposeFoot:$exposeFoot, "
      "attackHand:$attackHand, attackFoot:$attackFoot}";
}

class AnimationData {
  final int width;
  final int height;
  final int distance;
  final bool breakPrepare;
  final List<AnimationFrameData> leftSelfFrames;
  final List<AnimationFrameData> leftEnemyFrames;
  final List<AnimationFrameData> rightSelfFrames;
  final List<AnimationFrameData> rightEnemyFrames;

  final Map<String, String> files;

  AnimationData({
    required this.width,
    required this.height,
    required this.distance,
    required this.breakPrepare,
    required this.leftSelfFrames,
    required this.leftEnemyFrames,
    required this.rightSelfFrames,
    required this.rightEnemyFrames,
    required this.files,
  });

  factory AnimationData.fromJson(Map<String, dynamic> js) => AnimationData(
        width: js["Width"],
        height: js["Height"],
        distance: js["Distance"],
        breakPrepare: js["BreakPrepare"],
        leftSelfFrames: (js["LeftSelfFrames"] as List)
            .map((v) => AnimationFrameData.fromJson(v))
            .toList(),
        leftEnemyFrames: (js["LeftEnemyFrames"] as List)
            .map((v) => AnimationFrameData.fromJson(v))
            .toList(),
        rightSelfFrames: (js["RightSelfFrames"] as List)
            .map((v) => AnimationFrameData.fromJson(v))
            .toList(),
        rightEnemyFrames: (js["RightEnemyFrames"] as List)
            .map((v) => AnimationFrameData.fromJson(v))
            .toList(),
        files: (js["Files"] as Map).map((k, v) => MapEntry("$k", "$v")),
      );

  @override
  String toString() =>
      "{width:$width}, height:$height, distance:$distance, breakPrepare:$breakPrepare, "
      "leftSelfFrames:$leftSelfFrames, leftEnemyFrames:$leftEnemyFrames, "
      "rightSelfFrames:$rightSelfFrames, rightEnemyFrames:$rightEnemyFrames, files:$files}";
}

class AnimationFrames {
  final String name;
  final StickDirection direction;
  final int start;
  final int end;
  final int distance;
  final int width;
  final int height;
  final bool breakPrepare;
  final List<Sprite?> frames;
  final List<AnimationFrameData> framesData;

  final List<Sprite?> capeFrames; // 披风
  final List<Sprite?>? effectFrames; // 特效

  AnimationFrames({
    required this.name,
    required this.direction,
    required this.start,
    required this.end,
    required this.distance,
    required this.width,
    required this.height,
    required this.breakPrepare,
    required this.frames,
    required this.framesData,
    required this.capeFrames,
    required this.effectFrames,
  });

  @override
  String toString() => "$name:[${direction.asString()}]:[$start,$end]";
}
