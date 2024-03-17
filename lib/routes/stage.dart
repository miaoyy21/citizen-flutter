import '../index.dart';

class Stage extends Component with TapCallbacks, HasGameReference<CitizenGame> {
  final String name;

  Stage(this.name) : super(key: ComponentKey.named(name));

  World get world => game.world;

  @override
  FutureOr<void> onLoad() async {
    world.add(SpriteComponent.fromImage(await Flame.images.load("129.png"),
        anchor: Anchor.bottomLeft));
    debugPrint("onLoad game.world.children.length => ${world.children.length}");

    final stage = SpriteComponent.fromImage(
        await Flame.images.load("$name.png"),
        anchor: Anchor.bottomLeft);
    world.add(stage);

    final playerPosition = Vector2(300 + 48, -11);
    final playerCape = StickCape(Colors.red, position: playerPosition);
    final playerEffect = StickEffect(Colors.black, position: playerPosition);
    final player = Player(playerCape, playerEffect, Colors.black,
        position: playerPosition);
    player.debugColor = Colors.purple;

    final camera = Camera(player, stage.size);
    world.add(camera);

    final enemy1Position = Vector2(150 + 48, -11);
    final enemy1Cape = StickCape(Colors.orange, position: enemy1Position);
    final enemy1 = Enemy(1, enemy1Cape, Colors.green, position: enemy1Position);
    enemy1.debugColor = Colors.blue;
    world.add(enemy1);
    world.add(enemy1Cape);

    world.add(player);
    world.add(playerEffect);
    world.add(playerCape);

    // final enemy2 = Enemy(2, position: Vector2(600 + 48, -16 + 5));
    // enemy2.debugColor = Colors.green;
    // world.add(enemy2);
  }

  @override
  void update(double dt) {}

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapDown(TapDownEvent event) {
    // debugPrint("onTapDown > $tileName > ${event.localPosition}");
  }

  @override
  void onRemove() {
    world.removeAll(world.children);
    // debugPrint("onRemove >>> $tileName");

    super.onRemove();
  }
}
