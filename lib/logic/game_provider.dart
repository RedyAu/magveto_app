import 'package:flutter/material.dart' show ChangeNotifier;

import 'inventory.dart';
import 'team.dart';
import 'default_data.dart';

class GameProvider extends ChangeNotifier {
  List<Team> _teams = gameTeams;
  int _teamInPlay = 0;
  int _characterOfTeamInPlay = 0;

  Team get teamInPlay => _teams[_teamInPlay];
  Character get characterOfTeamInPlay =>
      teamInPlay.characters[_characterOfTeamInPlay];

  int _round = 1;
  int get round => _round;

  /// null esetén a játék még nem kezdődött el, vagy már véget ért.
  RoundPhase? _roundPhase;
  RoundPhase? get roundPhase => _roundPhase;

  void advanceCharacters() {
    _characterOfTeamInPlay++;
    if (_characterOfTeamInPlay >= teamInPlay.characters.length) {
      _characterOfTeamInPlay = 0;
      _teamInPlay++;
      if (_teamInPlay >= _teams.length) {
        _teamInPlay = 0;
        _round++; // TODO implement round phases
      }
    }
    notifyListeners();
  }

  bool executeInventoryTransaction(InventoryTransaction transaction) {
    // null esetén a játék adja vagy veszi el a tárgyakat.
    if (transaction.from != null) {
      // TODO: initialize the inventory of the character at the start of the game
      if (!transaction.from!.inventory!.canTake(transaction)) {
        return false;
      }
      transaction.from!.inventory!.take(transaction);
    }
    transaction.to.inventory!.give(transaction);
    _roundPhase = _roundPhase!.next;
    return true;
  }
}

enum RoundPhase { preRoll, roll, action }

extension NextRoundPhase on RoundPhase {
  RoundPhase get next {
    switch (this) {
      case RoundPhase.preRoll:
        return RoundPhase.roll;
      case RoundPhase.roll:
        return RoundPhase.action;
      case RoundPhase.action:
        return RoundPhase.preRoll;
    }
  }
}
