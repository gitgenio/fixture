import 'package:flutter/material.dart';

import '../../data/world_cup_data.dart';
import '../../models/group.dart';
import 'group_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FIFA World Cup'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const _HeaderWidget(),
            const SizedBox(height: 40),
            const Text(
              'GROUPS',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                // itemCount: groups.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  return _GroupButton(group: groups[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//---------------------------------------------------------
// Sub-widgets privados para mantener el código limpio
//---------------------------------------------------------

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.sports_soccer, size: 40),
        ),
        const SizedBox(width: 20),
        const Expanded(
          child: Text(
            'FIFA\nWORLD CUP',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _GroupButton extends StatelessWidget {
  final Group group;

  const _GroupButton({
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GroupScreen(
              group: group,
            ),
          ),
        );
      },
      child: Text(
        group.name,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}