import 'package:citizen/index.dart';

class PlayerStore {
  static final PlayerStore _instance = PlayerStore._internal();

  factory PlayerStore() => _instance;

  PlayerStore._internal();

  late PlayerData data;

  load() async {
    // 玩家属性
    final Map<AttributeCategory, int> attributes = {
      AttributeCategory.health: 24745,
      AttributeCategory.energy: 398,
      AttributeCategory.attack: 2343,
      AttributeCategory.defense: 1201,
      AttributeCategory.penetration: 1402,
      AttributeCategory.critical: 6501,
      AttributeCategory.resistCritical: 2334,
      AttributeCategory.dodge: 3404,
      AttributeCategory.resistDodge: 5543,
    };

    // 物品
    final List<Item> items = [];

    // 技能
    final List<Skill> skills = [];

    data =
        PlayerData("player1", 35891020, 56328601294, attributes, items, skills);
  }
}
