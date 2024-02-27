import '../index.dart';

class PlayerCamera extends Component with HasGameReference<CitizenGame> {
  final JoystickPlayer player;
  final Vector2 tileSize;

  PlayerCamera(this.player, this.tileSize);

  CameraComponent get camera => game.camera;

  @override
  FutureOr<void> onLoad() {
    camera.viewport.add(player.joystick);

    camera.viewfinder.anchor = Anchor.bottomLeft;
  }

  @override
  void update(double dt) {
    // if (dt > 0.01 && !player.joystick.isDragged) return;

    // final size = (camera.viewport as FixedResolutionViewport).resolution;
    // final position = player.position;
    //
    // final x1 = tileSize.x / 2 - (tileSize.x - size.x) / 2;
    // final x2 = tileSize.x / 2 + (tileSize.x - size.x) / 2;
    // final y1 = tileSize.y / 2 - (tileSize.y - size.y) / 2;
    // final y2 = tileSize.y / 2 + (tileSize.y - size.y) / 2;
    // if (position.x < x1) {
    //   if (position.y < y1) {
    //     camera.moveTo(Vector2(x1, y1));
    //   } else if (position.y >= y1 && position.y <= y2) {
    //     camera.moveTo(Vector2(x1, position.y));
    //   } else {
    //     camera.moveTo(Vector2(x1, y2));
    //   }
    // } else if (position.x > x2) {
    //   if (position.y < y1) {
    //     camera.moveTo(Vector2(x2, y1));
    //   } else if (position.y >= y1 && position.y <= y2) {
    //     camera.moveTo(Vector2(x2, position.y));
    //   } else {
    //     camera.moveTo(Vector2(x2, y2));
    //   }
    // } else if (position.y < y1) {
    //   if (position.x < x1) {
    //     camera.moveTo(Vector2(x1, y1));
    //   } else if (position.x >= x1 && position.x <= x2) {
    //     camera.moveTo(Vector2(position.x, y1));
    //   } else {
    //     camera.moveTo(Vector2(x2, y1));
    //   }
    // } else if (position.y > y2) {
    //   if (position.x < x1) {
    //     camera.moveTo(Vector2(x1, y2));
    //   } else if (position.x >= x1 && position.x <= x2) {
    //     camera.moveTo(Vector2(position.x, y2));
    //   } else {
    //     camera.moveTo(Vector2(x2, y2));
    //   }
    // } else {
    //   camera.follow(player);
    // }
  }
}
