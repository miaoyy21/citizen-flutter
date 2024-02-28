import 'package:citizen/skill/index.dart';

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

  final KeyStore keyStore = KeyStore();

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final player = findByKey(ComponentKey.named("player"));

    // 当人面向右
    // 右右   快速向前
    // 左左   快速后退

    if (keyStore.add(event, currentTime())) {
      if (keyStore.isTwice(LogicalKeyboardKey.arrowRight)) {
        debugPrint("快速向前跳");
      }

      if (keyStore.isTwice(LogicalKeyboardKey.arrowLeft)) {
        debugPrint("快速向后跳");
      }

      if (keyStore.isRepeat(LogicalKeyboardKey.arrowRight)) {
        debugPrint("向前奔跑");
      }

      if (keyStore.isRepeat(LogicalKeyboardKey.arrowLeft)) {
        debugPrint("向后奔跑");
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
