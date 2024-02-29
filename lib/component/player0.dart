// import 'dart:math';
//
// import '../index.dart';
//
// class Player extends SpriteComponent
//     with HasGameReference<CitizenGame>, CollisionCallbacks {
//   Player({super.position})
//       : super(anchor: Anchor.bottomLeft, key: ComponentKey.named("player"));
//
//   late Direction direction = Direction.right;
//   late Animation animation = Animation.idleRight;
//
//   static const int designFPS = 12;
//
//   // 空闲
//   late List<Sprite?> idleLeft;
//   late List<Sprite?> idleRight;
//
//   // 走路
//   late List<Sprite?> walkLeft;
//   late List<Sprite?> walkRight;
//
//   // 奔跑
//   late List<Sprite?> runLeft;
//   late List<Sprite?> runRight;
//
//   // 跳跃
//   late List<Sprite?> jumpLeft;
//   late List<Sprite?> jumpRight;
//
//   // 跳跃用手攻击
//   late List<Sprite?> jumpHand1Left;
//   late List<Sprite?> jumpHand1Right;
//   late List<Sprite?> jumpHand2Left;
//   late List<Sprite?> jumpHand2Right;
//
//   // 跳跃用脚攻击
//   late List<Sprite?> jumpFoot1Left;
//   late List<Sprite?> jumpFoot1Right;
//   late List<Sprite?> jumpFoot2Left;
//   late List<Sprite?> jumpFoot2Right;
//
//   // 蹲下
//   late List<Sprite?> squatLeft;
//   late List<Sprite?> squatRight;
//
//   // 蹲下用手攻击
//   late List<Sprite?> squatHand1Left;
//   late List<Sprite?> squatHand1Right;
//   late List<Sprite?> squatHand2Left;
//   late List<Sprite?> squatHand2Right;
//
//   // 蹲下用脚攻击
//   late List<Sprite?> squatFoot1Left;
//   late List<Sprite?> squatFoot1Right;
//   late List<Sprite?> squatFoot2Left;
//   late List<Sprite?> squatFoot2Right;
//
//   late double speed = 0; // 初始速度
//   late double onTime = 0;
//   List<Sprite?> frames = [];
//
//   @override
//   Future<void> onLoad() async {
//     final s6001 =
//         List.generate(20, (i) => i + 1).map((i) => "6001_$i.png").toList();
//     final s8001 =
//         List.generate(41, (i) => i + 1).map((i) => "8001_$i.png").toList();
//     final s9101 =
//         List.generate(11, (i) => i + 1).map((i) => "9101_$i.png").toList();
//     final s9201 =
//         List.generate(7, (i) => i + 1).map((i) => "9202_$i.png").toList();
//     final s9301 =
//         List.generate(4, (i) => i + 1).map((i) => "9301_$i.png").toList();
//
//     idleLeft = (await Flame.images.loadAll(s9101.sublist(0, 6)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     idleRight = (await Flame.images.loadAll(s9101.sublist(0, 6)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     walkLeft = (await Flame.images.loadAll(s9101.sublist(6, 11)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     walkRight = (await Flame.images.loadAll(s9101.sublist(6, 11)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     runLeft = (await Flame.images.loadAll(s9201))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     runRight = (await Flame.images.loadAll(s9201))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//
//     jumpLeft = (await Flame.images.loadAll(s8001.sublist(0, 10)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     jumpRight = (await Flame.images.loadAll(s8001.sublist(0, 10)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//
//     jumpHand1Left = (await Flame.images.loadAll(s8001.sublist(10, 17)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     jumpHand1Right = (await Flame.images.loadAll(s8001.sublist(10, 17)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     jumpHand2Left = (await Flame.images.loadAll(s8001.sublist(25, 34)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     jumpHand2Right = (await Flame.images.loadAll(s8001.sublist(25, 34)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//
//     jumpFoot1Left = (await Flame.images.loadAll(s8001.sublist(17, 25)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     jumpFoot1Right = (await Flame.images.loadAll(s8001.sublist(17, 25)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     jumpFoot2Left = (await Flame.images.loadAll(s8001.sublist(34, 41)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     jumpFoot2Right = (await Flame.images.loadAll(s8001.sublist(34, 41)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//
//     squatLeft = (await Flame.images.loadAll(s9301.sublist(0, 2)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     squatRight = (await Flame.images.loadAll(s9301.sublist(2, 4)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//
//     squatHand1Left = (await Flame.images.loadAll(s6001.sublist(0, 4)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     squatHand1Right = (await Flame.images.loadAll(s6001.sublist(0, 4)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     squatHand2Left = (await Flame.images.loadAll(s6001.sublist(8, 14)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     squatHand2Right = (await Flame.images.loadAll(s6001.sublist(8, 14)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//
//     squatFoot1Left = (await Flame.images.loadAll(s6001.sublist(4, 8)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     squatFoot1Right = (await Flame.images.loadAll(s6001.sublist(4, 8)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     squatFoot2Left = (await Flame.images.loadAll(s6001.sublist(14, 20)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//     squatFoot2Right = (await Flame.images.loadAll(s6001.sublist(14, 20)))
//         .map((img) => SpriteComponent.fromImage(img).sprite)
//         .toList();
//
//     // 初始帧为向右站立
//     final empty = await Flame.images.load("empty.png");
//     sprite = SpriteComponent.fromImage(empty).sprite;
//     resetFrames(idleRight);
//   }
//
//   bool repeat = false;
//
//   finished() {
//     repeat = false;
//   }
//
//   resetFrames(List<Sprite?> newFrames) {
//     frames.clear();
//     frames.addAll(newFrames);
//   }
//
//   double get currentTime =>
//       DateTime.now().microsecondsSinceEpoch.toDouble() /
//       Duration.microsecondsPerSecond;
//
//   // 按方向键产生的角色动作
//   arrowAnimation(
//       AnimationEvent event, Direction newDirection, double newSpeed) {
//     if (animation != Animation.idleLeft && animation != Animation.idleRight) {
//       if (event == AnimationEvent.run) {
//         // 允许由走转为跑
//         if (animation != Animation.walkLeft &&
//             animation != Animation.walkRight) {
//           return;
//         }
//       } else if (event == AnimationEvent.jump) {
//         // 允许由跑转为跳
//         if (animation != Animation.runLeft && animation != Animation.runRight) {
//           return;
//         }
//       } else if (event == AnimationEvent.squat) {
//         // 允许由跑转为蹲
//         if (animation != Animation.runLeft && animation != Animation.runRight) {
//           return;
//         }
//       } else {
//         return;
//       }
//     }
//
//     if (newDirection != Direction.repeat) {
//       direction = newDirection;
//     }
//
//     onTime = 0;
//     repeat = true;
//     speed = newSpeed;
//     if (event == AnimationEvent.walk) {
//       if (direction == Direction.left) {
//         animation = Animation.walkLeft;
//         resetFrames(walkLeft);
//       } else {
//         animation = Animation.walkRight;
//         resetFrames(walkRight);
//       }
//     } else if (event == AnimationEvent.run) {
//       if (direction == Direction.left) {
//         animation = Animation.runLeft;
//         resetFrames(runLeft);
//       } else {
//         animation = Animation.runRight;
//         resetFrames(runRight);
//       }
//     } else if (event == AnimationEvent.jump) {
//       if (direction == Direction.left) {
//         animation = Animation.jumpLeft;
//         resetFrames(jumpLeft);
//       } else {
//         animation = Animation.jumpRight;
//         resetFrames(jumpRight);
//       }
//     } else if (event == AnimationEvent.squat) {
//       debugPrint("正在向下蹲00000");
//       if (direction == Direction.left) {
//         animation = Animation.squatDownLeft;
//         resetFrames(squatLeft);
//       } else {
//         animation = Animation.squatDownRight;
//         resetFrames(squatRight);
//       }
//     }
//   }
//
//   // 按快捷键产生的角色动作，包括手拳、脚、投掷
//   shortcutSpecialEvent(ShortcutAnimationEvent event, double newSpeed) {
//     if (animation != Animation.idleLeft && animation != Animation.idleRight) {
//       // 是否可以将跳跃改为跳跃用手或用脚攻击
//       if (animation == Animation.jumpLeft || animation == Animation.jumpRight) {
//         final index = (onTime * designFPS).floor();
//         if (index <= 4) {
//           // 随机1个动作
//           final List<Sprite?> switchFrames;
//           if (event == ShortcutAnimationEvent.hand) {
//             if (Random.secure().nextBool()) {
//               if (direction == Direction.left) {
//                 switchFrames = jumpHand1Left;
//               } else {
//                 switchFrames = jumpHand1Right;
//               }
//             } else {
//               if (direction == Direction.left) {
//                 switchFrames = jumpHand2Left;
//               } else {
//                 switchFrames = jumpHand2Right;
//               }
//             }
//           } else {
//             if (Random.secure().nextBool()) {
//               if (direction == Direction.left) {
//                 switchFrames = jumpFoot1Left;
//               } else {
//                 switchFrames = jumpFoot1Right;
//               }
//             } else {
//               if (direction == Direction.left) {
//                 switchFrames = jumpFoot2Left;
//               } else {
//                 switchFrames = jumpFoot2Right;
//               }
//             }
//           }
//
//           repeat = false;
//           animation = Animation.attack;
//           frames.removeRange(5, 10);
//           frames.addAll(switchFrames);
//         }
//       } else if (animation == Animation.squatLeft ||
//           animation == Animation.squatRight) {
//         debugPrint("${animation.name}");
//         repeat = false;
//         animation = Animation.attack;
//         if (event == ShortcutAnimationEvent.hand) {
//           if (Random.secure().nextBool()) {
//             if (direction == Direction.left) {
//               resetFrames(squatHand1Left);
//             } else {
//               resetFrames(squatHand1Right);
//             }
//           } else {
//             if (direction == Direction.left) {
//               resetFrames(squatHand2Left);
//             } else {
//               resetFrames(squatHand2Right);
//             }
//           }
//         } else {
//           if (Random.secure().nextBool()) {
//             if (direction == Direction.left) {
//               resetFrames(squatFoot1Left);
//             } else {
//               resetFrames(squatFoot1Right);
//             }
//           } else {
//             if (direction == Direction.left) {
//               resetFrames(squatFoot2Left);
//             } else {
//               resetFrames(squatFoot2Right);
//             }
//           }
//         }
//       }
//
//       return;
//     }
//   }
//
//   @override
//   void update(double dt) {
//     onTime = onTime + dt;
//     final index = (onTime * designFPS).floor();
//     sprite = frames[index];
//
//     // 如果是最后一帧，并且不再重复（动作已完成），切换到空闲状态
//     if (index + 1 == frames.length) {
//       onTime = 0;
//       if (animation == Animation.squatDownLeft) {
//         animation = Animation.squatLeft;
//         resetFrames(squatLeft.getRange(1, 2).toList());
//       } else if (animation == Animation.squatDownRight) {
//         animation = Animation.squatRight;
//         resetFrames(squatRight.getRange(1, 2).toList());
//       } else if (!repeat) {
//         if (animation == Animation.squatLeft) {
//           animation = Animation.squatUpLeft;
//           resetFrames(squatLeft..reverse);
//         } else if (animation == Animation.squatRight) {
//           animation = Animation.squatUpRight;
//           resetFrames(squatRight..reverse);
//         } else {
//           speed = 0;
//           if (direction == Direction.left) {
//             animation = Animation.idleLeft;
//             resetFrames(idleLeft);
//           } else if (direction == Direction.right) {
//             animation = Animation.idleRight;
//             resetFrames(idleRight);
//           }
//         }
//       }
//     }
//
//     // 水平移动
//     position.add(Vector2(speed * dt, 0));
//   }
//
//   @override
//   void onCollisionStart(
//     Set<Vector2> intersectionPoints,
//     PositionComponent other,
//   ) {
//     super.onCollisionStart(intersectionPoints, other);
//
//     // debugPrint("Player onCollisionStart ${(other as NPC).id}");
//   }
//
//   @override
//   void onCollisionEnd(PositionComponent other) {
//     super.onCollisionEnd(other);
//
//     // debugPrint("Player onCollisionEnd ${(other as NPC).id}");
//   }
// }
