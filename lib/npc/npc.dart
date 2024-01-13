import 'package:citizen/npc/direction.dart';

import '../index.dart';

class NPC {
  final String id; // ID
  final String protoId; // 对应的资源ID
  final String name; // 名称
  final Vector2 size; // 对应的资源图片尺寸
  final Direction direction; // 方向 上下左右
  final List<String> tags; // 口头禅

  NPC(this.id, this.protoId, this.name, this.size, this.direction, this.tags);

  // 所在位置，默认为(0,0)
  Vector2 _position = Vector2.zero();

  Vector2 get position => _position;

  set position(Vector2 value) {
    _position = value;
  }

// TODO 获取对应的资源动画
}
