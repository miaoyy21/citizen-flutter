enum PlayerColor { black, red, blue, green }

enum AttributeCategory {
  health /* 生命 */,
  energy /* 精力 */,
  /*
    当攻击值比防御值高时，相减后为实际攻击伤害；
    当攻击值比防御值低时，强制造成1点攻击伤害。
  */
  attack /* 攻击 */,
  defense /* 防御 */,
  /*
    当破甲值比护甲值高时，相减后的每点破甲值转为1%的伤害加成；
    当破甲值比护甲值低时，相减后的每点护甲值转为1%的伤害吸收。
  */
  penetration /* 破甲 6321 */,
  armor /* 护甲 3478 */,
  /*
    当暴击率比抗暴率高时，相减后为实际暴击率；
    当暴击率比抗暴率低时，不会产生暴击。
  */
  critical /* 暴击 6501 -> 65.01% */,
  resistCritical /* 抗暴 2334 -> 23.34% */,
  /*
    初始的命中值为10000，也就是100%；
    闪避率的最高上限为10000，也就是100%；
    当命中率比闪避率高时，相减后为实际命中率；
    不会出现命中率比闪避率低的情况。
  */
  accuracy /* 命中 5543 -> 55.43% */,
  resistAccuracy /* 闪避 3404 -> 23.04% */,
}

class Skill {
  final String id;
  final int protoId;
  final int level;

  Skill(this.id, this.protoId, this.level);
}
