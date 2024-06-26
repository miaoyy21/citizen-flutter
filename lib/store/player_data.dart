enum PlayerColor { black, red, orange, yellow, green, cyan, blue, purple }

enum AttributeCategory {
  _,
  health /* 1 生命上限 */,
  energy /* 2 精气上限 */,
  /*
    当攻击值比防御值高时，相减后为实际攻击伤害；
    当攻击值比防御值低时，强制造成1点攻击伤害。
  */
  attack /* 3 攻击 */,
  defense /* 4 防御 */,
  /*
    当破甲值比护甲值高时，相减后的每点破甲值转为1%的伤害加成；
    当破甲值比护甲值低时，相减后的每点护甲值转为1%的伤害吸收。
  */
  penetration /* 5 破甲 6321 */,
  armor /* 6 护甲 3478 */,
  /*
    当暴击率比抗暴率高时，相减后为实际暴击率；
    当暴击率比抗暴率低时，不会产生暴击。
  */
  critical /* 7 暴击 6501 -> 65.01% */,
  resistCritical /* 8 抗暴 2334 -> 23.34% */,
  /*
    初始的命中值为10000，也就是100%；
    闪避率的最高上限为10000，也就是100%；
    当命中率比闪避率高时，相减后为实际命中率；
    不会出现命中率比闪避率低的情况。
  */
  accuracy /* 9 命中 12543 -> 125.43% */,
  resistAccuracy /* 10 闪避 3404 -> 23.04% */,
}

class Skill {
  final String id;
  final int protoId;
  final int level;

  Skill(this.id, this.protoId, this.level);
}
