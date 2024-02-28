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
    debugMode = true;

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
    final player = findByKey<Player>(ComponentKey.named("player"));

    if (player != null) {
      if (event is RawKeyDownEvent) {
        keyStore.add(event, currentTime());
        if (keyStore.isRepeat(LogicalKeyboardKey.arrowLeft)) {
          debugPrint("向左奔跑");
          player.action(AnimationEvent.run, Direction.left);
        } else if (keyStore.isRepeat(LogicalKeyboardKey.arrowRight)) {
          debugPrint("向右奔跑");
          player.action(AnimationEvent.run, Direction.right);
        } else if (keyStore.isKey(LogicalKeyboardKey.arrowLeft)) {
          debugPrint("向左走路");
          player.action(AnimationEvent.walk, Direction.left);
        } else if (keyStore.isKey(LogicalKeyboardKey.arrowRight)) {
          debugPrint("向右走路");
          player.action(AnimationEvent.walk, Direction.right);
        } else if (keyStore.isKey(LogicalKeyboardKey.arrowUp)) {
          debugPrint("向上跳");
          player.action(AnimationEvent.jump, Direction.repeat);
        }
      } else if (event is RawKeyUpEvent) {
        player.finished();
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
