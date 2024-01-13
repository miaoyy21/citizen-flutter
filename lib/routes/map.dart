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

    // 开始计算摄像机需要移动到的位置
    if (tileSize.x > tileSize.y) {
      position = Vector2(0, tileSize.y - reSize.y);
    } else {
      position = Vector2((tileSize.x - reSize.x) / 2, tileSize.y - reSize.y);
    }

    camera.viewfinder
      ..anchor = Anchor.topLeft
      ..position = position;

    final tiledComponent =
        await TiledComponent.load(tileName, Vector2.all(game.blockSize));
    world.add(tiledComponent);

    final sNPC = <NPC>[
      NPC("1", "Adam", "Adam", Vector2(16, 32), Direction.left,
          ["未来一定属于你", "社会需要你这样的人才"])
        ..position = Vector2(325, 275),
      NPC("2", "Bob", "Bob", Vector2(16, 32), Direction.right,
          ["未来一定属于你", "社会需要你这样的人才"])
        ..position = Vector2(100, 150),
    ];

    for (var npc in sNPC) {
      final image = await Flame.images.load("NPC/${npc.protoId}.png");

      world.add(
        SpriteAnimationComponent(
          size: npc.size,
          position: npc.position,
          animation: SpriteAnimation.fromFrameData(
            image,
            SpriteAnimationData.sequenced(
              amount: 4,
              stepTime: 0.25,
              textureSize: npc.size,
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
    // if (tileName == "world.tmx") {
    //   game.router.pushReplacementNamed("map1");
    // } else if (tileName == "map1.tmx") {
    //   game.router.pushReplacementNamed("map2");
    // } else if (tileName == "map2.tmx") {
    //   game.router.pushReplacementNamed("map3");
    // } else {
    //   game.router.pushReplacementNamed("world");
    // }
  }

  @override
  void onRemove() {
    world.removeAll(world.children);
    debugPrint("onRemove =>>>> $tileName");

    super.onRemove();
  }
}
