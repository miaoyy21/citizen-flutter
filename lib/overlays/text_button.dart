import 'package:flutter/material.dart';

class GameTextButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const GameTextButton({required this.text, required this.onTap, super.key});

  @override
  State<StatefulWidget> createState() => _StateGameTextButton();
}

class _StateGameTextButton extends State<GameTextButton> {
  double _fontSize = 24.0;

  double get fontSize => _fontSize;

  set fontSize(double newFontSize) {
    setState(() {
      _fontSize = newFontSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fontSize * 1.5,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin:
          EdgeInsets.only(left: 24.0 - fontSize, right: 8 + 24.0 - fontSize),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(color: Colors.lightGreen, blurRadius: 4, offset: Offset(1, 2)),
        ],
        shape: BoxShape.rectangle,
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (details) => fontSize = 22,
        onTapCancel: () => fontSize = 24,
        onTapUp: (details) => fontSize = 24,
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize,
              fontFamily: "AaKuangPaiShouShu",
            ),
          ),
        ),
      ),
    );
  }
}
