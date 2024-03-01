// import 'index.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   Flame.device.setLandscape();
//   Flame.device.fullScreen();
//
//   runApp(GameWidget(game: CitizenGame()));
// }
//
// class CitizenGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
//   late final RouterComponent router;
//   late final double blockSize = 32;
//
//   CitizenGame()
//       : super(
//           camera: CameraComponent(
//             viewport: FixedResolutionViewport(
//               resolution: Vector2(22.5 * 32, 16 * 32),
//             ),
//             viewfinder: Viewfinder(),
//           ),
//         );
//
//   @override
//   FutureOr<void> onLoad() async {
//     debugMode = true;
//
//     await AnimationStore().load();
//
//     add(
//       router = RouterComponent(
//         routes: {
//           'stage1': Route(
//             maintainState: false,
//             () => Stage(
//               "stage1",
//               size: Vector2(80 * blockSize, 50 * blockSize),
//             ),
//           ),
//           // 'level-selector': Route(LevelSelectorPage.new),
//           // 'settings': Route(SettingsPage.new, transparent: true),
//           // 'pause': PauseRoute(),
//           // 'confirm-dialog': OverlayRoute.existing(),
//         },
//         initialRoute: 'stage1',
//       ),
//     );
//   }
//
//   final KeyStore keyStore = KeyStore();
//
//   @override
//   KeyEventResult onKeyEvent(
//       RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
//     final player = findByKey<Player>(ComponentKey.named("player"));
//
//     if (player != null) {
//       keyStore.add(event, currentTime());
//
//       if (event is RawKeyDownEvent) {
//         if (keyStore.isKey(LogicalKeyboardKey.arrowDown)) {
//           debugPrint("向下蹲");
//           player.arrowAnimation(AnimationEvent.squat, Direction.repeat, 0);
//         } else if (keyStore.isLastRepeat(LogicalKeyboardKey.arrowLeft)) {
//           debugPrint("向左奔跑");
//           player.arrowAnimation(AnimationEvent.run, Direction.left, -200);
//         } else if (keyStore.isLastRepeat(LogicalKeyboardKey.arrowRight)) {
//           debugPrint("向右奔跑");
//           player.arrowAnimation(AnimationEvent.run, Direction.right, 200);
//         } else if (keyStore.isKey(LogicalKeyboardKey.arrowLeft)) {
//           debugPrint("向左走路");
//           player.arrowAnimation(AnimationEvent.walk, Direction.left, -100);
//         } else if (keyStore.isKey(LogicalKeyboardKey.arrowRight)) {
//           debugPrint("向右走路");
//           player.arrowAnimation(AnimationEvent.walk, Direction.right, 100);
//         } else {
//           final double newSpeed =
//               keyStore.isAnyRepeat(LogicalKeyboardKey.arrowLeft)
//                   ? -200
//                   : keyStore.isAnyRepeat(LogicalKeyboardKey.arrowRight)
//                       ? 200
//                       : 0;
//
//           if (keyStore.isKey(LogicalKeyboardKey.arrowUp)) {
//             debugPrint("向上跳");
//             player.arrowAnimation(
//                 AnimationEvent.jump, Direction.repeat, newSpeed);
//           } else {
//             if (keyStore.isKey(LogicalKeyboardKey.digit1)) {
//               debugPrint("使用【手】攻击");
//               player.shortcutSpecialEvent(
//                   ShortcutAnimationEvent.hand, newSpeed);
//             } else if (keyStore.isKey(LogicalKeyboardKey.digit2)) {
//               debugPrint("使用【脚】攻击");
//               player.shortcutSpecialEvent(
//                   ShortcutAnimationEvent.foot, newSpeed);
//             }
//           }
//         }
//       } else if (event is RawKeyUpEvent) {
//         if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
//             event.logicalKey == LogicalKeyboardKey.arrowRight) {
//           if (keyStore.isKey(LogicalKeyboardKey.arrowUp) ||
//               keyStore.isKey(LogicalKeyboardKey.arrowDown)) {
//           } else {
//             player.finished();
//           }
//         } else {
//           player.finished();
//         }
//       }
//     }
//
//     return super.onKeyEvent(event, keysPressed);
//   }
// }
