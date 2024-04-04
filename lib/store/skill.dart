import '../index.dart';

class SkillStore {
  static final SkillStore _instance = SkillStore._internal();

  factory SkillStore() => _instance;

  SkillStore._internal();

  late Map<LogicalKeyboardKey, String> skills;

  load() async {
    skills = {
      LogicalKeyboardKey.digit1: "1060",
      LogicalKeyboardKey.digit2: "1065",
      LogicalKeyboardKey.digit3: "1070",
      LogicalKeyboardKey.digit4: "1075",
      LogicalKeyboardKey.digit5: "1080",
      LogicalKeyboardKey.digit6: "1085",
      LogicalKeyboardKey.digit7: "1090",
      // LogicalKeyboardKey.digit8: "3030",
      // LogicalKeyboardKey.digit9: "3040",
      // LogicalKeyboardKey.digit0: "3050",
    };

    skills.forEach((key, value) {
      // 触发1次判断，是否存在异常
      debugPrint("加载技能：${key.debugName} :: $value");
      AnimationStore().byName(value, StickSymbol.self, StickDirection.right);
    });
  }
}
