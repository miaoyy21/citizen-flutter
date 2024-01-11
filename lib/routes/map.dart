import '../index.dart';

class MapPage extends Component
    with TapCallbacks, HasGameReference<CitizenGame> {
  final String tileName;
  final Vector2 tileSize;

  MapPage({required this.tileName, required this.tileSize});

  @override
  FutureOr<void> onLoad() async {
    debugPrint(
        "onLoad game.world.children.length => ${game.world.children.length}");

    if (tileName == "map.tmx") {
      game.mainCamera.viewfinder
        ..anchor = Anchor.topLeft
        ..position = Vector2(200, 400);
    }

    // if (tileSize.x > tileSize.y) {
    //   game.camera.viewfinder
    //     ..anchor = Anchor.topLeft
    //     ..position = Vector2(
    //         0,
    //         tileSize.y -
    //             (game.camera.viewport as FixedResolutionViewport).resolution.y);
    // } else {
    //   game.camera.viewfinder
    //     ..anchor = Anchor.topCenter
    //     ..position = Vector2(
    //         tileSize.x / 2,
    //         tileSize.y -
    //             (game.camera.viewport as FixedResolutionViewport).resolution.y);
    // }

    final tiledComponent =
        await TiledComponent.load(tileName, Vector2.all(game.blockSize));
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

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapDown(TapDownEvent event) {
    debugPrint("onTapDown =>>>> $tileName");
    if (tileName == "map.tmx") {
      game.router.pushReplacementNamed("map1");
    } else if (tileName == "map1.tmx") {
      game.router.pushReplacementNamed("map2");
    } else {
      game.router.pushReplacementNamed("map");
    }
  }

  @override
  void onRemove() {
    debugPrint("onRemove =>>>> $tileName");

    // game.world.removeAll(game.world.children);
    super.onRemove();
  }
}
