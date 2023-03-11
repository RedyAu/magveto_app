import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../logic/index.dart';

class RoundIndicator extends StatelessWidget {
  final CharacterWithTeam character;
  final bool isCurrent;

  const RoundIndicator({
    Key? key,
    required this.character,
    required this.isCurrent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isCurrent ? 1 : 0.8,
      duration: const Duration(milliseconds: 200),
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCurrent ? Colors.grey[700] : Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCurrent
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[700]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Expanded(child: character.team.idWidgetFor(character.character)),
            SizedBox(
              height: 20,
              child: Center(
                child: AutoSizeText(
                  character.character.player!.name,
                  maxLines: 1,
                  minFontSize: 8,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
