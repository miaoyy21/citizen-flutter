import 'dart:convert';

import '../index.dart';

class ProtoStore {
  static final ProtoStore _instance = ProtoStore._internal();

  factory ProtoStore() => _instance;

  ProtoStore._internal();

  late ProtoLanguage language;
  late Map<EquipColor, String> equipAssets;

  late ProtoPlayer player;
  late List<ProtoEquip> equips;
  late List<ProtoCard> cards;
  late List<ProtoProp> props;
  late List<ProtoMate> mates;

  load() async {
    final js = jsonDecode(await rootBundle.loadString("assets/proto.json"));

    language = ProtoLanguage.fromJson(js["language"]);
    equipAssets = (js["equip_assets"] as Map).map(
      (key, value) => MapEntry(
          EquipColor.values
              .firstWhere((color) => color.index == int.parse(key)),
          value),
    );
    player = ProtoPlayer.fromJson(js["player"]);
    equips = (js["equips"] as List)
        .map((equip) => ProtoEquip.fromJson(equip))
        .toList();
    cards =
        (js["cards"] as List).map((card) => ProtoCard.fromJson(card)).toList();
    props =
        (js["props"] as List).map((prop) => ProtoProp.fromJson(prop)).toList();
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
