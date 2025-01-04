// Suggested code may be subject to a license. Learn more: ~LicenseLog:217156175.
import 'package:flutter/material.dart';
import 'game_logic.dart';
import 'ai/ai.dart';
import 'game_setup_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameLogic _gameLogic;
  GameSetupResult _lastGameSetupResult =
      const GameSetupResult(selectedAI: NoneAI(), isHumanFirst: true);

  @override
  void initState() {
    super.initState();
    _gameLogic = GameLogic();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showGameSetupDialog();
    });
  }

  void _showGameSetupDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GameSetupDialog(_lastGameSetupResult);
      },
    ).then((setupResult) {
      if (setupResult != null) {
        _lastGameSetupResult = setupResult;
        _startGame(setupResult);
      }
    });
  }

  void _startGame(GameSetupResult result) {
    setState(() {
      _gameLogic = GameLogic(
        ai: result.selectedAI,
        maybeAiPlayer: result.isHumanFirst ? 'O' : 'X',
      );
      // Make AI move only if AI starts
      if (_gameLogic.ai is! NoneAI && !result.isHumanFirst) {
        _makeAIMove();
      }
    });
  }

  void _handleTap(int row, int col) {
    if (_gameLogic.board[row][col] == GameLogic.empty &&
        !_gameLogic.gameOver &&
        !_gameLogic.isAIsTurn()) {
      setState(() {
        _gameLogic.makeMove(row, col);
      });

      if (_gameLogic.gameOver) {
        _showGameOverDialog();
      }
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: _gameLogic.winner == "Tie"
              ? const Text("It's a tie!")
              : Text(_gameLogic.ai is! NoneAI &&
                      _gameLogic.winner == _gameLogic.maybeAiPlayer
                  ? "AI wins!"
                  : "Player ${_gameLogic.winner} wins!"),
          actions: <Widget>[
            TextButton(
              child: const Text("Play Again"),
              onPressed: () {
                Navigator.of(context).pop();
                _showGameSetupDialog();
              },
            ),
          ],
        );
      },
    );
  }

  void _makeAIMove() {
    if (_gameLogic.gameOver) return;

    Move? bestMove =
        _gameLogic.ai.getMove(_gameLogic.board, _gameLogic.maybeAiPlayer);

    if (bestMove != null) {
      _gameLogic.makeMove(bestMove.row, bestMove.col);
    }
  }

  Widget _buildBoard() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AspectRatio(
        aspectRatio: 1.0, // Ensure the board is always a square
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determine the size of the board based on available space
            double boardSize = constraints.maxWidth;

            // Use FittedBox to scale down the board if it's too large
            return FittedBox(
              fit: BoxFit.contain, // Scale down to fit
              child: SizedBox(
                width: boardSize,
                height: boardSize,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: 9,
                  itemBuilder: (BuildContext context, int index) {
                    int row = index ~/ 3;
                    int col = index % 3;
                    return GestureDetector(
                      onTap: () => _handleTap(row, col),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            _gameLogic.board[row][col],
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: _buildBoard(),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: _gameLogic.gameOver
                  ? Text(
                      _gameLogic.winner == "Tie"
                          ? "It's a Tie!"
                          : "Winner: ${_gameLogic.winner}",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      "Current Player: ${_gameLogic.currentPlayer}",
                      style: const TextStyle(fontSize: 24),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
