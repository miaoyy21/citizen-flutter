enum EquipColor { black, red, green, blue }

enum EquipQuality {
  defective /*残品*/,
  substandard /*次品*/,
  ordinary /*凡品*/,
  fine /*精品*/,
  rare /*珍品*/
}

class EquipAttribute {
  final bool isNatural;

  final int protoId;

  /* 非天然：镶嵌的卡片模版ID */
  final


  EquipAttribute

  (

  this

      .

  isNatural

  );
}

/* 白、绿、蓝、紫、橙、红 */

// 装备
class EquipItem {
  final String id;
  final int protoId;

  final EquipColor color;
  final EquipQuality quality;

  EquipItem(this.id, this.protoId, this.color, this.quality);
}

enum CardAttributeCategory {
  maxHealth,
  maxEnergy,
  attack,
  defense,
  penetration,
  armor,
  critical,
}

// 卡片
class CardItem {
  final String id;
  final int protoId;
  final int qty;

  CardItem(this.id, this.protoId, this.qty);
}

// 道具
class PropItem {
  final String id;
  final int protoId;
  final int qty;

  PropItem(this.id, this.protoId, this.qty);
}

// 材料
class MateItem {
  final String id;
  final int protoId;
  final int qty;

  MateItem(this.id, this.protoId, this.qty);
}
