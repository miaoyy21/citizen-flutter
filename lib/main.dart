import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.setLandscape();
  Flame.device.fullScreen();

  runApp(GameWidget(game: CitizenGame()));
}

class CitizenGame extends FlameGame with HasCollisionDetection {
  late final RouterComponent router;
  late final double blockSize = 32;

  CitizenGame()
      : super(
          camera: CameraComponent(
            viewport: FixedResolutionViewport(
              resolution: Vector2(20 * 32, 10 * 32),
            ),
            viewfinder: Viewfinder(),
          ),
        );

  @override
  FutureOr<void> onLoad() async {
    add(
      router = RouterComponent(
        routes: {
          'world': Route(
            maintainState: false,
            () => MapPage(
              tileName: "world.tmx",
              tileSize: Vector2(25 * blockSize, 12 * blockSize),
            ),
          ),
          'map1': Route(
            maintainState: false,
            () => MapPage(
              tileName: "map1.tmx",
              tileSize: Vector2(16 * blockSize, 16 * blockSize),
            ),
          ),
          'map2': Route(
            maintainState: false,
            () => MapPage(
              tileName: "map2.tmx",
              tileSize: Vector2(16 * blockSize, 16 * blockSize),
            ),
          ),
          'map3': Route(
            maintainState: false,
            () => MapPage(
              tileName: "map3.tmx",
              tileSize: Vector2(16 * blockSize, 17 * blockSize),
            ),
          ),
          // 'level-selector': Route(LevelSelectorPage.new),
          // 'settings': Route(SettingsPage.new, transparent: true),
          // 'pause': PauseRoute(),
          // 'confirm-dialog': OverlayRoute.existing(),
        },
        initialRoute: 'world',
      ),
    );
  }
}
