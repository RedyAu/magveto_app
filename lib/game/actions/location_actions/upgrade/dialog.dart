import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../logic/index.dart';
import '../../../action_dialog.dart';

class UpgradeLocationDialog extends StatefulWidget {
  const UpgradeLocationDialog(BuildContext context, {Key? key})
      : super(key: key);

  @override
  _UpgradeLocationDialogState createState() => _UpgradeLocationDialogState();
}

class _UpgradeLocationDialogState extends State<UpgradeLocationDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        return ActionDialog(
            heroTag: "upgrade",
            title: "Fejlesztés",
            icon: Icon(Icons.upgrade),
            child: Center(child: Text("UpgradeLocationDialog")));
      }
    );
  }
}
