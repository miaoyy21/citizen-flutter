class AttackData {
  final int start;
  final int end;
  final String type;

  final int vSpeed;
  final int vAccelerate;
  final int hSpeed;
  final int hAccelerate;

  AttackData(
      {required this.start,
      required this.end,
      required this.type,
      required this.vSpeed,
      required this.vAccelerate,
      required this.hSpeed,
      required this.hAccelerate});

  factory AttackData.fromJson(Map<String, dynamic> js) => AttackData(
        start: js["start"],
        end: js["end"],
        type: js["type"],
        vSpeed: js["v_speed"],
        vAccelerate: js["v_accelerate"],
        hSpeed: js["h_speed"],
        hAccelerate: js["h_accelerate"],
      );

  @override
  String toString() => "{start:$start, end:$end, type:$type, "
      "vSpeed:$vSpeed, vAccelerate:$vAccelerate, hSpeed:$hSpeed, hAccelerate:$hAccelerate}";
}
