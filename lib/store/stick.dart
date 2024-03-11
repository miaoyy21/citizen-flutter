enum StickDirection { left, right, repeat }

enum StickSymbol { self, enemy }

enum StickAnimationEvent {
  idle,
  walk,
  run,
  move,
  handAttack,
  footAttack,
  jumpUp,
  jumpDown,
  jumpHandAttack,
  jumpFootAttack,
  squatHalf,
  squat,
  squatHandAttack,
  squatFootAttack,
  skill
}

enum StickStep { start, prepare, hit, finish }
