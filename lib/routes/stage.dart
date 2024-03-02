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

    final player = Player(position: Vector2(0, -16 + 5));
    world.add(player);

    final camera = PlayerCamera(player, stage.size);
    world.add(camera);
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
