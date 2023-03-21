import 'package:flutter/material.dart';
import 'package:magveto_app/logic/game_provider.dart';

class AdvanceRoundButton extends StatelessWidget {
  const AdvanceRoundButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "advance",
      child: FilledButton.icon(
        onPressed: () => GameProvider.of(context).advanceCharacters(),
        // make button this color: #45b508 :
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff45b508)),
          foregroundColor: MaterialStateProperty.all<Color>(Color(0xffddeeaa)),
        ),

        icon: Icon(Icons.keyboard_double_arrow_right_rounded),
        label: Text("Kövekező", softWrap: false, overflow: TextOverflow.fade),
      ),
    );
  }
}
