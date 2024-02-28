import '../index.dart';

class LocalGameKey {
  LogicalKeyboardKey key;
  bool repeat;
  double start;
  double end;

  LocalGameKey(this.key, this.repeat, this.start, this.end);
}

class KeyStore {
  final List<LocalGameKey> keys = [];

  KeyStore();

  add(RawKeyEvent event, double time) {
    final key = LocalGameKey(event.logicalKey, event.repeat, time, time);
    if (event.repeat) {
      if (keys.isNotEmpty) {
        final last = keys.last;
        if (last.key == key.key && last.repeat == key.repeat) {
          key.start = last.start;
        }
      }

      keys.clear();
      keys.add(key);
      return;
    }

    if (keys.isEmpty) {
      keys.add(key);
      return true;
    }

    // 超过0.5秒
    if (time - keys.last.end >= 0.5) {
      keys.clear();
    } else if (keys.last.repeat) {
      keys.clear();
    }

    keys.add(key);
  }

  // 是否按下某键【优先级最低】
  bool isKey(LogicalKeyboardKey key) {
    if (keys.isEmpty) return false;

    return keys.last.key == key;
  }

  // 是否连续按键不放，超过1秒才会认为按住不放【优先级中等】
  bool isRepeat(LogicalKeyboardKey key) {
    if (keys.isEmpty) return false;

    return keys.last.key == key &&
        keys.last.repeat &&
        keys.last.end - keys.last.start > 1;
  }

  // 是否连续按下2次按键【优先级最高】
  bool isTwice(LogicalKeyboardKey key) {
    if (keys.length < 2) {
      return false;
    }

    final temp = keys.sublist(keys.length - 2);
    return temp.first.key == key && temp.first.key == temp.last.key;
  }
}
