import '../index.dart';

class MapPage extends Component
    with TapCallbacks, HasGameReference<CitizenGame> {
  final String tileName;
  final Vector2 tileSize;

  MapPage({required this.tileName, required this.tileSize});

  World get world => game.world;

  CameraComponent get camera => game.camera;

  @override
  FutureOr<void> onLoad() async {
    debugPrint("onLoad game.world.children.length => ${world.children.length}");

    late Vector2 position = Vector2.zero();
    final reSize = (camera.viewport as FixedResolutionViewport).resolution;
    final xSize =
        (camera.viewport as FixedResolutionViewport).localToGlobal(reSize);

    // 开始计算摄像机需要移动到的位置
    debugPrint("Tile Size is $tileSize");
    debugPrint("Resolution Size is $reSize, X Size is $xSize");
    if (tileSize.x > tileSize.y) {
      // position = Vector2(0, tileSize.y - reSize.y);
      position.y = xSize.y;
    } else {
      position = Vector2((tileSize.x - reSize.x) / 2, tileSize.y - reSize.y);
    }

    camera.viewfinder
      ..anchor = Anchor.topLeft
      ..position = position;
    debugPrint("View Finder Position is ${camera.viewfinder.position}");

    final tiledComponent =
        await TiledComponent.load(tileName, Vector2.all(game.blockSize));
    world.add(tiledComponent);

    final npcLayer = tiledComponent.tileMap.getLayer<ObjectGroup>("NPC");
    if (npcLayer == null || npcLayer.objects.isEmpty) {
      return;
    }

    final npc = await Flame.images.load('Adam.png');
    for (final object in npcLayer.objects) {
      world.add(
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

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapDown(TapDownEvent event) {
    debugPrint("onTapDown =>>>> $tileName ===> ${event.toString()}");
    if (tileName == "world.tmx") {
      game.router.pushReplacementNamed("map1");
    } else if (tileName == "map1.tmx") {
      game.router.pushReplacementNamed("map2");
    } else if (tileName == "map2.tmx") {
      game.router.pushReplacementNamed("map3");
    } else {
      game.router.pushReplacementNamed("world");
    }
  }

  @override
  void onRemove() {
    world.removeAll(world.children);
    debugPrint("onRemove =>>>> $tileName");

    super.onRemove();
  }
}
