import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.setLandscape();
  Flame.device.fullScreen();

  // final List<String> ss = ["111", "222", "333"];
  // debugPrint(jsonEncode(ss));
  //
  // final String js = jsonEncode(ss);
  // final as = json.decode(js);
  // debugPrint("${(as as List).map((s) => (s as String)).toList()}");

  runApp(GameWidget(game: CitizenGame()));
}

class CitizenGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  late final RouterComponent router;
  late final double blockSize = 32;

  CitizenGame()
      : super(
          camera: CameraComponent(
            viewport: FixedResolutionViewport(
              /* 1024 * 760 */
              resolution: Vector2(32 * 32, 23.75 * 32)..scale(0.75),
            ),
            viewfinder: Viewfinder(),
          ),
        );

  @override
  FutureOr<void> onLoad() async {
    debugPrint("111 ${DateTime.now().toIso8601String()}");
    await AnimationStore().load();
    await SkillStore().load();
    await SoundStore().load();
    debugPrint("222 ${DateTime.now().toIso8601String()}");

    add(
      router = RouterComponent(
        routes: {
          'stage01': Route(
            maintainState: false,
            () => Stage("stage01"),
          ),
          // 'level-selector': Route(LevelSelectorPage.new),
          // 'settings': Route(SettingsPage.new, transparent: true),
          // 'pause': PauseRoute(),
          // 'confirm-dialog': OverlayRoute.existing(),
        },
        initialRoute: 'stage01',
      ),
    );
    debugPrint("333 ${DateTime.now().toIso8601String()}");
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final player = findByKey<Player>(ComponentKey.named("Player"));

    if (player != null) {
      if (event is RawKeyDownEvent) {
        KeyStore().add(event);
      } else if (event is RawKeyUpEvent) {
        KeyStore().removeRepeat(event.logicalKey);
      }

      // debugPrint("RawKeyEvent => ${KeyStore().showKeys}");
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
