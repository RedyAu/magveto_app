import 'package:flutter/material.dart';

import '../graphics/background.dart';

class ActionDialog extends StatelessWidget {
  final String heroTag;
  final String title;
  final Widget? icon;
  final Widget child;

  const ActionDialog({
    required this.child,
    required this.heroTag,
    required this.title,
    this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.all(20),
        elevation: 10,
        shadowColor: Colors.black,
        clipBehavior: Clip.antiAlias,
        child: MagvetoBackground(
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              Hero(
                tag: heroTag,
                child: Card(
                  shape: StadiumBorder(),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: ListTile(
                    leading: icon,
                    title: Text(title),
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: child,
              ),
            ],
          ),
        ));
  }
}

class ActionSegmentTitle extends StatelessWidget {
  final String text;
  final bool subtitle;

  const ActionSegmentTitle(this.text, {this.subtitle = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: subtitle ? 13 : 16,
        fontWeight: subtitle ? FontWeight.bold : null,
      ),
    );
  }
}

class ActionRoute<T> extends PageRoute<T> {
  ActionRoute({required this.builder}) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => "action";

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black38;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }
}
