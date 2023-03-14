import 'package:flutter/material.dart';

class DragCard extends StatelessWidget {
  final Widget child;
  final bool dragging;
  const DragCard(Widget this.child, {bool this.dragging = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: dragging ? 0.5 : 1,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [child, Icon(Icons.drag_indicator)],
          ),
        ),
      ),
    );
  }
}
