import 'package:flutter/material.dart';

import '../logic/index.dart';

class ItemWidget extends StatelessWidget {
  final ItemType type;

  const ItemWidget({Key? key, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
          shape: type == ItemType.blessing ? CircleBorder() : null,
          surfaceTintColor: Colors.transparent,
          elevation: 7,
          color: colorOfItem(type),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Image.asset(
              "assets/item/${type.name}.png",
              filterQuality: FilterQuality.medium,
            ),
          )),
    );
  }
}

Color colorOfItem(ItemType type) {
  switch (type) {
    case ItemType.scripture:
      return Color(0xffffda6b);
    case ItemType.prayer:
      return Color(0xffbb8ec5);
    case ItemType.charity:
      return Color(0xffa0d166);
    case ItemType.blessing:
      return Color(0xfffa9308);
    case ItemType.scriptureService:
      return Color(0xfffac501);
    case ItemType.prayerService:
      return Color(0xff9054aa);
    case ItemType.charityService:
      return Color(0xff74a339);
  }
}