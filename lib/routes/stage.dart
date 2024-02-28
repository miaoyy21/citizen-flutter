import '../index.dart';

class Stage extends Component with TapCallbacks, HasGameReference<CitizenGame> {
  final String name;
  final Vector2 size;

  Stage(this.name, {required this.size}) : super(key: ComponentKey.named(name));

  World get world => game.world;

  @override
  FutureOr<void> onLoad() async {
    world.add(SpriteComponent.fromImage(await Flame.images.load("129.png"),
        anchor: Anchor.bottomLeft));
    debugPrint("onLoad game.world.children.length => ${world.children.length}");
    world.add(SpriteComponent.fromImage(await Flame.images.load("stage1.png"),
        anchor: Anchor.bottomLeft));

    final player = Player(position: Vector2(32, -16 + 5));
    world.add(player);

    final camera = PlayerCamera(player);
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
