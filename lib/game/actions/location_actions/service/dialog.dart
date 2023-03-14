import 'package:flutter/material.dart';

import '../../../action_dialog.dart';

class ServicesDialog extends StatefulWidget {
  const ServicesDialog(BuildContext context, {Key? key})
      : super(key: key);

  @override
  _ServicesDialogState createState() => _ServicesDialogState();
}

class _ServicesDialogState extends State<ServicesDialog> {
  @override
  Widget build(BuildContext context) {
    return ActionDialog(
        heroTag: "upgrade",
        title: "Szolgálatok",
        icon: Icon(Icons.upgrade),
        child: Center(child: Text("ServicesDialog")));
  }
}
