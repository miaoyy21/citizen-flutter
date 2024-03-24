import 'dart:html';
import 'dart:math';

import '../index.dart';

class Stage extends Component with TapCallbacks, HasGameReference<CitizenGame> {
  final String name;

  Stage(this.name) : super(key: ComponentKey.named(name));

  World get world => game.world;

  late Player player;
  late List<Enemy> enemies = [];

  final double speed = 100.0;
  final double prepareSpeedRate = 6.0;
  final double walkSpeedRate = 1.0;
  final double runSpeedRate = 2.0;
  final double fps = 12.0;

  @override
  FutureOr<void> onLoad() async {
    world.add(SpriteComponent.fromImage(await Flame.images.load("129.png"),
        anchor: Anchor.bottomLeft));
    debugPrint("onLoad game.world.children.length => ${world.children.length}");

    FlameAudio.bgm.play(fileName)..

    final stage = SpriteComponent.fromImage(
        await Flame.images.load("$name.png"),
        anchor: Anchor.bottomLeft);
    world.add(stage);

    // Player
    final playerPosition = Vector2(300 + 48, -11);
    final playerCape = StickCape(Colors.red, position: playerPosition);
    final playerEffect = StickEffect(position: playerPosition);
    player = Player(this, playerCape, playerEffect, Colors.black,
        position: playerPosition);
    player.debugColor = Colors.purple;

    // Camera
    final camera = Camera(player, stage.size);
    world.add(camera);

    // Enemy
    final enemy1Position = Vector2(150 + 48, -11);
    final enemy1Cape = StickCape(Colors.orange, position: enemy1Position);
    final enemy1 =
        Enemy(1, this, enemy1Cape, Colors.green, position: enemy1Position);
    enemy1.debugColor = Colors.blue;
    world.add(enemy1);
    world.add(enemy1Cape);
    enemies.add(enemy1);

    world.add(player);
    world.add(playerCape);
    world.add(playerEffect);
  }

  // 寻找最近的可攻击目标
  Enemy? isPlayerCollision(AnimationFrameData frame) {
    final index = enemies.indexWhere((enemy) {
      final List<ImageRectangle> exposes = [];
      exposes.addAll(enemy.frame.exposeHead);
      exposes.addAll(enemy.frame.exposeBody);
      exposes.addAll(enemy.frame.exposeFoot);

      final List<ImageRectangle> attacks = [];
      attacks.addAll(frame.attackHand);
      attacks.addAll(frame.attackFoot);

      return attacks.any((attack) => exposes.any((expose) =>
          (isCollision(player.position, attack, enemy.position, expose))));
    });

    return index >= 0 ? enemies[index] : null;
  }

  bool isCollision(
      Vector2 p1, ImageRectangle rect1, Vector2 p2, ImageRectangle rect2) {
    final min1 = rect1.min.toGlobal(p1);
    final max1 = rect1.max.toGlobal(p1);

    final min2 = rect2.min.toGlobal(p2);
    final max2 = rect2.max.toGlobal(p2);

    return (max(max1.x, max2.x) - min(min1.x, min2.x)).abs() <
            (max1.x - min1.x) + (max2.x - min2.x) &&
        (max(min1.y, min2.y) - min(max1.y, max2.y)).abs() <
            (min1.y - max1.y) + (min2.y - max2.y);
  }

  @override
  void update(double dt) {}

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapDown(TapDownEvent event) {
    // debugPrint("onTapDown > $tileName > ${event.localPosition}");
  }

  @override
  void onRemove() {
    world.removeAll(world.children);
    // debugPrint("onRemove >>> $tileName");

    super.onRemove();
  }
}
