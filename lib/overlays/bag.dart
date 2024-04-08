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
    BagItem(3, "道具")
  ];

  late BagItem selected = items.first;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontFamily: "YeZiGongChangYouLongXingKai");
    final primary = Theme.of(context).primaryColor;

    return Center(
      child: Container(
        width: 400,
        height: 480,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [BoxShadow(color: primary, blurRadius: 4)],
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
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "背包",
                    style: style.copyWith(fontSize: 30),
                    strutStyle: const StrutStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 0, indent: 20, endIndent: 20),
                DefaultTabController(
                  length: items.length,
                  child: TabBar(
                    padding: const EdgeInsets.only(top: 12),
                    dividerColor: Colors.transparent,
                    tabs: items
                        .map(
                          (src) => Tab(
                            height: 24,
                            iconMargin: EdgeInsets.zero,
                            child: Text(
                              src.name,
                              style: style.copyWith(fontSize: 18),
                            ),
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
      crossAxisCount: 5,
      children: List.generate(
        selected.id == 1
            ? 12
            : selected.id == 2
                ? 48
                : 40,
        (index) => Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.lightGreen,
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(4),
            shape: BoxShape.rectangle,
          ),
          child: Center(child: Text("$index")),
        ),
      ),
    );
  }
}
