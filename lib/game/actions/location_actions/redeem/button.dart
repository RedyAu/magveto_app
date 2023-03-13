import 'package:flutter/material.dart';
import 'package:magveto_app/game/actions/location_actions/service/dialog.dart';

import '../../../action_dialog.dart';

class RedeemButtons extends StatelessWidget {
  const RedeemButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "redeem",
      child: FilledButton.tonalIcon(
          onPressed: () => Navigator.push(
                context,
                ActionRoute(
                  builder: (context) => ServicesDialog(context),
                ),
              ),
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/button/redeem.png"),
          ),
          label: Text("Föld megváltása")),
    );
  }
}
