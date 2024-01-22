import '../index.dart';

class MapPage extends Component
    with TapCallbacks, HasGameReference<CitizenGame> {
  final String tileName;
  final Vector2 tileSize;

  MapPage({required this.tileName, required this.tileSize});

  World get world => game.world;

  CameraComponent get camera => game.camera;

  late final JoystickPlayer player;
  late final JoystickComponent joystick;

  @override
  FutureOr<void> onLoad() async {
    debugPrint("onLoad game.world.children.length => ${world.children.length}");

    final tiledComponent =
        await TiledComponent.load(tileName, Vector2.all(game.blockSize));
    world.add(tiledComponent);

    final sNPC = <NPC>[
      NPC(
          "1",
          "Adam",
          "Adam",
          size: Vector2(16, 32),
          position: Vector2(325, 275),
          Direction.left,
          ["未来一定属于你", "社会需要你这样的人才"]),
      NPC(
          "2",
          "Bob",
          "Bob",
          size: Vector2(16, 32),
          position: Vector2(100, 150),
          Direction.right,
          ["未来一定属于你", "社会需要你这样的人才"]),
    ];

    for (var npc in sNPC) {
      world.add(npc);
    }

    joystick = JoystickComponent(
      knob: CircleComponent(
        radius: 24,
        paint: BasicPalette.black.withAlpha(128).paint(),
      ),
      background: CircleComponent(
        radius: 64,
        paint: BasicPalette.white.withAlpha(64).paint(),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 120),
    );

    player = JoystickPlayer(joystick, 150, position: Vector2(150, 150));
    world.add(player);
    camera.viewport.add(joystick);

    camera.viewfinder.anchor = Anchor.center;
    // camera.moveTo(Vector2(tileSize.x / 2, tileSize.y / 2));
  }

  @override
  void update(double dt) {
    if (joystick.isDragged) {
      final reSize = (camera.viewport as FixedResolutionViewport).resolution;

      // final p0 = camera.viewfinder.position;
      final p0 = player.position;

      final x1 = tileSize.x / 2 - (tileSize.x - reSize.x) / 2;
      final x2 = tileSize.x / 2 + (tileSize.x - reSize.x) / 2;
      final y1 = tileSize.y / 2 - (tileSize.y - reSize.y) / 2;
      final y2 = tileSize.y / 2 + (tileSize.y - reSize.y) / 2;
      if (p0.x < x1 || p0.x > x2 || p0.y < y1 || p0.y > y2) {
        if (p0.x < x1) {
          if (p0.y < y1) {
            camera.moveTo(Vector2(x1, y1));
          } else if (p0.y >= y1 && p0.y <= y2) {
            camera.moveTo(Vector2(x1, p0.y));
          } else {
            camera.moveTo(Vector2(x1, y2));
          }
        }

        if (p0.x > x2) {
          if (p0.y < y1) {
            camera.moveTo(Vector2(x2, y1));
          } else if (p0.y >= y1 && p0.y <= y2) {
            camera.moveTo(Vector2(x2, p0.y));
          } else {
            camera.moveTo(Vector2(x2, y2));
          }
        }

        if (p0.y < y1) {
          if (p0.x < x1) {
            camera.moveTo(Vector2(x1, y1));
          } else if (p0.x >= x1 && p0.x <= x2) {
            camera.moveTo(Vector2(p0.x, y1));
          } else {
            camera.moveTo(Vector2(x2, y1));
          }
        }

        if (p0.y > y2) {
          if (p0.x < x1) {
            camera.moveTo(Vector2(x1, y2));
          } else if (p0.x >= x1 && p0.x <= x2) {
            camera.moveTo(Vector2(p0.x, y2));
          } else {
            camera.moveTo(Vector2(x2, y2));
          }
        }
      } else {
        camera.follow(player);
      }

      debugPrint("World Size is $tileSize");
      debugPrint("Viewport Size is $reSize");
      debugPrint("Viewfinder Position is ${camera.viewfinder.position}");
      debugPrint("Position P0 is $p0");
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapDown(TapDownEvent event) {
    debugPrint("onTapDown > $tileName > ${event.localPosition}");
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
