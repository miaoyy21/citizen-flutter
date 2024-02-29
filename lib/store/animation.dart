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

class AnimationStore {
  static final AnimationStore _instance = AnimationStore._internal();

  factory AnimationStore() => _instance;

  AnimationStore._internal();

  late Map<String, AnimationData> data = {};
  late Map<String, List<Sprite?>> frames = {};

  // TODO 可将动画编号 6001，变成 6001_1（向左）和 6001_2（向右） 两个动画
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
        frames[k] = (await Flame.images.loadAll(fs))
            .map((img) => SpriteComponent.fromImage(img).sprite)
            .toList();
      },
    );

    debugPrint("animations is ${data["6001"]}");
    debugPrint("animations is ${frames["6001"]?.length}");
  }
}
