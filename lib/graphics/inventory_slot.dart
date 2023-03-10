import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magveto_app/graphics/item.dart';
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
                  ItemWidget(type: type),
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
