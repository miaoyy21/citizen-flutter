import 'package:citizen/index.dart';

class PlayerStore {
  static final PlayerStore _instance = PlayerStore._internal();

  factory PlayerStore() => _instance;

  PlayerStore._internal();

  late String id;
  late String name;
  late PlayerColor color;
  late int health;
  late int energy;
  late int gold;
  late int exp;

  late int unread;

  late Map<AttributeCategory, int> attributes;
  late List<EquipItem> equips;
  late List<CardItem> cards;
  late List<PropItem> props;
  late List<MateItem> mates;
  late List<Skill> skills;

  load() async {
    id = "player1"; /* 玩家ID */
    name = "雨晴"; /* 玩家名 */
    color = PlayerColor.red; /* 玩家颜色 */
    health = 3127; /* 当前生命值 */
    energy = 596; /* 当前精气值 */
    gold = 358931020; /* 金币 */
    exp = 56328601294; /* 经验值 */
    unread = 12; /* 未读邮件数量 */

    // 玩家属性
    attributes = {
      AttributeCategory.health: 24745,
      AttributeCategory.energy: 398,
      AttributeCategory.attack: 2343,
      AttributeCategory.defense: 1201,
      AttributeCategory.penetration: 6321,
      AttributeCategory.armor: 3478,
      AttributeCategory.critical: 6501,
      AttributeCategory.resistCritical: 2334,
      AttributeCategory.accuracy: 12543,
      AttributeCategory.resistAccuracy: 3404,
    };

    // 装备
    equips = [];

    // 卡片
    cards = [];

    // 道具
    props = [];

    // 材料
    mates = [];

    // 技能
    skills = [];
  }
}
