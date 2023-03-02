import 'dart:ui';

import 'package:flutter/material.dart';

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

  Widget idWidgetFor(Character character) {
    return Container(
      width: 45,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          id.toString() + character.letter,
          style: TextStyle(
              color:
                  ThemeData.estimateBrightnessForColor(color) == Brightness.dark
                      ? Colors.white
                      : Colors.black,
              fontSize: 20),
        ),
      ),
    );
  }

  Team(this.id, this.color, this.characters);
}
