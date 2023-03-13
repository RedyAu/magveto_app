import 'package:flutter/material.dart';
import 'package:magveto_app/game/actions/location_actions/service/dialog.dart';

import '../../../action_dialog.dart';

class RimButton extends StatelessWidget {
  const RimButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "rim",
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          ActionRoute(
            builder: (context) => ServicesDialog(context),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/button/rim.png"),
        ),
      ),
    );
  }
}
