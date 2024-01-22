import '../index.dart';
import 'view.dart';

class MapPage extends Component
    with TapCallbacks, HasGameReference<CitizenGame> {
  final String tileName;
  final Vector2 tileSize;

  MapPage({required this.tileName, required this.tileSize});

  World get world => game.world;

  late final JoystickComponent joystick;
  late final ViewComponent view;

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

    final player = JoystickPlayer(joystick, 100, position: Vector2(150, 150));
    world.add(player);

    view = ViewComponent(player, tileSize);
    world.add(view);
  }

  @override
  void update(double dt) {}

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
