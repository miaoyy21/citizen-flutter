import '../index.dart';

class ConfigurationStore {
  static final ConfigurationStore _instance = ConfigurationStore._internal();

  factory ConfigurationStore() => _instance;

  ConfigurationStore._internal();

  late ProtoLanguage language;
  late Map<EquipColor, String> equipAssets;

  late ProtoPlayer player;
  late List<ProtoEquip> equips;
  late List<ProtoCard> cards;
  late List<ProtoProp> props;
  late List<ProtoMate> mates;

  load() async {
    final js = await rootBundle.loadString("assets/configuration.json");


  }
}
