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

  final CameraComponent mainCamera = CameraComponent(
    viewport: FixedResolutionViewport(resolution: Vector2(20 * 32, 10 * 32)),
    viewfinder: Viewfinder(),
  );

  CitizenGame() {
    camera = mainCamera;
  }

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

    // camera.viewfinder
    //   ..anchor = Anchor.topLeft
    //   ..position = Vector2(0, tiledSize.y - resolutionSize.y);
    //
    // camera.viewport.add(TextComponent(text: "2222"));
    //
    // final tiledComponent =
    //     await TiledComponent.load("map.tmx", Vector2.all(blockSize));
    // world.add(tiledComponent);
    //
    // final objects = tiledComponent.tileMap.getLayer<ObjectGroup>("NPC");
    // final npc = await Flame.images.load('NPC/Alex.png');
    //
    // for (final object in objects!.objects) {
    //   world.add(
    //     SpriteAnimationComponent(
    //       size: Vector2(16, 32),
    //       position: Vector2(object.x, object.y),
    //       animation: SpriteAnimation.fromFrameData(
    //         npc,
    //         SpriteAnimationData.sequenced(
    //           amount: 4,
    //           stepTime: 0.25,
    //           textureSize: Vector2(16, 32),
    //         ),
    //       ),
    //     ),
    //   );
    // }
  }
}
