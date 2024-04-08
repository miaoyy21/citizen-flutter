import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'text_button.dart';

class Menus {
  Widget builder(BuildContext context, Game game) {
    return Positioned(
      left: 128,
      bottom: 8,
      child: Row(
        children: [
          GameTextButton(
            text: "背包",
            onTap: () {
              debugPrint("打开 【背包】");
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
    );
  }
}
