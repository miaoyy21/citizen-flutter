
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
