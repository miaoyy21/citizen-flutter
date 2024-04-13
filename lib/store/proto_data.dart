import 'package:citizen/index.dart';

class ProtoLang {
  final String zhCN;
  final String zhTW;
  final String enUS;

  ProtoLang({required this.zhCN, required this.zhTW, required this.enUS});

  factory ProtoLang.fromJson(Map<String, dynamic> js) =>
      ProtoLang(zhCN: js["zh_CN"], zhTW: js["zh_TW"], enUS: js["en_US"]);

  @override
  String toString() => "{zhCN:$zhCN, zhTW:$zhTW, enUS:$enUS}";
}

class ProtoLanguage {
  final Map<String, String> zhCN;
  final Map<String, String> zhTW;
  final Map<String, String> enUS;

  ProtoLanguage({required this.zhCN, required this.zhTW, required this.enUS});

  factory ProtoLanguage.fromJson(Map<String, dynamic> js) => ProtoLanguage(
        zhCN: (js["zh_CN"] as Map).map((key, value) => MapEntry(key, value)),
        zhTW: (js["zh_TW"] as Map).map((key, value) => MapEntry(key, value)),
        enUS: (js["en_US"] as Map).map((key, value) => MapEntry(key, value)),
      );

  @override
  String toString() => "{zhCN:$zhCN, zhTW:$zhTW, enUS:$enUS}";
}

class ProtoPlayer {
  final Map<AttributeCategory, double> grow;

  ProtoPlayer({required this.grow});

  factory ProtoPlayer.fromJson(Map<String, dynamic> js) => ProtoPlayer(
        grow: (js["grow"] as Map).map((key, value) => MapEntry(
            AttributeCategory.values
                .firstWhere((category) => category.index == int.parse(key)),
            value is int ? value.toDouble() : value)),
      );

  @override
  String toString() => "{grow:$grow}";
}

class ProtoEquip {
  final int id;
  final ProtoLang name;
  final int level;

  ProtoEquip({required this.id, required this.name, required this.level});

  factory ProtoEquip.fromJson(Map<String, dynamic> js) => ProtoEquip(
        id: js["id"],
        name: ProtoLang.fromJson(js["name"]),
        level: js["level"],
      );

  @override
  String toString() => "{id:$id, name:$name, level:$level}";
}

class ProtoCard {
  final int id;
  final ProtoLang name;
  final int level;
  final ProtoLang description;
  final String assets;
  final int price;

  ProtoCard(
      {required this.id,
      required this.name,
      required this.level,
      required this.description,
      required this.assets,
      required this.price});

  factory ProtoCard.fromJson(Map<String, dynamic> js) => ProtoCard(
        id: js["id"],
        name: ProtoLang.fromJson(js["name"]),
        level: js["level"],
        description: ProtoLang.fromJson(js["description"]),
        assets: js["assets"],
        price: js["price"],
      );

  @override
  String toString() =>
      "{id:$id, name:$name, level:$level, description:$description, assets:$assets, price:$price}";
}

class ProtoProp {
  final int id;
  final ProtoLang name;
  final bool saleable;
  final int level;
  final ProtoLang description;
  final String assets;
  final int price;

  ProtoProp(
      {required this.id,
      required this.name,
      required this.saleable,
      required this.level,
      required this.description,
      required this.assets,
      required this.price});

  factory ProtoProp.fromJson(Map<String, dynamic> js) => ProtoProp(
        id: js["id"],
        name: ProtoLang.fromJson(js["name"]),
        saleable: js["saleable"],
        level: js["level"],
        description: ProtoLang.fromJson(js["description"]),
        assets: js["assets"],
        price: js["price"],
      );

  @override
  String toString() =>
      "{id:$id, name:$name, saleable:$saleable, level:$level, description:$description, assets:$assets, price:$price}";
}

class ProtoMate {
  final int id;
  final ProtoLang name;
  final MateCategory category;
  final bool isColorfulMineral;
  final ProtoLang description;
  final String assets;
  final int price;
  final ProtoMateNext? next;

  ProtoMate(
      {required this.id,
      required this.name,
      required this.category,
      required this.isColorfulMineral,
      required this.description,
      required this.assets,
      required this.price,
      this.next});

  factory ProtoMate.fromJson(Map<String, dynamic> js) => ProtoMate(
        id: js["id"],
        name: ProtoLang.fromJson(js["name"]),
        category: MateCategory.values
            .firstWhere((category) => category.index == js["category"]),
        isColorfulMineral: js["is_colorful_mineral"],
        description: ProtoLang.fromJson(js["description"]),
        assets: js["assets"],
        price: js["price"],
        next: js["next"] != null ? ProtoMateNext.fromJson(js["next"]) : null,
      );

  @override
  String toString() =>
      "{id:$id, name:$name, category:$category, isColorfulMineral:$isColorfulMineral, description:$description, assets:$assets, price:$price, next:$next}";
}

class ProtoMateNext {
  final int id;
  final int qty;
  final int gold;
  final int rate;

  ProtoMateNext(
      {required this.id,
      required this.qty,
      required this.gold,
      required this.rate});

  factory ProtoMateNext.fromJson(Map<String, dynamic> js) => ProtoMateNext(
        id: js["id"],
        qty: js["qty"],
        gold: js["gold"],
        rate: js["rate"],
      );

  @override
  String toString() => "{id:$id, qty:$qty, gold:$gold, rate:$rate}";
}
