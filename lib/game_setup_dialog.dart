import 'package:flutter/material.dart';
import 'ai/ai.dart';
import 'ai/easy_ai.dart';
import 'ai/advanced_ai.dart';
import 'ai/hard_ai.dart';

class GameSetupResult {
  final AI selectedAI;
  final bool isHumanFirst;

  const GameSetupResult({required this.selectedAI, required this.isHumanFirst});
}

class GameSetupDialog extends StatefulWidget {
  final GameSetupResult initResult;

  const GameSetupDialog(this.initResult, {super.key});

  @override
  State<GameSetupDialog> createState() => _GameSetupDialogState();
}

class _GameSetupDialogState extends State<GameSetupDialog> {
  static const EasyAI _easyAI = EasyAI();
  static const AdvancedAI _advancedAI = AdvancedAI();
  static const HardAI _hardAI = HardAI();

  bool _isAgainstAI = false;
  AI _selectedAI = const NoneAI();
  bool _isHumanFirst = true;

  @override
  void initState() {
    super.initState();

    _isAgainstAI = widget.initResult.selectedAI is! NoneAI;
    _selectedAI = widget.initResult.selectedAI;
    _isHumanFirst = widget.initResult.isHumanFirst;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Game Setup"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text("Play against AI:"),
              Checkbox(
                value: _isAgainstAI,
                onChanged: (value) {
                  setState(() {
                    _isAgainstAI = value!;
                    if (!_isAgainstAI) {
                      _selectedAI = const NoneAI();
                    }
                  });
                },
              ),
            ],
          ),
          if (_isAgainstAI) ...[
            const SizedBox(height: 10),
            DropdownButtonFormField<AI>(
              decoration: const InputDecoration(
                labelText: "AI Difficulty",
              ),
              value: _selectedAI is NoneAI ? null : _selectedAI,
              onChanged: (value) {
                setState(() {
                  _selectedAI = value!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: _easyAI,
                  child: Text("Easy"),
                ),
                DropdownMenuItem(
                  value: _advancedAI,
                  child: Text("Advanced"),
                ),
                DropdownMenuItem(
                  value: _hardAI,
                  child: Text("Hard"),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Human starts:"),
              Checkbox(
                value: _isHumanFirst,
                onChanged: (value) {
                  setState(() {
                    _isHumanFirst = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Start Game"),
          onPressed: () {
            Navigator.of(context).pop(GameSetupResult(
              selectedAI: _selectedAI,
              isHumanFirst: _isHumanFirst,
            ));
          },
        ),
      ],
    );
  }
}
