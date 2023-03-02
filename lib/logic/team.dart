import 'dart:ui';

import 'game_provider.dart';
import 'inventory.dart';
import 'location.dart';

class Player {
  String name;
  Player(this.name);
}

class Character {
  Player? player;
  final String letter;
  final String name;
  final String description;
  Inventory? inventory;
  Location? currentLocation;

  Character(this.letter, this.name, this.description);
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

  Team(this.id, this.color, this.characters);
}
