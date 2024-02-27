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
    add(
      router = RouterComponent(
        routes: {
          'stage1': Route(
            maintainState: false,
            () => MapPage(
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
    debugPrint("$event");

    final key = findByKey(ComponentKey.named("stage1"));
    debugPrint("Key is $key");

    if (event is KeyDownEvent) {
      debugPrint("KeyDownEvent");
    } else if (event is KeyUpEvent) {
      debugPrint("KeyUpEvent");
    }

    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      debugPrint("Key A Down");
    }

    // Avoiding repeat event as we are interested only in
    // key up and key down event.
    // if (event is! KeyRepeatEvent) {
    //   if (event.logicalKey == LogicalKeyboardKey.keyA) {
    //     _direction.x += isKeyDown ? -1 : 1;
    //   } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
    //     _direction.x += isKeyDown ? 1 : -1;
    //   } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
    //     _direction.y += isKeyDown ? -1 : 1;
    //   } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
    //     _direction.y += isKeyDown ? 1 : -1;
    //   }
    // }

    return super.onKeyEvent(event, keysPressed);
  }
}
