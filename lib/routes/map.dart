import '../index.dart';

class MapPage extends Component
    with TapCallbacks, HasGameReference<CitizenGame> {
  final String name;
  final Vector2 size;

  MapPage(this.name, {required this.size})
      : super(key: ComponentKey.named(name));

  World get world => game.world;

  @override
  FutureOr<void> onLoad() async {
    world.add(SpriteComponent.fromImage(await Flame.images.load("129.png"),
        anchor: Anchor.bottomLeft));
    debugPrint("onLoad game.world.children.length => ${world.children.length}");
    world.add(SpriteComponent.fromImage(await Flame.images.load("stage1.png"),
        anchor: Anchor.bottomLeft));

    final joystick = JoystickComponent(
      knob: CircleComponent(
        radius: 24,
        paint: BasicPalette.black.withAlpha(128).paint(),
      ),
      background: CircleComponent(
        radius: 64,
        paint: BasicPalette.white.withAlpha(64).paint(),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 128),
    );

    final player = JoystickPlayer(joystick, position: Vector2(32, -16 + 5));
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
