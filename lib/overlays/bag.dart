import 'package:flutter/material.dart';
import 'package:flame/game.dart';

Widget onBagPage(BuildContext context, Game game) {
  return BagPage();
}

class BagPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StateBagPage();
}

class _StateBagPage extends State<BagPage> {
  final List<String> items = ["2222", "33333"];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(color: Colors.orange, blurRadius: 4),
            ],
            shape: BoxShape.rectangle,
          ),
          child: DefaultTabController(
            length: items.length,
            child: TabBar(
              isScrollable: true,
              tabs: items.map((src) => Tab(text: src)).toList(),
              // indicator: UnderlineTabIndicator(
              //   borderSide: BorderSide(
              //     width: 2,
              //     color: Colors.white,
              //   ),
              // ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildView() {
    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
              leading: Text(items[index]),
              title: Text(items[index]),
              trailing: Icon(Icons.chevron_right),
              onTap: () => null,
            ),
        separatorBuilder: (context, index) =>
            Divider(height: 0, indent: 8, endIndent: 8),
        itemCount: items.length);
  }
}
