import 'dart:math';

import 'package:flutter/material.dart';
import '../logic/inventory.dart';

class InventorySlotWidget extends StatelessWidget {
  final ItemType type;
  final int count;

  const InventorySlotWidget({Key? key, required this.type, required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/other/slot.png'),
            filterQuality: FilterQuality.medium,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(4),
                child: Image.asset(
                  "assets/item/${type.name}.png",
                  filterQuality: FilterQuality.medium,
                ),
              ),
              ...List.generate(
                count,
                (int index) => randomItemTransformForSeed(
                  index,
                  AspectRatio(
                    aspectRatio: 1,
                    child: Card(
                        shape:
                            type == ItemType.blessing ? CircleBorder() : null,
                        surfaceTintColor: Colors.transparent,
                        elevation: 7,
                        color: colorForType(type),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Image.asset(
                            "assets/item/${type.name}.png",
                            filterQuality: FilterQuality.medium,
                          ),
                        )),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 5,
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color colorForType(ItemType type) {
  switch (type) {
    case ItemType.scripture:
      return Color(0xffeadd7c);
    case ItemType.prayer:
      return Color(0xffb492b3);
    case ItemType.charity:
      return Color(0xffa7c477);
    case ItemType.blessing:
      return Color(0xffdca543);
    case ItemType.scriptureService:
      return Color(0xffe7d04f);
    case ItemType.prayerService:
      return Color(0xff955594);
    case ItemType.charityService:
      return Color(0xff86a25c);
  }
}

// translates and rotates children slightly to make them look like they're in a pile
Transform randomItemTransformForSeed(int seed, Widget child) {
  // return with no transform if seed is 0
  if (seed == 0) return Transform(child: child, transform: Matrix4.identity());

  final random = Random(seed);
  final x = random.nextDouble() * 10 - 5;
  final y = random.nextDouble() * 10 - 5;
  final angle = (random.nextDouble() / 8 - 1 / 16) * pi;
  return Transform(
    transform: Matrix4.identity()
      ..translate(x, y)
      ..rotateZ(angle),
    child: child,
  );
}
