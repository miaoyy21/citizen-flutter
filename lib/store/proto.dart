import 'dart:convert';

import '../index.dart';

class ProtoStore {
  static final ProtoStore _instance = ProtoStore._internal();

  factory ProtoStore() => _instance;

  ProtoStore._internal();

  late ProtoLanguage language;

  late Map<EquipColor, Uint8List> equipAssets = {};

  late ProtoPlayer player;
  late List<ProtoEquip> equips;
  late List<ProtoCard> cards;
  late List<ProtoProp> props;
  late List<ProtoMate> mates;

  load() async {
    final js = jsonDecode(await rootBundle.loadString("assets/proto.json"));

    // 多语言
    language = ProtoLanguage.fromJson(js["language"]);

    // 装备颜色对应的图片资源
    final equipImage = await Flame.images.load("items/equips.png");
    final equipSheet = SpriteSheet(image: equipImage, srcSize: Vector2.all(32));
    (js["equip_assets"] as Map)
        .map((key, value) =>
            MapEntry(int.parse(key), value.split("_").map((v) => int.parse(v))))
        .map((key, value) => MapEntry(
            EquipColor.values.firstWhere((color) => color.index == key),
            equipSheet
                .getSprite(value.first, value.last)
                .image
                .pixelsInUint8()))
        .forEach((key, value) async {
      equipAssets[key] = await value;
    });

    // 玩家
    player = ProtoPlayer.fromJson(js["player"]);

    // 装备
    equips = (js["equips"] as List)
        .map((equip) => ProtoEquip.fromJson(equip))
        .toList();

    // 卡片
    cards =
        (js["cards"] as List).map((card) => ProtoCard.fromJson(card)).toList();

    // 道具
    props =
        (js["props"] as List).map((prop) => ProtoProp.fromJson(prop)).toList();

    // 材料
    mates =
        (js["mates"] as List).map((mate) => ProtoMate.fromJson(mate)).toList();

    debugPrint("【配置解析】：Language: $language");
    debugPrint("【配置解析】：Equip Assets: $equipAssets");
    debugPrint("【配置解析】：Player: $player");
    debugPrint("【配置解析】：Equips: $equips");
    debugPrint("【配置解析】：Cards: $cards");
    debugPrint("【配置解析】：Props: $props");
    debugPrint("【配置解析】：Mates: $mates");
  }
}
