import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  const CustomActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "custom_event",
      child: Tooltip(
        message: "Kedvező esemény választása dobás helyett",
        preferBelow: false,
        child: FilledButton.tonal(
          onPressed: () {},
          child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                'assets/event/church.png',
                filterQuality: FilterQuality.medium,
              )),
        ),
      ),
    );
  }
}
