import 'dart:math';

import 'package:flutter/material.dart';
import '../../models/football_match.dart';
import '../../models/group.dart';
import '../../models/team.dart';
import '../../services/knockout_generator.dart';

class RoundOf32Screen extends StatefulWidget {
  final List<Group> groups;

  const RoundOf32Screen({Key? key, required this.groups}) : super(key: key);

  @override
  State<RoundOf32Screen> createState() => _RoundOf32ScreenState();
}

class _RoundOf32ScreenState extends State<RoundOf32Screen> {
  // Cambiado a FootballMatch
  late List<FootballMatch> _matches;
  int _currentMatchIndex = 0;

  @override
  void initState() {
    super.initState();
    // NOTA: Asegúrate de que tu KnockoutGenerator también retorne List<FootballMatch>
    _matches = KnockoutGenerator.generateRoundOf32(widget.groups);
  }

  void _selectWinner(Team team) {
    setState(() {
      _matches[_currentMatchIndex].winner = team;

      if (_currentMatchIndex < _matches.length - 1) {
        _currentMatchIndex++;
      } else {
        _showTournamentFinishedDialog();
      }
    });
  }

  void _previousMatch() {
    if (_currentMatchIndex > 0) {
      setState(() {
        _currentMatchIndex--;
      });
    }
  }

  void _showTournamentFinishedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¡16avos Completados!'),
        content: const Text('Has seleccionado los ganadores para todos los partidos de esta ronda.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Continuar a Octavos'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_matches.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No se pudieron generar los partidos.')),
      );
    }

    final currentMatch = _matches[_currentMatchIndex];
    final progress = (_currentMatchIndex + 1) / _matches.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('16avos de Final'),
        leading: _currentMatchIndex > 0
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousMatch,
        )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column( // CORREGIDO: child en lugar de content
            children: [
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 16),
              Text(
                'Partido ${_currentMatchIndex + 1} de ${_matches.length}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selecciona al equipo que clasifica a la siguiente ronda',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const Spacer(),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _TeamSelectionCard(
                          team: currentMatch.home,
                          isSelected: currentMatch.winner == currentMatch.home,
                          onTap: () => _selectWinner(currentMatch.home),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'VS',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontStyle: FontStyle.italic, // CORREGIDO: fontStyle en lugar de fontWeight
                            color: Colors.grey[400],
                          ),
                        ),
                      ),

                      Expanded(
                        child: _TeamSelectionCard(
                          team: currentMatch.away,
                          isSelected: currentMatch.winner == currentMatch.away,
                          onTap: () => _selectWinner(currentMatch.away),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              if (currentMatch.winner != null && _currentMatchIndex < _matches.length - 1)
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentMatchIndex++;
                    });
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Siguiente Partido'),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamSelectionCard extends StatelessWidget {
  final Team team;
  final bool isSelected;
  final VoidCallback onTap;

  const _TeamSelectionCard({
    Key? key,
    required this.team,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withOpacity(0.15) : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
            width: isSelected ? 2.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey[200],
              child: Text(
                team.name.substring(0, min(3, team.name.length)).toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              team.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isSelected) ...[
              const SizedBox(height: 8),
              const Icon(Icons.check_circle, color: Colors.green),
            ]
          ],
        ),
      ),
    );
  }
}