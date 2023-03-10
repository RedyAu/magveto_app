import 'package:flutter/material.dart';
import 'package:magveto_app/graphics/road_count.dart';

import '../../../logic/index.dart';

class BrotherConnectionTile extends StatelessWidget {
  final BrotherConnection connection;
  final Team teamOfView;

  BrotherConnectionTile(
      {Key? key, required this.connection, required this.teamOfView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // get the team that is not the team of view
    Team team = connection.teams.firstWhere((team) => team != teamOfView);
    // sort connections so that the team of view is always first
    connection.between.sort((a, b) => a.team == teamOfView ? -1 : 1);

    return Container(
      padding: EdgeInsets.all(4),
      height: 58,
      width: 45,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                if (!connection.isActive)
                  Positioned.fill(
                    child: FittedBox(
                      child: Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                Container(
                  height: 25,
                  margin: EdgeInsets.only(bottom: 2),
                  color: team.color.withOpacity(connection.isActive ? 1 : 0.5),
                  child: Center(
                    child: Text(
                      "${team.id}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            ThemeData.estimateBrightnessForColor(team.color) ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black,
                        shadows: [
                          Shadow(
                            offset: Offset(0.0, 0.0),
                            color: ThemeData.estimateBrightnessForColor(
                                        team.color) ==
                                    Brightness.dark
                                ? Colors.black
                                : Colors.white,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RoadCountWidget(
                    color: connection.between.first.team.color,
                    count: connection.between.first.roads),
                RoadCountWidget(
                    color: connection.between.last.team.color,
                    count: connection.between.last.roads),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
