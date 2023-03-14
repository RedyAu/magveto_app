import 'dart:math';

import 'package:flutter/material.dart';

import '../../graphics/index.dart';
import '../../logic/index.dart';

class LocationGroundTilesView extends StatelessWidget {
  final Location location;
  final int characterCount;
  final int teamId;
  final Color teamColor;
  final double offset = 105;

  const LocationGroundTilesView(this.location,
      {required this.characterCount,
      required this.teamId,
      required this.teamColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return FittedBox(
      child: SizedBox(
        height: 207,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Transform.translate(
            offset: Offset(0, 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ...location.tiles.map((tile) {
                  i++;
                  return Transform.scale(
                      scale: 0.5,
                      child: Transform.translate(
                          offset: Offset(
                              (offset * cos(pi * 2 / 3 * i + pi / 6)),
                              (offset * sin(pi * 2 / 3 * i + pi / 6))),
                          child: GroundTileWidget(tile,
                              key: Key(
                                  '${location.hashCode} ${tile.hashCode} ${key.hashCode}'))));
                }),
                ...List<Widget>.generate(characterCount, (index) {
                  return Transform.translate(
                      offset: Offset(index * 5, index * -5),
                      child: SizedBox(
                        width: 45,
                        child: Container(
                          decoration: BoxDecoration(
                            color: teamColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white12, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 4,
                                offset: Offset(1, 1),
                                spreadRadius: 1,
                              )
                            ],
                          ),
                        ),
                      ));
                }),
                if (location.type != LocationType.outpost)
                  Transform.translate(
                    offset: Offset(3, -13),
                    child: Image.asset(
                      'assets/location/${teamId}_${location.type.name}.png',
                      height: 50,
                      alignment: Alignment.bottomCenter,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
