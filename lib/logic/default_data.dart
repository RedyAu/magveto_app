import 'package:flutter/material.dart';

import 'team.dart';

List<Team> getDefaultTeams() => [
      Team(1, Color(0xffffed00), [
        Character(CID.joe, "A", "Joe, az áldott",
            "Ha valaki áldást kap, Joe is részesedik belőle (ő is kap egy áldáscsillagot)."),
        Character(CID.mary, "B", "Mary, a szervező",
            "Minden körben szabadon (ellenérték nélkül) lerakhat egy útelemet, ha szüksége van rá."),
      ]),
      Team(2, Color(0xffee7f00), [
        Character(CID.janos, "A", "János, az egykönyvű ember",
            "Ha valaki igeolvasáson vesz részt (1-est dob), János is ott van (ő is kap egy igekártyát)."),
        Character(CID.maria, "B", "Mária, az építő",
            "Ahhoz, hogy temploma megépüljön, csak két gyülekezeti szolgálatot kell beindítania."),
      ]),
      Team(3, Color(0xffe2001a), [
        Character(CID.hansi, "A", "Hansi, az arató",
            "Ha két földje váltságot nyer, ráadásként a harmadikat is megfordíthatja."),
        Character(CID.gertrud, "B", "Gertrúd, a hiánypótló",
            "Ha páratlant dob, a felhúzott kártyáján túl még egy olyan ige-, ima-, vagy diakóniakártyát is felvehet, amilyenre a legnagyobb szüksége van."),
      ]),
      Team(4, Color(0xff81197f), [
        Character(CID.teofil, "A", "Teofil, a könyörületes szívű",
            "Ha valaki diakóniai eseményen vesz részt (3-ast dob), Teofil is segít (ő is kap egy diakóniakártyát)."),
        Character(CID.teofilia, "B", "Teofília, az útépítő",
            "Minden körben szabadon (ellenérték nélkül) lerakhat egy útelemet, ha szüksége van rá."),
      ]),
      Team(5, Color(0xff008bd0), [
        Character(CID.ivan, "A", "Iván, a hiánypótló",
            "Ha párosat dob, a felhúzott kártyáján túl még egy olyan ige-, ima-, vagy diakóniakártyát is felvehet, amilyenre a legnagyobb szüksége van."),
        Character(CID.tatjana, "B", "Tatjana, az arató",
            "Ha két földje váltságot nyer, ráadásként a harmadikat is megfordíthatja."),
      ]),
      Team(6, Color(0xff009037), [
        Character(CID.jeanphilip, "A", "Jean-Philip, az imaharcos",
            "Ha valaki imádkozik (2-est dob), Jean-Philip is vele tart (ő is kap egy imakártyát)."),
        Character(CID.bernadette, "B", "Bernadette, a szolgáló",
            "Ahhoz, hogy temploma megépüljön, csak két gyülekezeti szolgálatot kell beindítania."),
      ]),
    ];
