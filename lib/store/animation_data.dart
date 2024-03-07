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
  final StickDirection direction;
  final int width;
  final int height;
  final int sequence;

  final bool isLand;
  final ImagePoint position;
  final ImageRectangle size;
  final ImageRectangle stickSize;

  final List<ImageRectangle> exposeHead;
  final List<ImageRectangle> exposeBody;
  final List<ImageRectangle> exposeHand;
  final List<ImageRectangle> exposeFoot;

  final List<ImageRectangle> attackHead;
  final List<ImageRectangle> attackBody;
  final List<ImageRectangle> attackHand;
  final List<ImageRectangle> attackFoot;

  final ImagePoint attackPoint;

  AnimationFrameData({
    required this.name,
    required this.direction,
    required this.width,
    required this.height,
    required this.sequence,
    required this.isLand,
    required this.position,
    required this.size,
    required this.stickSize,
    required this.exposeHead,
    required this.exposeBody,
    required this.exposeHand,
    required this.exposeFoot,
    required this.attackHead,
    required this.attackBody,
    required this.attackHand,
    required this.attackFoot,
    required this.attackPoint,
  });

  bool get isValid => name != "0000";

  factory AnimationFrameData.invalid() => AnimationFrameData(
        name: "0000",
        direction: StickDirection.repeat,
        width: 0,
        height: 0,
        sequence: 0,
        isLand: false,
        position: ImagePoint(x: 0, y: 0),
        size: ImageRectangle(
            min: ImagePoint(x: 0, y: 0), max: ImagePoint(x: 0, y: 0)),
        stickSize: ImageRectangle(
            min: ImagePoint(x: 0, y: 0), max: ImagePoint(x: 0, y: 0)),
        exposeHead: [],
        exposeBody: [],
        exposeHand: [],
        exposeFoot: [],
        attackHead: [],
        attackBody: [],
        attackHand: [],
        attackFoot: [],
        attackPoint: ImagePoint(x: 0, y: 0),
      );

  factory AnimationFrameData.fromJson(Map<String, dynamic> js) =>
      AnimationFrameData(
          name: js["Name"],
          direction: js["Direction"] == "1"
              ? StickDirection.left
              : StickDirection.right,
          width: js["Width"],
          height: js["Height"],
          sequence: js["Sequence"],
          isLand: js["IsLand"],
          position: ImagePoint.fromJson(js["Position"]),
          size: ImageRectangle.fromJson(js["Size"]),
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
          attackPoint: ImagePoint.fromJson(js["AttackPoint"]));

  @override
  String toString() =>
      "{name:$name, direction:$direction, width:$width, height:$height, "
      "sequence:$sequence, isLand:$isLand, "
      "position:$position, size:$size, stickSize:$stickSize,"
      "exposeHead:$exposeHead, exposeBody:$exposeBody, "
      "exposeHand:$exposeHand, exposeFoot:$exposeFoot, "
      "attackHead:$attackHead, attackBody:$attackBody, "
      "attackHand:$attackHand, attackFoot:$attackFoot}";
}

class AnimationData {
  final int width;
  final int height;
  final ImageRectangle size;
  final List<AnimationFrameData> leftFrames;
  final List<AnimationFrameData> rightFrames;

  AnimationData(
      {required this.width,
      required this.height,
      required this.size,
      required this.leftFrames,
      required this.rightFrames});

  factory AnimationData.fromJson(Map<String, dynamic> js) => AnimationData(
        width: js["Width"],
        height: js["Height"],
        size: ImageRectangle.fromJson(js["Size"]),
        leftFrames: (js["LeftFrames"] as List)
            .map((v) => AnimationFrameData.fromJson(v))
            .toList(),
        rightFrames: (js["RightFrames"] as List)
            .map((v) => AnimationFrameData.fromJson(v))
            .toList(),
      );

  @override
  String toString() =>
      "{width:$width}, height:$height, leftFrames:$leftFrames, rightFrames:$rightFrames}";
}

class AnimationFrames {
  final String name;
  final StickDirection direction;
  final int width;
  final int height;
  final ImageRectangle size;

  final List<Sprite?> frames;
  final List<AnimationFrameData> framesData;

  AnimationFrames(
      {required this.name,
      required this.direction,
      required this.width,
      required this.height,
      required this.size,
      required this.frames,
      required this.framesData});

  @override
  String toString() =>
      "$name:[${direction == StickDirection.left ? "1" : "2"}]:[${framesData.first.sequence},${framesData.last.sequence}]";
}
