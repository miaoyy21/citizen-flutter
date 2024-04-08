import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'text_button.dart';

class MenuOverlay extends StatelessWidget {
  final Game game;

  const MenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 128,
      bottom: 8,
      child: Material(
        child: Row(
          children: [
            GameTextButton(
              text: "角色",
              onTap: () {
                debugPrint("打开 【角色】");
              },
            ),
            GameTextButton(
              text: "背包",
              onTap: () {
                game.overlays.add("BagPage");
              },
            ),
            GameTextButton(
              text: "秘技",
              onTap: () {
                debugPrint("打开 【秘技】");
              },
            ),
            GameTextButton(
              text: "邮件",
              onTap: () {
                debugPrint("打开 【邮件】");
              },
            ),
            GameTextButton(
              text: "帮助",
              onTap: () {
                debugPrint("打开 【帮助】");
              },
            ),
          ],
        ),
      ),
    );
  }
}
