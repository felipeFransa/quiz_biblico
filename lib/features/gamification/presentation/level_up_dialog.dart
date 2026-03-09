import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class LevelUpDialog extends StatefulWidget {
  final int newLevel;
  final String? unlockedTheme;

  const LevelUpDialog({
    super.key, 
    required this.newLevel, 
    this.unlockedTheme
  });

  @override
  State<LevelUpDialog> createState() => _LevelUpDialogState();
}

class _LevelUpDialogState extends State<LevelUpDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            '🌟 Nível ${widget.newLevel}! 🌟',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars, size: 80, color: Colors.amber),
              const SizedBox(height: 16),
              Text(
                'Parabéns! Você avançou em sua jornada bíblica.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              if (widget.unlockedTheme != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.palette, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Novo tema desbloqueado: ${widget.unlockedTheme}',
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.green[800]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('GLÓRIA A DEUS!'),
            ),
          ],
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.amber, Colors.orange, Colors.blue, Colors.green],
        ),
      ],
    );
  }
}
