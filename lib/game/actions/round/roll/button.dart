import 'package:flutter/material.dart';
import 'package:magveto_app/game/action_dialog.dart';

import 'dialog.dart';

class RollButton extends StatelessWidget {
  const RollButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "roll",
      child: FilledButton.icon(
        onPressed: () => Navigator.push(
          context,
          ActionRoute(builder: (context) => RollDialog()),
        ),
        icon: Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset(
              'assets/button/roll.png',
              filterQuality: FilterQuality.medium,
            )),
        label: Text("Dobás", softWrap: false, overflow: TextOverflow.fade),
      ),
    );
  }
}
