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
              resolution: Vector2(32 * 32, 23.75 * 32),
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
            () => Stage("stage1"),
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
    final player = findByKey<Player>(ComponentKey.named("Player"));

    if (player != null) {
      if (event is RawKeyDownEvent) {
        KeyStore().add(event);
      } else if (event is RawKeyUpEvent) {
        KeyStore().removeRepeat(event.logicalKey);
      }

      // debugPrint("RawKeyEvent => ${KeyStore().showKeys}");
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
