import 'ai/ai.dart';

class GameLogic {
  static const empty = '';

  final List<List<String>> board;
  final AI ai;
  final String maybeAiPlayer;

  String get currentPlayer => _currentPlayer;
  String _currentPlayer;
  String get winner => _winner;
  String _winner;
  bool get gameOver => _gameOver;
  bool _gameOver;

  GameLogic({AI? ai, this.maybeAiPlayer = 'O'})
      : board = List.generate(3, (_) => List.generate(3, (_) => empty)),
        _currentPlayer = 'X', // Player X (human or AI) always starts now
        _winner = empty,
        _gameOver = false,
        ai = ai ?? const NoneAI();

  void makeMove(int row, int col) {
    if (board[row][col] == empty && !gameOver) {
      board[row][col] = currentPlayer;
      _checkWinner(row, col);

      if (!gameOver) {
        _currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        // Make AI move only if it's the AI's turn
        if (isAIsTurn()) {
          _makeAIMove();
        }
      }
    }
  }

  bool isAIsTurn() {
    return currentPlayer == maybeAiPlayer && ai is! NoneAI;
  }

  void _makeAIMove() {
    if (gameOver) return;

    Move? bestMove = ai.getMove(board, maybeAiPlayer);

    if (bestMove != null) {
      makeMove(bestMove.row, bestMove.col);
    }
  }

  void _checkWinner(int row, int col) {
    // Check row
    if (board[row].every((cell) => cell == currentPlayer)) {
      _winner = currentPlayer;
      _gameOver = true;
    }
    // Check column
    else if (board.every((row) => row[col] == currentPlayer)) {
      _winner = currentPlayer;
      _gameOver = true;
    }
    // Check diagonals
    else if ((row == col || row + col == 2) &&
        (board[0][0] == currentPlayer &&
                board[1][1] == currentPlayer &&
                board[2][2] == currentPlayer ||
            board[0][2] == currentPlayer &&
                board[1][1] == currentPlayer &&
                board[2][0] == currentPlayer)) {
      _winner = currentPlayer;
      _gameOver = true;
    }
    // Check for a tie
    else if (board.every((row) => row.every((cell) => cell != empty))) {
      _gameOver = true;
      _winner = "Tie";
    }
  }
}
