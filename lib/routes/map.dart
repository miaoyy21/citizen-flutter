import '../index.dart';

class MapPage extends Component
    with TapCallbacks, HasGameReference<CitizenGame> {
  final String name;
  final Vector2 size;

  MapPage({required this.name, required this.size});

  @override
  FutureOr<void> onLoad() async {
    if (size.x > size.y) {
      game.camera.viewfinder
        ..anchor = Anchor.topLeft
        ..position = Vector2(
            0,
            size.y -
                (game.camera.viewport as FixedResolutionViewport).resolution.y);
    } else {
      game.camera.viewfinder
        ..anchor = Anchor.topCenter
        ..position = Vector2(
            size.x / 2,
            size.y -
                (game.camera.viewport as FixedResolutionViewport).resolution.y);
    }

    final tiledComponent =
        await TiledComponent.load(name, Vector2.all(game.blockSize));
    game.world.add(tiledComponent);

    final npcLayer = tiledComponent.tileMap.getLayer<ObjectGroup>("NPC");
    if (npcLayer != null && npcLayer.objects.isNotEmpty) {
      final npc = await Flame.images.load('NPC/Alex.png');

      for (final object in npcLayer.objects) {
        game.world.add(
          SpriteAnimationComponent(
            size: Vector2(16, 32),
            position: Vector2(object.x, object.y),
            animation: SpriteAnimation.fromFrameData(
              npc,
              SpriteAnimationData.sequenced(
                amount: 4,
                stepTime: 0.25,
                textureSize: Vector2(16, 32),
              ),
            ),
          ),
        );
      }
    }
  }
}
