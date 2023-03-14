import 'package:flutter/material.dart';
import 'package:magveto_app/game/actions/location_actions/rim/dialog.dart';

import '../../../action_dialog.dart';
import '../service/dialog.dart';

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
            builder: (context) => RimDialog(),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Image.asset(
            "assets/button/rim.png",
            filterQuality: FilterQuality.medium,
          ),
        ),
      ),
    );
  }
}
