import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:magveto_app/logic/game_provider.dart';
import 'package:provider/provider.dart';

import '../../logic/index.dart';
import 'indicator.dart';

class RoundView extends StatefulWidget {
  @override
  State<RoundView> createState() => _RoundViewState();
}

class _RoundViewState extends State<RoundView> {
  late InfiniteScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = InfiniteScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, game, child) {
      if (_controller.positions.isNotEmpty &&
          game.characterWithTeamInPlay != _controller.selectedItem) {
        _controller.nextItem();
        Future.delayed(const Duration(milliseconds: 500)).then(
            (value) => _controller.jumpToItem(game.characterWithTeamInPlay));
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 80,
            child: Text("Picture of\n${game.characterInPlay.name}"),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InfiniteCarousel.builder(
                        center: true,
                        controller: _controller,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: game.charactersWithTeams.length,
                        itemExtent: 80,
                        itemBuilder: (context, itemIndex, realIndex) =>
                            RoundIndicator(
                                character: game.charactersWithTeams[itemIndex],
                                isCurrent:
                                    game.characterWithTeamInPlay == itemIndex),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 8, bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${game.characterInPlay.name}',
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                      Text(
                        '${game.round}. kör',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
