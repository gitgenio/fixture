import 'package:fixture2026/models/team.dart';

class FootballMatch {
  final Team home;
  final Team away;

  Team? winner;

  FootballMatch({
    required this.home,
    required this.away,
    this.winner,
  });
}