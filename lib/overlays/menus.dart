import 'dart:ffi';

import 'package:citizen/overlays/index.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'text_button.dart';

class MenuOverlay extends StatelessWidget {
  final Game game;

  MenuOverlay({super.key, required this.game});

  final List<StringProperty> overlays = [
    StringProperty("角色", OverlayMenus.role.name),
    StringProperty("背包", OverlayMenus.bag.name),
    StringProperty("秘技", OverlayMenus.skill.name),
    StringProperty("邮件", OverlayMenus.mail.name),
    StringProperty("帮助", OverlayMenus.help.name),
  ];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 128,
      bottom: 8,
      child: Material(
        color: Colors.transparent,
        child: Row(
            children: overlays
                .map((property) => GameTextButton(
                      text: property.name!,
                      onTap: () {
                        game.overlays.add(property.value!)
                            ? game.pauseEngine()
                            : Void;
                      },
                    ))
                .toList()),
      ),
    );
  }
}
