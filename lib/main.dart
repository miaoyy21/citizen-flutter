import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.setLandscape();
  Flame.device.fullScreen();

  runApp(GameWidget(game: CitizenGame()));
}

class CitizenGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  late final RouterComponent router;
  late final double blockSize = 32;

  CitizenGame()
      : super(
          camera: CameraComponent(
            viewport: FixedResolutionViewport(
              resolution: Vector2(22.5 * 32, 16 * 32),
            ),
            viewfinder: Viewfinder(),
          ),
        );

  @override
  FutureOr<void> onLoad() async {
    debugMode = true;

    await AnimationStore().load();

    add(
      router = RouterComponent(
        routes: {
          'stage1': Route(
            maintainState: false,
            () => Stage(
              "stage1",
              size: Vector2(80 * blockSize, 50 * blockSize),
            ),
          ),
          // 'level-selector': Route(LevelSelectorPage.new),
          // 'settings': Route(SettingsPage.new, transparent: true),
          // 'pause': PauseRoute(),
          // 'confirm-dialog': OverlayRoute.existing(),
        },
        initialRoute: 'stage1',
      ),
    );
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final player = findByKey<Player>(ComponentKey.named("player"));

    if (player != null) {
      if (event is RawKeyDownEvent) {
        KeyStore().add(event);

        if (KeyStore().isRepeat(LogicalKeyboardKey.arrowRight)) {}

        debugPrint(
            "RawKeyDownEvent => [${KeyStore().keys.map((e) => "$e").join(", ")}]");
      } else if (event is RawKeyUpEvent) {
        debugPrint(
            "RawKeyUpEvent =>  [${KeyStore().keys.map((e) => "$e").join(", ")}]");
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
