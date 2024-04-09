enum AttributeCategory {
  health /* 生命 */,
  energy /* 精气 */,
  attack /* 攻击 */,
  defense /* 防御 */,
  penetration /* 破甲 */,
  critical /* 暴击 6501 -> 65.01% */,
  resistCritical /* 抗暴 2334 -> 23.34% */,
  dodge /* 闪避 3404 -> 23.04% */,
  resistDodge /* 命中 5543 -> 55.43% */,
}

class Skill {
  final String id;
  final int protoId;
  final int level;

  Skill(this.id, this.protoId, this.level);
}
