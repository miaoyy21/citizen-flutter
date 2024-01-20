import '../index.dart';

class NPC extends SpriteAnimationComponent with HasGameReference<CitizenGame> {
  final String id; // ID
  final String protoId; // 对应的资源ID
  final String name; // 名称
  final Direction direction; // 方向 上下左右
  final List<String> tags; // 口头禅

  NPC(this.id, this.protoId, this.name, this.direction, this.tags,
      {super.size, super.position});

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load("NPC/$protoId.png");

    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.25,
        textureSize: size,
      ),
    );
    add(RectangleHitbox()..debugMode = true);
  }
}
