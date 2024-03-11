import '../index.dart';

extension ExtensionStickSymbol on StickSymbol {
  String asString() => this == StickSymbol.self ? "self" : "enemy";
}

extension ExtensionStickDirection on StickDirection{
  String asString() => this == StickDirection.left ? "left" : "right";
}