import 'package:flutter/material.dart';

import 'team.dart';

List<Team> getDefaultTeams() => [
  Team(1, Colors.yellow, [
    Character("A", "Joe, az áldott",
        "Ha valaki áldást kap, Joe is részesedik belőle (ő is kap egy áldáscsillagot)."),
    Character("B", "Mary, a szervező",
        "Minden körben szabadon (ellenérték nélkül) lerakhat egy útelemet, ha szüksége van rá."),
  ]),
  Team(2, Colors.orange, [
    Character("A", "János, az egykönyvű ember",
        "Ha valaki igeolvasáson vesz részt (1-est dob), János is ott van (ő is kap egy igekártyát)."),
    Character("B", "Mária, az építő",
        "Ahhoz, hogy temploma megépüljön, csak két gyülekezeti szolgálatot kell beindítania."),
  ]),
  Team(3, Colors.red, [
    Character("A", "Hansi, az arató",
        "Ha két földje váltságot nyer, ráadásként a harmadikat is megfordíthatja."),
    Character("B", "Gertrúd, a hiánypótló",
        "Ha páratlant dob, a felhúzott kártyáján túl még egy olyan ige-, ima-, vagy diakóniakártyát is felvehet, amilyenre a legnagyobb szüksége van."),
  ]),
  Team(4, Colors.deepPurple, [
    Character("A", "Teofil, a könyörületes szívű",
        "Ha valaki diakóniai eseményen vesz részt (3-ast dob), Teofil is segít (ő is kap egy diakóniakártyát)."),
    Character("B", "Teofília, az útépítő",
        "Minden körben szabadon (ellenérték nélkül) lerakhat egy útelemet, ha szüksége van rá."),
  ]),
  Team(5, Colors.blue, [
    Character("A", "Iván, a hiánypótló",
        "Ha párosat dob, a felhúzott kártyáján túl még egy olyan ige-, ima-, vagy diakóniakártyát is felvehet, amilyenre a legnagyobb szüksége van."),
    Character("B", "Tatjana, az arató",
        "Ha két földje váltságot nyer, ráadásként a harmadikat is megfordíthatja."),
  ]),
  Team(6, Colors.green, [
    Character("A", "Jean-Philip, az imaharcos",
        "Ha valaki imádkozik (2-est dob), Jean-Philip is vele tart (ő is kap egy imakártyát)."),
    Character("B", "Bernadette, a szolgáló",
        "Ahhoz, hogy temploma megépüljön, csak két gyülekezeti szolgálatot kell beindítania."),
  ]),
];
