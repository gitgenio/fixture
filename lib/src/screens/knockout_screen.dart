import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/football_match.dart';
import '../../models/team.dart';
import '../../services/knockout_generator.dart';

class KnockoutScreen extends StatefulWidget {
  final String title;

  final List<FootballMatch> matches;

  final List<List<int>>? nextBracket;

  final String? nextTitle;

  const KnockoutScreen({
    super.key,
    required this.title,
    required this.matches,
    this.nextBracket,
    this.nextTitle,
  });

  @override
  State<KnockoutScreen> createState() => _KnockoutScreenState();
}

class _KnockoutScreenState extends State<KnockoutScreen> {
  late List<FootballMatch> _matches;

  int _currentMatchIndex = 0;

  @override
  void initState() {
    super.initState();

    _matches = widget.matches;
  }

  void _selectWinner(Team team) {
    setState(() {
      _matches[_currentMatchIndex].winner = team;
    });
  }

  void _nextMatch() {
    if (_currentMatchIndex < _matches.length - 1) {
      setState(() {
        _currentMatchIndex++;
      });
    } else {
      _finishRound();
    }
  }

  void _previousMatch() {
    if (_currentMatchIndex > 0) {
      setState(() {
        _currentMatchIndex--;
      });
    }
  }

  void _finishRound() {
    if (widget.nextBracket == null) {
      _showChampionDialog();
      return;
    }

    final nextRound = KnockoutGenerator.generateNextRound(
      previousRound: _matches,
      bracket: widget.nextBracket!,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => KnockoutScreen(
          title: widget.nextTitle!,
          matches: nextRound,
          nextBracket: _getNextBracket(widget.nextTitle!),
          nextTitle: _getNextTitle(widget.nextTitle!),
        ),
      ),
    );
  }

  List<List<int>>? _getNextBracket(String title) {
    switch (title) {
      case 'Octavos de Final':
        return quarterFinalBracket;

      case 'Cuartos de Final':
        return semiFinalBracket;

      case 'Semifinal':
        return finalBracket;

      case 'Final':
        return null;

      default:
        return null;
    }
  }

  String? _getNextTitle(String title) {
    switch (title) {
      case 'Octavos de Final':
        return 'Cuartos de Final';

      case 'Cuartos de Final':
        return 'Semifinal';

      case 'Semifinal':
        return 'Final';

      case 'Final':
        return null;

      default:
        return null;
    }
  }

  void _showChampionDialog() {
    final champion = _matches.first.winner!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("🏆 Campeón"),
        content: Text(
          "${champion.flag}\n\n${champion.name}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text("Inicio"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_matches.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const Center(
          child: Text('No hay partidos disponibles.'),
        ),
      );
    }

    final currentMatch = _matches[_currentMatchIndex];
    final progress = (_currentMatchIndex + 1) / _matches.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: _currentMatchIndex > 0
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousMatch,
        )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              LinearProgressIndicator(value: progress),

              const SizedBox(height: 16),

              Text(
                'Partido ${_currentMatchIndex + 1} de ${_matches.length}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Selecciona el ganador del partido',
                style: TextStyle(color: Colors.grey),
              ),

              const Spacer(),

              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [

                      Expanded(
                        child: _TeamSelectionCard(
                          team: currentMatch.home,
                          isSelected:
                          currentMatch.winner == currentMatch.home,
                          onTap: () =>
                              _selectWinner(currentMatch.home),
                        ),
                      ),

                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "VS",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

                      Expanded(
                        child: _TeamSelectionCard(
                          team: currentMatch.away,
                          isSelected:
                          currentMatch.winner == currentMatch.away,
                          onTap: () =>
                              _selectWinner(currentMatch.away),
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: currentMatch.winner == null
                      ? null
                      : _nextMatch,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(
                    _currentMatchIndex == _matches.length - 1
                        ? "Finalizar ronda"
                        : "Siguiente partido",
                  ),
                ),
              ),

              const SizedBox(height: 20),

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
    super.key,
    required this.team,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green.withOpacity(0.15)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? Colors.green
                : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey.shade200,
              child: Text(
                team.flag,
                style: const TextStyle(fontSize: 28),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              team.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),

            if (isSelected) ...[
              const SizedBox(height: 10),
              const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            ],
          ],
        ),
      ),
    );
  }
}