import '../index.dart';

class Player extends SpriteComponent
    with HasGameReference<CitizenGame>, CollisionCallbacks {
  Player({super.position})
      : super(anchor: Anchor.bottomLeft, key: ComponentKey.named("player"));

  static const int designFPS = 12;

  late double speed = 0; // 初始速度
  late double onTime = 0;
  final List<Sprite?> frames = [];

  late StickDirection direction = StickDirection.right;
  late StickAnimationEvent event = StickAnimationEvent.idle;

  @override
  Future<void> onLoad() async {
    // 初始帧为向右站立
    final empty = await Flame.images.load("empty.png");
    sprite = SpriteComponent.fromImage(empty).sprite;
  }

  @override
  void update(double dt) {
    if (event == StickAnimationEvent.idle) {
      // 接受新的键盘输入按键
      if (KeyStore().isRepeat(LogicalKeyboardKey.arrowLeft)) {
        // 向左跑
        event = StickAnimationEvent.run;
        direction = StickDirection.left;
        debugPrint("向左跑");
      } else if (KeyStore().isRepeat(LogicalKeyboardKey.arrowRight)) {
        // 向右跑
        event = StickAnimationEvent.run;
        direction = StickDirection.right;
        debugPrint("向右跑");
      } else if (KeyStore().isDouble(LogicalKeyboardKey.arrowLeft)) {
        // TODO 向左跳跃
        event = StickAnimationEvent.walk;
        direction = StickDirection.left;
        debugPrint("TODO 向左跳跃 => 向左走");
      } else if (KeyStore().isDouble(LogicalKeyboardKey.arrowRight)) {
        // TODO 向右跳跃
        event = StickAnimationEvent.walk;
        direction = StickDirection.right;
        debugPrint("TODO 向右跳跃 => 向右走");
      } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowLeft)) {
        // 向左走
        event = StickAnimationEvent.walk;
        direction = StickDirection.left;
        debugPrint("向左走");
      } else if (KeyStore().isSingle(LogicalKeyboardKey.arrowRight)) {
        // 向右走
        event = StickAnimationEvent.walk;
        direction = StickDirection.right;
        debugPrint("向右走");
      } else if (KeyStore().isRepeat(LogicalKeyboardKey.arrowUp) ||
          KeyStore().isSingle(LogicalKeyboardKey.arrowUp)) {
        // 向上跳
        event = StickAnimationEvent.jumpUp;
        debugPrint("向上跳");
      } else if (KeyStore().isRepeat(LogicalKeyboardKey.arrowDown) ||
          KeyStore().isSingle(LogicalKeyboardKey.arrowDown)) {
        // 向下蹲
        event = StickAnimationEvent.squatHalf;
        debugPrint("向下蹲");
      }

      // 重置动画序列
      if (event != StickAnimationEvent.idle) {
        onTime = 0;

        frames.clear();
        frames.addAll(AnimationStore().getFrames(event, direction)!);
      }

      // 按帧播放
      if (frames.isEmpty) {
        onTime = 0;
        frames.addAll(
            AnimationStore().getFrames(StickAnimationEvent.idle, direction)!);
      }
    }

    onTime = onTime + dt;

    final index = (onTime * designFPS).floor();
    sprite = frames[index];

    // 动作结束
    final nextTime = onTime + dt; // 阻止最后1帧播放时间播放时间太短的问题
    if ((nextTime * designFPS).floor() == frames.length) {
      onTime = 0;
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    // debugPrint("Player onCollisionStart ${(other as NPC).id}");
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    // debugPrint("Player onCollisionEnd ${(other as NPC).id}");
  }
}
