import 'package:flutter/material.dart';

import '../../../action_dialog.dart';
import 'dialog.dart';

class NewLocationButton extends StatelessWidget {
  const NewLocationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "new_location",
      child: FilledButton.icon(
        onPressed: () => Navigator.push(
          context,
          ActionRoute(
            builder: (context) => NewLocationDialog(),
          ),
        ),
        icon: Padding(
          padding: const EdgeInsets.all(5),
          child: Image.asset(
            "assets/button/rim.png",
            filterQuality: FilterQuality.medium,
          ),
        ),
        label: Text("Új missziói állomás"),
      ),
    );
  }
}
