// 角色方向
enum Direction { left, right, repeat } // repeat 重复上一次方向

// 键盘事件
enum AnimationEvent { walk, run, jump, squat }

// 动作
enum Animation {
  idleLeft, // 面向左，空闲状态
  idleRight, // 面向右，空闲状态
  walkLeft, // 向左走路
  walkRight, // 向右走路
  runLeft, // 向左奔跑
  runRight, // 向右奔跑
  jumpLeft, // 向左，原地向上跳跃
  jumpRight, // 向右，原地向上跳跃
  squatLeft, // 向左，原地蹲下
  squatRight, // 向右，原地蹲下

  attack,
}

enum ShortcutAnimationEvent { hand, foot }
