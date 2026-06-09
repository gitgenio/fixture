import 'package:fixture2026/models/team.dart';

class Match {
  final Team home;
  final Team away;

  Team? winner;

  Match({
    required this.home,
    required this.away,
    this.winner,
  });
}