import 'package:citizen/overlays/bag.dart';

import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.setLandscape();
  Flame.device.fullScreen();

  final game = CitizenGame();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GameWidget(
            game: game,
            overlayBuilderMap: {
              "BagPage": (context, game) => BagPage(),
            },
          ),
          MenuOverlay(game: game)
        ],
      ),
    ),
  ));
}

class CitizenGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  late final RouterComponent router;
  late final double blockSize = 32;

  CitizenGame()
      : super(
          camera: CameraComponent(
            viewport: FixedResolutionViewport(
              /* 1024 * 768 */
              resolution: Vector2(32 * 32, 24 * 32)..scale(0.75),
            ),
            viewfinder: Viewfinder(),
          ),
        );

  @override
  FutureOr<void> onLoad() async {
    debugPrint("111 ${DateTime.now().toIso8601String()}");
    // await AnimationStore().load();
    // await SkillStore().load();
    // await SoundStore().load();
    debugPrint("222 ${DateTime.now().toIso8601String()}");

    add(
      router = RouterComponent(
        initialRoute: 'stage01',
        routes: {
          'stage01': Route(
            maintainState: false,
            () => Stage("stage01"),
          ),
        },
      ),
    );
    debugPrint("333 ${DateTime.now().toIso8601String()}");
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
