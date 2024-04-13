import 'dart:ffi';
import 'dart:ui';

import 'package:citizen/overlays/bag.dart';

import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.setLandscape();
  Flame.device.fullScreen();

  final game = CitizenGame();

  // 关闭遮罩层
  onOverlayClose(page) {
    game.overlays.remove(page);
    OverlayMenus.values.every((menu) => game.overlays.activeOverlays
            .every((overlay) => overlay != menu.name))
        ? game.resumeEngine()
        : Void;
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    scrollBehavior: GameCustomScrollBehavior(),
    theme: ThemeData(
      fontFamily: "Z2",
    ),
    home: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GameWidget(
            game: game,
            overlayBuilderMap: {
              OverlayMenus.bag.name: (context, _) =>
                  BagPage(game, onOverlayClose),
            },
          ),
          MenuOverlay(game: game)
        ],
      ),
    ),
  ));
}

// Override behavior methods and getters like dragDevices
class GameCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class CitizenGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  late final RouterComponent router;
  late final double blockSize = 32;

  CitizenGame()
      : super(
          camera: CameraComponent(
            viewport: FixedResolutionViewport(
              resolution: Vector2(960, 640),
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

    await ProtoStore().load();
    debugPrint("222 ${DateTime.now().toIso8601String()}");

    await PlayerStore().load();

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
