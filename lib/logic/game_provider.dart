import 'package:flutter/material.dart' show BuildContext, ChangeNotifier;
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'index.dart';

class GameProvider extends ChangeNotifier {
  List<Team> _teams = [];
  List<Team> get teams => _teams;

  /// **Call notify() after editing this list!**
  List<RoadConnection> brotherConnections = [];

  List<CharacterWithTeam> get charactersWithTeams => _teams.expand((team) {
        return team.characters.map((character) {
          return CharacterWithTeam(character, team);
        });
      }).toList();

  List<Character> get characters => _teams.expand((team) {
        return team.characters;
      }).toList();

  int _teamInPlay = 0;
  int _characterOfTeamInPlay = 0;

  int get characterWithTeamInPlay => _characterOfTeamInPlay + _teamInPlay * 2;

  Team get teamInPlay => _teams[_teamInPlay];
  Character get characterInPlay =>
      teamInPlay.characters[_characterOfTeamInPlay];

  Location get locationInPlay => characterInPlay.currentLocation!;

  int _round = 1;
  int get round => _round;

  AutoScrollController? locationsController;

  List<Function> postCharacterCallbacks = [
    () => print("### Post character callbacks"),
  ];
  List<Function> postTeamCallbacks = [
    () => print("### Post team callbacks"),
  ];
  List<Function> postDiceCallbacks = [
    () => print("### Post dice callbacks"),
  ];
  List<Function> postRoundCallbacks = [
    () => print("### Post round callbacks"),
  ];

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
        postRoundCallbacks.forEach((e) => e());
      }
      postTeamCallbacks.forEach((e) => e());
    }
    postCharacterCallbacks.forEach((e) => e());
    notifyListeners();
  }

  void startGame(List<Team> teams) {
    _teams = teams;
    // init all inventories
    // instantiate a location for each team, and give that location to each member of the team
    for (var team in _teams) {
      Location teamLocation = new Location(team);
      for (var character in team.characters) {
        // by default, the character gets one of each item
        character.inventory = new Inventory(
          scripture: 10,
          prayer: 10,
          charity: 10,
          blessing: 10,
        );
        moveCharacterToLocation(character, teamLocation);
      }
    }

    notifyListeners();
  }

  void moveCharacterToLocation(Character character, Location location) {
    // find all characters already at the location
    List<CharacterWithTeam> charactersAtLocation =
        charactersWithTeams.where((c) {
      return c.character.currentLocation == location;
    }).toList();

    // if the location already has two characters, throw an error
    if (charactersAtLocation.length >= 2) {
      throw Exception("Location already has two characters!");
    }
    // if either inventory is null, throw an error
    if (character.inventory == null ||
        charactersAtLocation
            .any((element) => element.character.inventory == null)) {
      throw Exception("Character inventory is null!");
    }

    // if there are no characters at the location, just move the character there
    if (charactersAtLocation.isEmpty) {
      character.currentLocation = location;
      notifyListeners();
      print(
          "Moving ${character.name} to empty location: ${location.hashCode}.");
      return;
    }

    print(
        "Moving ${character.name} to location: ${location.hashCode}. Merging inventories with ${charactersAtLocation.first.character.name}.");
    // if location already has a character, merge their inventories
    Character otherCharacter = charactersAtLocation.first.character;
    otherCharacter.inventory!.give(character.inventory!);
    character.inventory = otherCharacter.inventory;

    character.currentLocation = location;
    notifyListeners();
  }

  static GameProvider of(BuildContext context, {bool listen = false}) {
    return Provider.of<GameProvider>(context, listen: listen);
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
