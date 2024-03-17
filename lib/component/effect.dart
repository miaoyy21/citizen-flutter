import '../index.dart';

class StickEffect extends SpriteComponent {
  final Color? color;

  StickEffect({this.color, super.position})
      : super(anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    final empty = await Flame.images.load("empty.png");
    sprite = SpriteComponent.fromImage(empty).sprite;

    if (color != null) {
      add(ColorEffect(color!, EffectController(duration: 0)));
    }
  }
}
