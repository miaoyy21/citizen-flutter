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

  final List<LocalGameKey> keys = [];

  // 注意，按键是尾部添加，离现在最近的按键在尾部
  add(RawKeyEvent event) {
    final time = currentTime();
    keys.removeWhere((ele) => (time - ele.time) > 0.75);
    final key = LocalGameKey(event.logicalKey, event.repeat, time);
    if (event.repeat && keys.isNotEmpty) {
      keys.removeWhere((ele) => ele.key == event.logicalKey);
    }

    keys.add(key);
  }

  // 是否连续按下某键至少2次
  bool isDouble(LogicalKeyboardKey key) {
    final time = currentTime();
    keys.removeWhere((ele) => (time - ele.time) > 0.75);
    if (keys.length < 2) return false;

    return keys
        .sublist(keys.length - 2, keys.length)
        .every((ele) => ele.key == key && !ele.repeat);
  }

  // 最后一次是否按下某键，并且不是连续按着
  bool isSingle(LogicalKeyboardKey key) {
    final time = currentTime();
    keys.removeWhere((ele) => (time - ele.time) > 0.75);
    if (keys.isEmpty) return false;

    return keys.last.key == key && !keys.last.repeat;
  }

  // 是否连续按着某键
  bool isRepeat(LogicalKeyboardKey key) {
    final time = currentTime();
    keys.removeWhere((ele) => (time - ele.time) > 0.75);
    if (keys.isEmpty) return false;

    return keys.last.key == key && keys.last.repeat;
  }

//
// // 是否按下某键【优先级最低】
// bool isKey(LogicalKeyboardKey key) {
//   if (keys.isEmpty) return false;
//
//   return keys.last.key == key;
// }
//
// // 是否连续按键不放【优先级中等】
// bool isLastRepeat(LogicalKeyboardKey key) {
//   if (keys.isEmpty) return false;
//
//   return keys.last.key == key && keys.last.repeat;
// }
//
// // 是否连续按键不放【优先级中等】
// bool isAnyRepeat(LogicalKeyboardKey key) {
//   if (keys.isEmpty) return false;
//
//   return keys.any((ele) => ele.key == key && ele.repeat);
// }
//
// // 是否连续按下2次按键【优先级最高】
// bool isTwice(LogicalKeyboardKey key) {
//   if (keys.length < 2) {
//     return false;
//   }
//
//   final temp = keys.sublist(keys.length - 2);
//   return temp.first.key == key && temp.first.key == temp.last.key;
// }
}
