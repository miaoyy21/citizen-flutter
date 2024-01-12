import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.setLandscape();
  // Flame.device.fullScreen();

  runApp(GameWidget(game: CitizenGame()));
}

class CitizenGame extends FlameGame {
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
              tileSize: Vector2(51 * blockSize, 23 * blockSize),
            ),
          ),
          'map1': Route(
            maintainState: false,
            () => MapPage(
              tileName: "map1.tmx",
              tileSize: Vector2(32 * blockSize, 32 * blockSize),
            ),
          ),
          'map2': Route(
            maintainState: false,
            () => MapPage.new(
              tileName: "map2.tmx",
              tileSize: Vector2(32 * blockSize, 32 * blockSize),
            ),
          ),
          'map3': Route(
            maintainState: false,
            () => MapPage.new(
              tileName: "map3.tmx",
              tileSize: Vector2(32 * blockSize, 34 * blockSize),
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
