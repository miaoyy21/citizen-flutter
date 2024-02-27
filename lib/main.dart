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
          'Stage1': Route(
            maintainState: false,
            () => MapPage(
              tileName: "world.tmx",
              tileSize: Vector2(80 * blockSize, 50 * blockSize),
            ),
          ),
          // 'level-selector': Route(LevelSelectorPage.new),
          // 'settings': Route(SettingsPage.new, transparent: true),
          // 'pause': PauseRoute(),
          // 'confirm-dialog': OverlayRoute.existing(),
        },
        initialRoute: 'Stage1',
      ),
    );
  }
}
