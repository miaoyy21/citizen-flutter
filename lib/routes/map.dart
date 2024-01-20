import 'dart:ui';

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

    player = JoystickPlayer(joystick, 50, position: Vector2(150, 150));


    world.add(player);
    camera.viewport.add(joystick);
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

class NPCComponent extends SpriteComponent with HasGameReference<CitizenGame> {
  final NPC npc;
  final Image image;

  NPCComponent(this.npc, this.image, {super.position})
      : super(size: Vector2.all(30), anchor: Anchor.center);

  late SpriteAnimation animation;

  @override
  Future<void> onLoad() async {
    size = npc.size;
    position = npc.position;

    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.25,
        textureSize: npc.size,
      ),
    );
    add(RectangleHitbox()..debugMode = true);

    sprite = animation.frames.first.sprite;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
