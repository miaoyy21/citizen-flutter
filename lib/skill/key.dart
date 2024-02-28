import '../index.dart';

class LocalGameKey {
  final LogicalKeyboardKey key;
  final bool repeat;
  final double time;

  LocalGameKey(this.key, this.repeat, this.time);
}

class KeyStore {
  final List<LocalGameKey> keys = [];

  KeyStore();

  bool add(RawKeyEvent event, double time) {
    if (event is! RawKeyDownEvent) {
      return false;
    }

    final key = LocalGameKey(event.logicalKey, event.repeat, time);
    if (event.repeat) {
      keys
        ..clear()
        ..add(key);
      return true;
    }

    if (keys.isEmpty) {
      keys.add(key);
      return true;
    }

    // 超过0.5秒
    if (time - keys.last.time >= 0.5) {
      keys.clear();
    } else if (keys.last.repeat) {
      keys.clear();
    }

    keys.add(key);
    return true;
  }

  // 是否连续按下2次按键
  bool isTwice(LogicalKeyboardKey key) {
    if (keys.length < 2) {
      return false;
    }

    final temp = keys.sublist(keys.length - 2);
    return temp.first.key == key && temp.first.key == temp.last.key;
  }

  // 是否连续按键不放
  bool isRepeat(LogicalKeyboardKey key) {
    if (keys.isEmpty) return false;

    return keys.last.key == key && keys.last.repeat;
  }
}
