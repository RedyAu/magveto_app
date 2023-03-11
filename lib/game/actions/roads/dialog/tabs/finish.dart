import 'package:flutter/material.dart';
import 'package:magveto_app/logic/index.dart';
import 'package:provider/provider.dart';

import '../../../../../graphics/index.dart';
import '../../../../action_dialog.dart';

// TODO make possible to choose which character givces the blessing
class FinishRoadTab extends StatelessWidget {
  const FinishRoadTab({
    super.key,
    required this.selectedConnection,
  });

  final RoadConnection selectedConnection;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: selectedConnection.between
              .map((e) => SizedBox(
                      child: Stack(
                    alignment: Alignment.center,
                    children: [
                      e.team.idWidgetFor(null),
                      Transform.translate(
                        offset: Offset(15, 15),
                        child: SizedBox(
                            height: 40,
                            child: ItemWidget(type: ItemType.blessing)),
                      )
                    ],
                  )))
              .toList(),
        ),
        SizedBox(height: 40),
        ActionSegmentTitle('Készen álltok?'),
        ActionSegmentTitle(
          'Ha a játékpályán is elkészült az út, 1-1 áldás beadásával aktiválhatjátok.',
          subtitle: true,
        ),
        SizedBox(height: 30),
        SizedBox(
          height: 35,
          child: FilledButton(
            onPressed: (selectedConnection.teams.every(
                    (t) => t.characters.any((c) => c.inventory!.blessing > 0)))
                ? () {
                    // take away a blessing from each team. take away the blessing from the first character that has it
                    selectedConnection.teams.forEach((t) {
                      t.characters
                          .firstWhere((c) => c.inventory!.blessing > 0)
                          .inventory!
                          .take(Inventory(blessing: 1));
                    });

                    // set the connection to finished
                    selectedConnection.isFinished = true;

                    GameProvider.of(context).notify();
                    Navigator.pop(context);
                  }
                : null,
            child: Text("Mehet!", style: TextStyle(fontSize: 20)),
          ),
        ),
      ],
    );
  }
}
