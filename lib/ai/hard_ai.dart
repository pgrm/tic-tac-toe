import 'dart:math';
import 'package:tic_tac_toe/ai/advanced_ai.dart';

import 'ai.dart';

class HardAI extends AdvancedAI {
  const HardAI();

  @override
  Move? getMove(List<List<String>> board, String aiPlayer) {
    int bestScore = -1000;
    Move? bestMove;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          board[i][j] = aiPlayer;
          int score = _minimax(board, 0, false, aiPlayer);
          board[i][j] = ''; // Undo move

          if (score > bestScore) {
            bestScore = score;
            bestMove = Move(i, j);
          }
        }
      }
    }
    return bestMove;
  }

  int _minimax(
      List<List<String>> board, int depth, bool isMaximizing, String aiPlayer) {
    String humanPlayer = aiPlayer == 'X' ? 'O' : 'X';
    if (checkWin(board, aiPlayer)) {
      return 10;
    }
    if (checkWin(board, humanPlayer)) {
      return -10;
    }
    if (_isBoardFull(board)) {
      return 0;
    }

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == '') {
            board[i][j] = aiPlayer;
            int score = _minimax(board, depth + 1, false, aiPlayer);
            board[i][j] = '';
            bestScore = max(score, bestScore);
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == '') {
            board[i][j] = humanPlayer;
            int score = _minimax(board, depth + 1, true, aiPlayer);
            board[i][j] = '';
            bestScore = min(score, bestScore);
          }
        }
      }
      return bestScore;
    }
  }

  bool _isBoardFull(List<List<String>> board) {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          return false;
        }
      }
    }
    return true;
  }
}
