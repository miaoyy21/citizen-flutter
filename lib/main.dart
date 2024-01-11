import 'dart:async';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(GameWidget(game: CitizenGame()));
}

class CitizenGame extends FlameGame {
  static const double blockSize = 32;
  static Vector2 tiledSize = Vector2(30 * blockSize, 20 * blockSize);
  static Vector2 resolutionSize = Vector2(20 * blockSize, 10 * blockSize);

  CitizenGame()
      : super(
          camera: CameraComponent(
            viewport: FixedResolutionViewport(resolution: resolutionSize),
            viewfinder: Viewfinder(),
          ),
        );

  @override
  FutureOr<void> onLoad() async {
    camera.viewfinder
      ..anchor = Anchor.topLeft
      ..position = Vector2(0, tiledSize.y - resolutionSize.y);

    camera.viewport.add(TextComponent(text: "2222"));

    final tiledComponent =
        await TiledComponent.load("map.tmx", Vector2.all(blockSize));
    world.add(tiledComponent);

    final objects = tiledComponent.tileMap.getLayer<ObjectGroup>("NPC");
    final npc = await Flame.images.load('NPC/Alex.png');

    for (final object in objects!.objects) {
      world.add(
        SpriteAnimationComponent(
          size: Vector2(16, 32),
          position: Vector2(object.x, object.y),
          animation: SpriteAnimation.fromFrameData(
            npc,
            SpriteAnimationData.sequenced(
              amount: 4,
              stepTime: 0.25,
              textureSize: Vector2(16, 32),
            ),
          ),
        ),
      );
    }
  }
}
