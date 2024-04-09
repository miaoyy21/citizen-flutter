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

enum ItemCategory { equip, card, prop, material }

class Item {
  final String id;
  final int protoId;
  final ItemCategory category;
  final int qty;

  Item(this.id, this.protoId, this.category, this.qty);
}

class Skill {
  final String id;
  final int protoId;
  final int level;

  Skill(this.id, this.protoId, this.level);
}

class PlayerData {
  final String id;
  final int gold;
  final int exp;

  Map<AttributeCategory, int> attributes;
  List<Item> items;
  List<Skill> skills;

  PlayerData(
    this.id,
    this.gold,
    this.exp,
    this.attributes,
    this.items,
    this.skills,
  );
}
