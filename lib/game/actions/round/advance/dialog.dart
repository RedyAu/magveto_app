import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:magveto_app/game/action_dialog.dart';

class AdvanceDialog extends StatelessWidget {
  final Widget idWidget;
  final String playerName;

  const AdvanceDialog(
      {required Widget this.idWidget,
      required String this.playerName,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ActionDialog(
      heroTag: "advance",
      icon: Icon(Icons.person_2_outlined),
      title: "Következő játékos",
      child: Column(children: [
        ActionSegmentTitle(
          "Add át az eszközt a következő játékosnak:",
          subtitle: true,
        ),
        SizedBox(height: 20),
        idWidget,
        ActionSegmentTitle(playerName),
        SizedBox(height: 20),
        FilledButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.check),
            label: Text(
              "Én vagyok az!",
              style: TextStyle(fontSize: 20),
            )),
        SizedBox(height: 20),
      ]),
    );
  }
}
