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
    final spriteSheet = SpriteSheet(image: image, srcSize: size);

    animation =
        spriteSheet.createAnimation(row: 1, stepTime: 0.25, from: 18, to: 23);
    add(RectangleHitbox()..debugMode = true);
  }
}
