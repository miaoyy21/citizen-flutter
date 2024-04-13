import 'index.dart';

enum EquipColor { _, red, orange, yellow, green, cyan, blue, purple }

enum MateCategory { _, mineralOriginal, mineralSemi, mineralFinished }

enum EquipQuality {
  common /*[0] 普通 白*/,
  excellent /*[1] 精良 绿*/,
  outstanding /*[2] 卓越 蓝*/,
  epic /*[3] 史诗 紫*/,
  legendary /*[4] 传说 橙*/,
  mythical /*[5] 神话 红*/
}

class EquipAttribute {
  final bool isNatural;

  /*
    非天然属性时，代表镶嵌的卡片模版ID
    当卡片模版ID为0时，表示尚未镶嵌卡片；
    当卡片模版ID非0时，表示已镶嵌对应的卡片；
    不同的非天然属性，不允许镶嵌相同模版ID的卡片
  */
  final int? protoId;

  // 天然属性值
  final AttributeCategory? naturalAttribute;
  final int? naturalValue;

  EquipAttribute(this.isNatural,
      {this.protoId, this.naturalAttribute, this.naturalValue});
}

// 装备
class EquipItem {
  final String id; // 装备ID
  final int protoId; // 装备模版ID

  final EquipColor color; // 装备颜色
  final EquipQuality quality; // 装备品质

  /* 根据属性数量显示装备颜色：[1]绿、[2]蓝、[3]紫、[4]橙、[5]红 */
  final List<EquipAttribute> attributes;

  final int createAt; // 产出时间

  EquipItem(this.id, this.protoId, this.color, this.quality, this.attributes,
      this.createAt);
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
