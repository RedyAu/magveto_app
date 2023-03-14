import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:provider/provider.dart';

import '../../logic/game_provider.dart';
import '../../logic/index.dart';
import 'indicator.dart';

class RoundSection extends StatefulWidget {
  @override
  State<RoundSection> createState() => _RoundSectionState();
}

class _RoundSectionState extends State<RoundSection> {
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
      // HACK somebody tell me how to use scrollcontrollers properly 😳
      if (_controller.positions.isNotEmpty &&
          game.characterWithTeamInPlay != _controller.selectedItem) {
        int jumpTo = game.characterWithTeamInPlay - 1;
        if (jumpTo < 0) jumpTo = game.charactersWithTeams.length - 1;
        _controller.jumpToItem(jumpTo);
        _controller.nextItem();
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InfiniteCarousel.builder(
                        center: true,
                        controller: _controller,
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
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 3),
                  child: Row(
                    children: [
                      Text(
                        '${game.round}. kör  ',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.start,
                      ),
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.center,
                          '${game.characterInPlay.name}',
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 1.5,
            child: Transform.translate(
              offset: const Offset(-10, 5),
              child: SizedBox(
                width: 80,
                child: Image.asset(
                  'assets/character/${game.teamInPlay.idStringFor(game.characterInPlay)}.png',
                  fit: BoxFit.none,
                  scale: 7.3,
                  cacheHeight: 750,
                  filterQuality: FilterQuality.medium,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
