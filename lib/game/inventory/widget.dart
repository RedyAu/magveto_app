import 'package:flutter/material.dart';

import '../screen.dart';

class InventoryWidget extends StatelessWidget {
  const InventoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Hero(
        tag: "Roll button",
        child: MaterialButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return const RollDialog();
                });
          },
          child: const Text('Roll'),
        ),
      ),
    );
  }
}
