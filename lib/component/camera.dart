import '../index.dart';

class Camera extends Component with HasGameReference<CitizenGame> {
  final Player player;
  final Vector2 mapSize;

  Camera(this.player, this.mapSize) : super(key: ComponentKey.named("Camera"));

  CameraComponent get camera => game.camera;

  @override
  FutureOr<void> onLoad() {
    camera.viewfinder.anchor = Anchor.bottomLeft;
    camera.moveTo(Vector2(0, 0));

    // camera.follow(player);
  }

  final double speed = 500;

  // late int dx = 0;

  @override
  void update(double dt) {
    if (1 / dt < 50) {
      debugPrint("Camera 每秒帧数降至 ${(1 / dt).toStringAsFixed(2)}");
    }

    final viewportSize =
        (camera.viewport as FixedResolutionViewport).resolution;

    final p0 = player.position.clone();

    // final size = player.aniFrames.size;

    // 1. 根据图片尺寸进行判定
    // if (size.max.x - size.min.x > 150) {
    //   debugPrint("size.max.x - size.min.x = ${size.max.x - size.min.x}");
    //   p0.add(Vector2((size.max.x - size.min.x - 100).toDouble(), 0));
    // }

    // 2. 根据玩家移动判定
    // if (dx != 0) {
    //   p0.add(Vector2(dx.toDouble(), 0));
    //   dx = 0;
    // }

    // 3. 根据动画帧的总长度来判定
    // final first = player.aniFrames.framesData.first;
    // final last = player.aniFrames.framesData.last;
    // final dx = (last.position.x - first.position.x) *
    //     player.onTime /
    //     (player.aniFrames.frames.length / player.designFPS);
    // if (dx > 20) {
    //   p0.add(Vector2(dx, 0));
    // }

    // 左下角
    final p1 = Vector2(viewportSize.x / 2, -viewportSize.y / 2);

    // 右上角
    final p2 =
        Vector2(mapSize.x - viewportSize.x / 2, viewportSize.y / 2 - mapSize.y);

    // 判定
    if (p0.x < p1.x) {
      if (p0.y > p1.y) {
        // 左下
        camera.moveTo(Vector2(0, 0), speed: speed);
      } else if (p0.y < p1.y && p0.y > p2.y) {
        // 左中
        camera.moveTo(Vector2(0, p0.y), speed: speed);
      } else if (p0.y < p2.y) {
        // 左上
        camera.moveTo(Vector2(0, p2.y), speed: speed);
      }
    } else if (p0.x > p2.x) {
      if (p0.y > p1.y) {
        // 右下
        camera.moveTo(Vector2(mapSize.x - viewportSize.x, 0), speed: speed);
      } else if (p0.y < p1.y && p0.y > p2.y) {
        // 右中
        camera.moveTo(Vector2(mapSize.x - viewportSize.x, p0.y), speed: speed);
      } else if (p0.y < p2.y) {
        // 右上
        camera.moveTo(Vector2(mapSize.x - viewportSize.x, p2.y), speed: speed);
      }
    } else if (p0.x > p1.x && p0.x < p2.x && p0.y > p1.y) {
      // 底中
      camera.moveTo(Vector2(p0.x - viewportSize.x / 2, 0), speed: speed);
    } else if (p0.x > p1.x && p0.x < p2.x && p0.y < p2.y) {
      // 顶中
      camera.moveTo(Vector2(p0.x - viewportSize.x / 2, p2.y), speed: speed);
    } else {
      camera.moveTo(
          Vector2(p0.x - viewportSize.x / 2, p0.y + viewportSize.y / 2),
          speed: speed);
    }
  }
}
