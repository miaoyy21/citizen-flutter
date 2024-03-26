import 'dart:convert';
import 'dart:math';

import '../index.dart';

class SoundData {
  final String name;
  final int sequence;
  final SoundCategory category;
  final int size;
  final List<String> audios;

  SoundData(
      {required this.name,
      required this.sequence,
      required this.category,
      required this.size,
      required this.audios});

  factory SoundData.fromJson(Map<String, dynamic> js) => SoundData(
        name: js["Name"],
        sequence: js["Sequence"],
        category:
            js["Category"] == "Blow" ? SoundCategory.blow : SoundCategory.swing,
        size: js["Size"],
        audios: (js["Audios"] as List).map((v) => v as String).toList(),
      );

  @override
  String toString() =>
      "{name:$name, sequence:$sequence, category:$category, size:$size, audios:$audios";
}

class SoundStore {
  static final SoundStore _instance = SoundStore._internal();

  factory SoundStore() => _instance;

  SoundStore._internal();

  late Map<String, List<SoundData>> _values = {};

  String? sound(String name, int sequence, SoundCategory category) {
    String? target;

    if (_values.containsKey(name)) {
      final index = _values[name]!
          .indexWhere((e) => e.sequence == sequence && e.category == category);
      if (index >= 0) {
        final List<String> ts = _values[name]![index].audios;

        target = ts[Random.secure().nextInt(ts.length)];
      }
    }

    return target;
  }

  Future load() async {
    final js = await rootBundle.loadString('assets/sounds.json');

    final Set<String> audios = {};
    _values = (jsonDecode(js) as Map).map((k, v) => MapEntry(
          k as String,
          (v as List).map((e) => SoundData.fromJson(e)).toList(),
        ));

    for (var ss in _values.values) {
      ss.map((s) => s.audios).forEach((s0) {
        audios.addAll(s0);
      });
    }

    await FlameAudio.audioCache.loadAll(audios.toList());
    debugPrint("$audios");
  }
}
