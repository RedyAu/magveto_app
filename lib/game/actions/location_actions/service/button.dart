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
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/button/service.png"),
          ),
          label: Text("Szolgálat indítása")),
    );
  }
}
