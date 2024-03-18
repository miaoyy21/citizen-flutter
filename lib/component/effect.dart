import '../index.dart';

class StickEffect extends SpriteComponent {
  StickEffect({super.position}) : super(anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    final empty = await Flame.images.load("empty.png");
    sprite = SpriteComponent.fromImage(empty).sprite;
  }
}
