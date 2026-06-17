import 'dart:math';

import '../models/group.dart';
import '../models/team.dart';
import '../models/football_match.dart';
import '../data/knockout_rules.dart';

class KnockoutGenerator {

  static List<FootballMatch> generateRoundOf32(List<Group> groups) {
    // 1. Extraemos todos los terceros lugares de los grupos
    final thirds = groups
        .map(
          (group) => group.teams.firstWhere(
            (team) => team.position == 3,
      ),
    )
        .toList();

    // Helpers para obtener primer y segundo lugar por letra de grupo
    Team first(String groupName) => groups
        .firstWhere((g) => g.name == groupName)
        .teams
        .firstWhere((t) => t.position == 1);

    Team second(String groupName) => groups
        .firstWhere((g) => g.name == groupName)
        .teams
        .firstWhere((t) => t.position == 2);

    // 2. Función interna corregida para emparejar a los mejores terceros
    Team pickThird(List<String> allowedGroups) {
      final candidates = thirds.where((team) {
        // Buscamos el grupo al que pertenece este equipo específico
        final parentGroup = groups.firstWhere((g) => g.teams.contains(team));
        // Ahora sí comparamos letras con letras: ej. ¿'A' está incluido en ['A', 'B', 'C']?
        return allowedGroups.contains(parentGroup.name);
      }).toList();

      // Salvaguarda: Si por un caso extremo matemático de combinaciones no quedan
      // candidatos del grupo permitido, tomamos el primer tercero que quede libre para no romper la app.
      if (candidates.isEmpty) {
        return thirds.removeAt(0);
      }

      candidates.shuffle();
      final selected = candidates.first;

      // Lo removemos de la lista global de terceros para que no se repita en otro partido
      thirds.remove(selected);
      return selected;
    }

    // 3. Retornamos la estructura de los partidos limpia
    return [
      FootballMatch(
        home: second('A'),
        away: second('B'),
      ),
      FootballMatch(
        home: first('C'),
        away: second('F'),
      ),
      FootballMatch(
        home: first('E'),
        away: pickThird(thirdPlaceRules[74]!),
      ),
      FootballMatch(
        home: first('F'),
        away: second('C'),
      ),
      FootballMatch(
        home: second('E'),
        away: second('I'),
      ),
      FootballMatch(
        home: first('I'),
        away: pickThird(thirdPlaceRules[77]!),
      ),
      FootballMatch(
        home: first('A'),
        away: pickThird(thirdPlaceRules[79]!),
      ),
      FootballMatch(
        home: first('L'),
        away: pickThird(thirdPlaceRules[80]!),
      ),
      FootballMatch(
        home: first('G'),
        away: pickThird(thirdPlaceRules[82]!),
      ),
      FootballMatch(
        home: first('D'),
        away: pickThird(thirdPlaceRules[81]!),
      ),
      FootballMatch(
        home: first('H'),
        away: second('J'),
      ),
      FootballMatch(
        home: second('K'),
        away: second('L'),
      ),
      FootballMatch(
        home: first('B'),
        away: pickThird(thirdPlaceRules[85]!),
      ),
      FootballMatch(
        home: first('J'),
        away: second('H'),
      ),
      FootballMatch(
        home: first('K'),
        away: pickThird(thirdPlaceRules[87]!),
      ),
      FootballMatch(
        home: second('D'),
        away: second('G'),
      ),
    ];
  }
}