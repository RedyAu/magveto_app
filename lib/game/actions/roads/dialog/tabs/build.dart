import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../graphics/index.dart';
import '../../../../../logic/index.dart';
import '../../../../action_dialog.dart';
import 'pill_amount_button.dart';

class BuildRoadTab extends StatefulWidget {
  RoadConnection selectedConnection;
  TabController tabController;

  BuildRoadTab({Key? key, required this.selectedConnection, required this.tabController}) : super(key: key);

  @override
  State<BuildRoadTab> createState() => _BuildRoadTabState();
}

class _BuildRoadTabState extends State<BuildRoadTab>
    with TickerProviderStateMixin {
  // Amounts of items used to build the road
  // TODO use records when available
  List<int> itemsToUse = [0, 0, 0, 0];
  List<int> itemsGotUsed = [0, 0, 0, 0];
  int roadsGotBuilt = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, game, child) {
      return Column(
        children: [
          SizedBox(height: 10),
          ActionSegmentTitle('Mennyit szeretnél felhasználni?'),
          ActionSegmentTitle(
            'Két különböző tárgy ér egy útelemet.',
            subtitle: true,
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'kívánt ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                    text: '(felhasznált)',
                    style: TextStyle(color: Colors.amberAccent)),
                TextSpan(text: ' / van nálad'),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 60,
                child: ItemWidget(type: ItemType.scripture),
              ),
              SizedBox(
                height: 60,
                child: ItemWidget(type: ItemType.prayer),
              ),
              SizedBox(
                height: 60,
                child: ItemWidget(type: ItemType.charity),
              ),
              SizedBox(
                height: 60,
                child: ItemWidget(type: ItemType.blessing),
              ),
            ],
          ),

          // display: amount used in bold, slash amount the user has
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List<Widget>.generate(
                  4, (index) => amountIndicator(game, index))),
          SizedBox(
            height: 10,
          ),
          // plus and minus buttons for each type. they appear as a single togglebutton with two sides
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List<Widget>.generate(
              4,
              (index) => PillAmountButton(
                  itemsToUse: itemsToUse,
                  playerInventory: game.characterInPlay.inventory!.asItemsList,
                  itemTypeIndex: index,
                  resolveItemsToUse: resolveItemsToUse),
            ),
          ),
          Divider(height: 25),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Eredmény: ", style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 35,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: RoadCountWidget(
                      color: game.teamInPlay.color, count: roadsGotBuilt),
                ),
              ),
              Text(" db útelem", style: TextStyle(fontSize: 20)),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 35,
            child: FilledButton(
              onPressed: roadsGotBuilt > 0
                  ? () {
                      bool couldFinish =
                          widget.selectedConnection.canBeFinished;

                      // create an inventory transaction that takes away the used items
                      // and use it on the current player
                      game.characterInPlay.inventory!.take(Inventory(
                          scripture: itemsToUse[0],
                          prayer: itemsToUse[1],
                          charity: itemsToUse[2],
                          blessing: itemsToUse[3]));

                      // add the built roads to the current connection to the current team
                      widget.selectedConnection.between
                          .firstWhere(
                              (element) => element.team == game.teamInPlay)
                          .roads += roadsGotBuilt;

                      // add the selected connection to game if it is not already there
                      if (!game.brotherConnections
                          .contains(widget.selectedConnection))
                        game.brotherConnections.add(widget.selectedConnection);

                      game.notify();

                      if (!couldFinish &&
                          widget.selectedConnection.canBeFinished) {
                        widget.tabController.animateTo(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  : null,
              child: Text("Mehet!", style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      );
    });
  }

  void resolveItemsToUse() {
    var resolveResult = resolvePairs(itemsToUse);
    setState(() {
      itemsGotUsed = resolveResult.sublist(0, 4).toList();
      roadsGotBuilt = resolveResult[4];
    });
  }

  RichText amountIndicator(GameProvider game, int itemTypeIndex) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${itemsToUse[itemTypeIndex]} ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
              text: '(${itemsGotUsed[itemTypeIndex]})',
              style: TextStyle(color: Colors.amberAccent)),
          TextSpan(
              text:
                  ' / ${game.characterInPlay.inventory!.asItemsList[itemTypeIndex]}'),
        ],
      ),
    );
  }
}
