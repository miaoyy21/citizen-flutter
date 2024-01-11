import 'dart:async';

import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(GameWidget(game: CitizenGame()));
}

class CitizenGame extends FlameGame {
  late final RouterComponent router;
  late final double blockSize = 32;

  CitizenGame()
      : super(
          camera: CameraComponent(
            viewport:
                FixedResolutionViewport(resolution: Vector2(20 * 32, 10 * 32)),
            viewfinder: Viewfinder(),
          ),
        );

  @override
  FutureOr<void> onLoad() async {
    add(
      router = RouterComponent(
        routes: {
          'map': Route(
            () => MapPage(
              name: "map.tmx",
              size: Vector2(30 * 32, 20 * 32),
            ),
          ),
          'map1': Route(
            () => MapPage(
              name: "map1.tmx",
              size: Vector2(25 * 32, 12 * 32),
            ),
          ),
          'map2': Route(
            () => MapPage(
              name: "map2.tmx",
              size: Vector2(12 * 32, 25 * 32),
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
