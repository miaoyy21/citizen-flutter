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
          'map': Route(
            maintainState: false,
            () => MapPage(
              tileName: "map.tmx",
              tileSize: Vector2(30 * blockSize, 20 * blockSize),
            ),
          ),
          'map1': Route(
            maintainState: false,
            () => MapPage(
              tileName: "map1.tmx",
              tileSize: Vector2(25 * blockSize, 12 * blockSize),
            ),
          ),
          'map2': Route(
            maintainState: false,
            () => MapPage.new(
              tileName: "map2.tmx",
              tileSize: Vector2(12 * blockSize, 25 * blockSize),
            ),
          ),
          // 'level-selector': Route(LevelSelectorPage.new),
          // 'settings': Route(SettingsPage.new, transparent: true),
          // 'pause': PauseRoute(),
          // 'confirm-dialog': OverlayRoute.existing(),
        },
        initialRoute: 'map',
      ),
    );
  }
}
