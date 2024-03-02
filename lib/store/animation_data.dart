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

  AnimationFrameData({
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
  });

  factory AnimationFrameData.fromJson(Map<String, dynamic> js) =>
      AnimationFrameData(
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
      );

  @override
  String toString() =>
      "{sequence:$sequence, isLand:$isLand, position:$position, size:$size, stickSize:$stickSize,"
      "exposeHead:$exposeHead, exposeBody:$exposeBody, "
      "exposeHand:$exposeHand, exposeFoot:$exposeFoot, "
      "attackHead:$attackHead, attackBody:$attackBody, "
      "attackHand:$attackHand, attackFoot:$attackFoot}";
}

class AnimationData {
  final int width;
  final int height;
  final ImageRectangle size;
  final List<AnimationFrameData> frames;

  AnimationData(
      {required this.width,
      required this.height,
      required this.size,
      required this.frames});

  factory AnimationData.fromJson(Map<String, dynamic> js) => AnimationData(
        width: js["Width"],
        height: js["Height"],
        size: ImageRectangle.fromJson(js["Size"]),
        frames: (js["Frames"] as List)
            .map((v) => AnimationFrameData.fromJson(v))
            .toList(),
      );

  @override
  String toString() => "{width:$width}, height:$height, frames:$frames}";
}

class AnimationFrames {
  final String name;
  final int width;
  final int height;

  final List<Sprite?> frames;
  final List<AnimationFrameData> framesData;

  AnimationFrames(
      {required this.name,
      required this.width,
      required this.height,
      required this.frames,
      required this.framesData});
}
