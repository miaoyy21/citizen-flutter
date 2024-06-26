import '../index.dart';

class Enemy extends SpriteComponent
    with HasGameReference<CitizenGame>, CollisionCallbacks {
  final int id;
  final Stage stage;
  final StickCape cape;
  final StickEffect effect;
  final Color color;

  Enemy(this.id, this.stage, this.cape, this.effect, this.color,
      {super.position})
      : super(anchor: Anchor.bottomCenter);

  late double onTime = 0;
  late double speedRate = 0; // 速度比
  late StickDirection direction = StickDirection.left;
  late AnimationFrames _aniFrames;

  late AnimationFrameData frame;
  late AnimationFrameData byFrame;

  @override
  FutureOr<void> onLoad() async {
    final empty = await Flame.images.load("empty.png");
    sprite = SpriteComponent.fromImage(empty).sprite;
    _aniFrames = AnimationStore()
        .byEvent(StickAnimationEvent.idle, StickSymbol.self, direction);
    byFrame = AnimationFrameData.invalid();

    add(
      RectangleHitbox()
        ..debugMode = true
        ..debugColor = Colors.blue,
    );

    add(ColorEffect(color, EffectController(duration: 0)));
  }

  late double dx = 0;

  AnimationFrames get aniFrames => _aniFrames;

  set aniFrames(AnimationFrames newFrames) {
    if ("$newFrames" == "$_aniFrames") {
      return;
    }

    // 帧发生变化时，计算中间移动的距离差
    int index = (onTime * stage.fps).floor();
    index = index >= _aniFrames.framesData.length
        ? _aniFrames.framesData.length - 1
        : index;
    final frame = _aniFrames.framesData[index];

    late int x = 0;

    final x1 = _aniFrames.framesData.first.position.x; // 旧 开始
    final x2 = frame.position.x; // 旧 结束
    final x3 = newFrames.framesData.first.position.x; // 新 开始
    debugPrint(
        "$_aniFrames [$index] -> $newFrames x1 = $x1, x2 = $x2, x3 = $x3 ");

    x = x2 - x3;
    if (x.abs() > 20) {
      dx = dx + x;
    }

    onTime = 0;
    _aniFrames = newFrames;
  }

  @override
  void update(double dt) {
    if (1 / dt < 50) {
      debugPrint("Enemy 每秒帧数降至 ${(1 / dt).toStringAsFixed(2)}");
    }

    if (((onTime + dt) * stage.fps).floor() >= aniFrames.frames.length ||
        aniFrames.framesData[((onTime + dt) * stage.fps).floor()].exposeBody
            .isEmpty) {
      aniFrames = AnimationStore()
          .byEvent(StickAnimationEvent.idle, StickSymbol.self, direction);
      onTime = 0;
    }

    onTime = onTime + dt;
    late int index = (onTime * stage.fps).floor();

    frame = aniFrames.framesData[index];
    sprite = aniFrames.frames[index];
    cape.sprite = aniFrames.capeFrames[index];
    if (aniFrames.effectFrames != null && aniFrames.effectFrames!.isNotEmpty) {
      effect.sprite = aniFrames.effectFrames![index];
    }else{
      effect.sprite = null;
    }

    // Position
    position.x = position.x + speedRate * stage.speed * dt + dx;
    cape.position = position;
    effect.position = position;
    dx = 0;
  }
}
