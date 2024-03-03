import '../index.dart';

class SkillStore {
  static final SkillStore _instance = SkillStore._internal();

  factory SkillStore() => _instance;

  SkillStore._internal();

  late Map<LogicalKeyboardKey, String> skills;

  load() async {
    skills = {
      LogicalKeyboardKey.digit3: "1010",
      LogicalKeyboardKey.digit4: "1020",
      LogicalKeyboardKey.digit5: "1030",
      LogicalKeyboardKey.digit6: "1040",
      LogicalKeyboardKey.digit7: "1050",
      LogicalKeyboardKey.digit8: "1060",
      LogicalKeyboardKey.digit9: "1070",
    };

    debugPrint("加载技能");
    skills.forEach((key, value) {
      // 触发1次判断，是否存在异常
      debugPrint("${key.debugName} :: $value");
      AnimationStore().byName(value, StickDirection.right);
    });
  }
}
