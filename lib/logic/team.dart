import 'package:flutter/material.dart';

import 'inventory.dart';
import 'location.dart';

class Player {
  String name;
  Player(this.name);
}

enum CID {
  joe,
  mary,
  janos,
  maria,
  hansi,
  gertrud,
  teofil,
  teofilia,
  ivan,
  tatjana,
  jeanphilip,
  bernadette
}

class Character {
  Player? player;
  final CID id;
  final String letter;
  final String name;
  final String description;
  Inventory? inventory;
  Location? currentLocation;

  Character(this.id, this.letter, this.name, this.description);
}

class CharacterWithTeam {
  final Character character;
  final Team team;

  CharacterWithTeam(this.character, this.team);
}

class Team {
  /// A csapat számjele. A karakterlapokon szereplő számjel.
  int id;

  /// A csapat színe. A karakterlapokon szereplő szín.
  Color color;

  /// A csapat karakterei. A karakterlapokon szereplő karakterek.
  List<Character> characters;

  /// A csapat neve. Játékindításkor megadható.
  String? name;

  /// A csapat összes pontszáma.
  /// A játékosok összes pontszámának összege.
  int get totalPoints => 0; // TODO: implement

  int get playerCount => characters.where((c) => c.player != null).length;

  int rimsRedeemed = 0;

  Widget idWidgetFor([Character? character]) {
    return Container(
      width: 45,
      height: 45,
      decoration:
          BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 2,
          offset: Offset(0, 1), // changes position of shadow
        ),
      ]),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Text(
            id.toString() + (character?.letter ?? ""),
            style: TextStyle(
              color:
                  ThemeData.estimateBrightnessForColor(color) == Brightness.dark
                      ? Colors.white
                      : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(0.0, 0.0),
                  color: ThemeData.estimateBrightnessForColor(color) ==
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
    );
  }

  String idStringFor(Character character) {
    return id.toString() + character.letter;
  }

  Team(this.id, this.color, this.characters);
}

class TeamRoads {
  final Team team;
  int roads = 0;

  TeamRoads(this.team);
}

class RoadConnection {
  bool get isActive => _isActive && isFinished;
  // can get inactivated by event
  bool _isActive = true;
  set isActive(bool value) => _isActive = value;

  bool isFinished = false;
  late final List<TeamRoads> between;
  List<Team> get teams => between.map((e) => e.team).toList();

  int get roadLength =>
      between.fold(0, (value, element) => value + element.roads);

  // check whether any of the teams in the between list is the given team
  bool hasTeam(Team team) => between.any((element) => element.team == team);

  // road can be finished if total length is minimum 4, and each team has at least 1 road. also return false if road is already active.
  bool get canBeFinished =>
      roadLength >= 4 &&
      between.every((element) => element.roads >= 1) &&
      !isActive;

  RoadConnection(TeamRoads team1, TeamRoads team2) {
    between = List.from([team1, team2], growable: false);
  }
}
