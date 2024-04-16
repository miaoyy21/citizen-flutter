import 'package:citizen/index.dart';
import 'package:flutter/material.dart';

class BagPage extends StatefulWidget {
  final Game game;
  final Function(String) onClose;

  const BagPage(this.game, this.onClose, {super.key});

  @override
  State<StatefulWidget> createState() => _StateBagPage();
}

class BagItem {
  final int id;
  final String name;

  BagItem(this.id, this.name);
}

class _StateBagPage extends State<BagPage> {
  final String title = "背包";
  final List<BagItem> items = [
    BagItem(1, "装备"),
    BagItem(2, "卡片"),
    BagItem(3, "道具"),
    BagItem(4, "材料")
  ];

  late BagItem selected = items.first;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Center(
      child: Container(
        width: 420,
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
                onPressed: () => widget.onClose(OverlayMenus.bag.name),
              ),
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 0, indent: 8, endIndent: 8),
                DefaultTabController(
                  length: items.length,
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    tabs: items
                        .map(
                          (src) => Tab(height: 24, child: Text(src.name)),
                        )
                        .toList(),
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 2, color: primary),
                    ),
                    onTap: (index) => setState(() => selected = items[index]),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.grey.shade400, width: 0),
                      borderRadius: BorderRadius.circular(4),
                      shape: BoxShape.rectangle,
                    ),
                    child: onBuildGridView(context),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget onBuildGridView(BuildContext context) {
    return GridView.count(
      crossAxisCount: 10,
      children: PlayerStore().equips.map(
        (equip) {
          final child = Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0),
              borderRadius: BorderRadius.circular(2),
              shape: BoxShape.rectangle,
              image: ProtoStore().equipAssets[equip.color],
            ),
          );

          const hover = Center(
            child: Text(
              'Hovered!',
              style: TextStyle(color: Colors.white),
            ),
          );

          return HoverShowOverlay(
            width: 180,
            height: 320,
            hover: hover,
            child: child,
          );
        },
      ).toList(),
    );
  }
}

class HoverShowOverlay extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final Widget hover;

  const HoverShowOverlay({
    required this.child,
    required this.width,
    required this.height,
    required this.hover,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late OverlayEntry? overlayEntry;

    return MouseRegion(
      onEnter: (event) {
        overlayEntry = onOverlayShow(context);
      },
      onExit: (event) => onOverlayRemove(overlayEntry),
      child: child,
    );
  }

  OverlayEntry? onOverlayShow(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    late double? top, bottom;
    if (offset.dy + renderBox.size.height / 2 + height >
        MediaQuery.of(context).size.height) {
      top = null;
      bottom = MediaQuery.of(context).size.height -
          offset.dy -
          renderBox.size.height / 2;
    } else {
      top = offset.dy + renderBox.size.height / 2;
      bottom = null;
    }

    debugPrint("Render Box size is (${renderBox.size})");
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx + renderBox.size.width,
        top: top,
        bottom: bottom,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: hover,
          ),
        ),
      ),
    );

    final overlay = Overlay.of(context);
    overlay.insert(overlayEntry);

    return overlayEntry;
  }

  onOverlayRemove(OverlayEntry? overlayEntry) {
    overlayEntry?.remove();
    overlayEntry = null;
  }
}
