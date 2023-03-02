import 'package:flutter/material.dart' show ChangeNotifier;

import 'index.dart';

class GameProvider extends ChangeNotifier {
  List<Team> _teams = [];
  List<Team> get teams => _teams;

  List<CharacterWithTeam> get charactersWithTeams => _teams.expand((team) {
        return team.characters.map((character) {
          return CharacterWithTeam(character, team);
        });
      }).toList();

  int _teamInPlay = 0;
  int _characterOfTeamInPlay = 0;

  int get characterWithTeamInPlay => _characterOfTeamInPlay + _teamInPlay * 2;

  Team get teamInPlay => _teams[_teamInPlay];
  Character get characterInPlay =>
      teamInPlay.characters[_characterOfTeamInPlay];

  int _round = 1;
  int get round => _round;

  void notify() {
    notifyListeners();
  }

  void advanceCharacters() {
    _characterOfTeamInPlay++;
    if (_characterOfTeamInPlay >= teamInPlay.characters.length) {
      _characterOfTeamInPlay = 0;
      _teamInPlay++;
      if (_teamInPlay >= _teams.length) {
        _teamInPlay = 0;
        _round++;
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
    return true;
  }

  void startGame(List<Team> teams) {
    _teams = teams;
    // init all inventories
    // instantiate a location for each team, and give that location to each member of the team
    for (var team in _teams) {
      Location teamLocation = Location();
      for (var character in team.characters) {
        // by default, the character gets one of each item
        character.inventory = Inventory(
          scripture: 1,
          prayer: 1,
          charity: 1,
          blessing: 1,
        );
        character.currentLocation = teamLocation;
      }
    }

    notifyListeners();
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
