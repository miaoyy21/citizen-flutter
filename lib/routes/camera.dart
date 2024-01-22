import '../index.dart';

class CameraView {
  final CameraComponent camera;
  final JoystickPlayer player;
  final Vector2 tileSize;

  CameraView(this.camera, this.player, this.tileSize);

  refresh() {
    final resolutionSize =
        (camera.viewport as FixedResolutionViewport).resolution;

    final p0 = player.position;

    final x1 = tileSize.x / 2 - (tileSize.x - resolutionSize.x) / 2;
    final x2 = tileSize.x / 2 + (tileSize.x - resolutionSize.x) / 2;
    final y1 = tileSize.y / 2 - (tileSize.y - resolutionSize.y) / 2;
    final y2 = tileSize.y / 2 + (tileSize.y - resolutionSize.y) / 2;
    if (p0.x < x1 || p0.x > x2 || p0.y < y1 || p0.y > y2) {
      if (p0.x < x1) {
        if (p0.y < y1) {
          camera.moveTo(Vector2(x1, y1));
        } else if (p0.y >= y1 && p0.y <= y2) {
          camera.moveTo(Vector2(x1, p0.y));
        } else {
          camera.moveTo(Vector2(x1, y2));
        }
      }

      if (p0.x > x2) {
        if (p0.y < y1) {
          camera.moveTo(Vector2(x2, y1));
        } else if (p0.y >= y1 && p0.y <= y2) {
          camera.moveTo(Vector2(x2, p0.y));
        } else {
          camera.moveTo(Vector2(x2, y2));
        }
      }

      if (p0.y < y1) {
        if (p0.x < x1) {
          camera.moveTo(Vector2(x1, y1));
        } else if (p0.x >= x1 && p0.x <= x2) {
          camera.moveTo(Vector2(p0.x, y1));
        } else {
          camera.moveTo(Vector2(x2, y1));
        }
      }

      if (p0.y > y2) {
        if (p0.x < x1) {
          camera.moveTo(Vector2(x1, y2));
        } else if (p0.x >= x1 && p0.x <= x2) {
          camera.moveTo(Vector2(p0.x, y2));
        } else {
          camera.moveTo(Vector2(x2, y2));
        }
      }
    } else {
      camera.follow(player);
    }
  }
}
