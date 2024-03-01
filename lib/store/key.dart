import '../index.dart';

class LocalGameKey {
  LogicalKeyboardKey key;
  bool repeat;
  double time;

  LocalGameKey(this.key, this.repeat, this.time);

  @override
  String toString() => "${key.debugName}:$repeat";
}

class KeyStore {
  static final KeyStore _instance = KeyStore._internal();

  factory KeyStore() => _instance;

  KeyStore._internal();

  final List<LocalGameKey> _keys = [];

  String get showKeys => "[${KeyStore()._keys.map((e) => "$e").join(", ")}]";

  // 注意，按键是尾部添加，离现在最近的按键在尾部
  add(RawKeyEvent event) {
    final time = currentTime();
    _keys.removeWhere((ele) => (time - ele.time) > 0.5 && !ele.repeat);
    final key = LocalGameKey(event.logicalKey, event.repeat, time);
    if (event.repeat && _keys.isNotEmpty) {
      _keys.removeWhere((ele) => ele.key == event.logicalKey);
    }

    _keys.add(key);
  }

  // 移除某个键盘，比如发动攻击完成，可能还不到0.5秒的情况
  remove(LogicalKeyboardKey key) {
    _keys.removeWhere((ele) => ele.key == key);
  }

  removeRepeat(LogicalKeyboardKey key) {
    _keys.removeWhere((ele) => ele.key == key && ele.repeat);
  }

  // 是否连续按下某键至少2次
  bool isDouble(LogicalKeyboardKey key) {
    final time = currentTime();
    _keys.removeWhere((ele) => (time - ele.time) > 0.5 && !ele.repeat);
    if (_keys.length < 2) return false;

    return _keys
        .sublist(_keys.length - 2, _keys.length)
        .every((ele) => ele.key == key && !ele.repeat);
  }

  // 最后一次是否按下某键，并且不是连续按着
  bool isSingle(LogicalKeyboardKey key) {
    final time = currentTime();
    _keys.removeWhere((ele) => (time - ele.time) > 0.5 && !ele.repeat);
    if (_keys.isEmpty) return false;

    return _keys.last.key == key && !_keys.last.repeat;
  }

  // 是否连续按着某键
  bool isRepeat(LogicalKeyboardKey key) {
    final time = currentTime();
    _keys.removeWhere((ele) => (time - ele.time) > 0.5 && !ele.repeat);
    if (_keys.isEmpty) return false;

    return _keys.last.key == key && _keys.last.repeat;
  }

  // 是否按下某键，包括常按和单按两种情况
  bool isDown(LogicalKeyboardKey key) {
    return isSingle(key) || isRepeat(key);
  }
}
