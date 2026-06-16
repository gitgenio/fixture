import 'package:flutter/material.dart';
import '../../data/world_cup_data.dart';
import '../../models/group.dart';
import 'group_screen.dart';
// import 'round_of_32_screen.dart'; // Asegúrate de importar la pantalla de 16avos
import 'package:fixture2026/src/screens/round_of_32_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  /// Función que verifica si absolutamente todos los equipos de todos los grupos
  /// ya tienen una posición asignada (es decir, el grupo fue completado).
  bool _areAllGroupsCompleted() {
    return groups.every((group) =>
        group.teams.every((team) => team.position != null)
    );
  }

  @override
  Widget build(BuildContext context) {
    final isReadyForRoundOf32 = _areAllGroupsCompleted();

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
                itemCount: groups.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  return _GroupButton(
                    group: groups[index],
                    // Pasamos un callback para refrescar la pantalla al volver
                    onReturn: () => setState(() {}),
                  );
                },
              ),
            ),

            //---------------------------------------------------------
            // Botón dinámico para avanzar a los 16avos de final
            //---------------------------------------------------------
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                // Si están listos, habilita el botón; si no, queda deshabilitado (null)
                onPressed: isReadyForRoundOf32
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RoundOf32Screen(groups: groups),
                    ),
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  disabledForegroundColor: Colors.grey[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.emoji_events),
                label: const Text(
                  'AVANZAR A 16AVOS',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

//---------------------------------------------------------
// Sub-widgets privados modificados
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
  final VoidCallback onReturn; // Callback añadido

  const _GroupButton({
    required this.group,
    required this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    // Evaluamos si el grupo actual ya tiene sus posiciones definidas
    final isGroupFinished = group.teams.every((t) => t.position != null);

    return ElevatedButton(
      onPressed: () async {
        // Al usar 'await', el código se detiene aquí hasta que el usuario regresa de GroupScreen
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GroupScreen(
              group: group,
            ),
          ),
        );
        // Cuando regresa, ejecutamos el callback que dispara el setState en HomeScreen
        onReturn();
      },
      style: ElevatedButton.styleFrom(
        // Si el grupo está listo, le damos un color sutil (ej. verde claro) para distinguirlo
        backgroundColor: isGroupFinished ? Colors.green.withOpacity(0.2) : null,
        side: isGroupFinished ? const BorderSide(color: Colors.green, width: 1.5) : null,
      ),
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