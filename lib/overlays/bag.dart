import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flame/game.dart';

Widget onBagPage(BuildContext context, Game game) {
  return BagPage(game);
}

class BagPage extends StatefulWidget {
  final Game game;

  const BagPage(this.game, {super.key});

  @override
  State<StatefulWidget> createState() => _StateBagPage();
}

class BagItem {
  final int id;
  final String name;

  BagItem(this.id, this.name);
}

class _StateBagPage extends State<BagPage> {
  final List<BagItem> items = [
    BagItem(1, "装备"),
    BagItem(2, "卡片"),
    BagItem(3, "道具"),
    BagItem(4, "材料")
  ];

  late BagItem selected = items.first;
  static const style = TextStyle(fontFamily: "Z2");

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Center(
      child: Container(
        width: 400,
        height: 360,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [BoxShadow(color: primary, blurRadius: 8)],
          shape: BoxShape.rectangle,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -8,
              right: -8,
              child: IconButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                icon: const Icon(Icons.close),
                onPressed: () {
                  widget.game.overlays.remove("BagPage");
                },
              ),
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    "背包",
                    style: style.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 0, indent: 48, endIndent: 48),
                DefaultTabController(
                  length: items.length,
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    tabs: items
                        .map(
                          (src) => Tab(
                            height: 24,
                            child: Text(src.name, style: style),
                          ),
                        )
                        .toList(),
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 2, color: primary),
                    ),
                    onTap: (index) => setState(() {
                      selected = items[index];
                    }),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                      borderRadius: BorderRadius.circular(4),
                      shape: BoxShape.rectangle,
                    ),
                    child: onBuildGridView(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget onBuildGridView() {
    return GridView.count(
      crossAxisCount: 10,
      children: List.generate(
        25 + Random.secure().nextInt(100),
        (index) => Container(
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(4),
            shape: BoxShape.rectangle,
          ),
          child: Center(child: Text("$index", style: style)),
        ),
      ),
    );
  }
}
