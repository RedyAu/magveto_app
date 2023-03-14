import 'package:flutter/material.dart';

import '../../../action_dialog.dart';
import 'dialog.dart';

class StartServiceButton extends StatelessWidget {
  const StartServiceButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "service",
      child: FilledButton.tonalIcon(
          onPressed: () => Navigator.push(
                context,
                ActionRoute(
                  builder: (context) => ServicesDialog(context),
                ),
              ),
          icon: Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset(
              "assets/button/service.png",
              filterQuality: FilterQuality.medium,
            ),
          ),
          label: Text("Szolgálat indítása")),
    );
  }
}
