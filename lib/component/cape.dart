import '../index.dart';

class Cape extends SpriteComponent {
  final Color color;

  Cape(this.color, {super.position}) : super(anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    final empty = await Flame.images.load("empty.png");
    sprite = SpriteComponent.fromImage(empty).sprite;

    add(ColorEffect(color, EffectController(duration: 0)));
  }
}
