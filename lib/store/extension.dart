import '../index.dart';

extension ExtensionStickSymbol on StickSymbol {
  String asString() => this == StickSymbol.self ? "self" : "enemy";
}
