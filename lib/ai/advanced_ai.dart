import 'dart:math';
import 'package:flutter/material.dart';

import 'ai.dart';

class AdvancedAI implements AI {
  const AdvancedAI();

  @override
  Move? getMove(List<List<String>> board, String aiPlayer) {
    List<Move> availableMoves = [];
    List<Move> winningMoves = [];
    List<Move> blockingMoves = [];

    String humanPlayer = aiPlayer == 'X' ? 'O' : 'X';

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          Move move = Move(i, j);
          availableMoves.add(move);

          // Check if this move wins for the AI
          board[i][j] = aiPlayer;
          if (checkWin(board, aiPlayer)) {
            winningMoves.add(move);
          }
          board[i][j] = ''; // Reset

          // Check if this move blocks the human player from winning
          board[i][j] = humanPlayer;
          if (checkWin(board, humanPlayer)) {
            blockingMoves.add(move);
          }
          board[i][j] = ''; // Reset
        }
      }
    }

    if (winningMoves.isNotEmpty) {
      return winningMoves.first; // Win immediately if possible
    } else if (blockingMoves.isNotEmpty) {
      return blockingMoves.first; // Block the player if necessary
    } else if (availableMoves.isNotEmpty) {
      Random random = Random();
      return availableMoves[random.nextInt(availableMoves.length)];
    } else {
      return null;
    }
  }

  @protected
  bool checkWin(List<List<String>> board, String player) {
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == player &&
          board[i][1] == player &&
          board[i][2] == player) {
        return true;
      }
      if (board[0][i] == player &&
          board[1][i] == player &&
          board[2][i] == player) {
        return true;
      }
    }
    if (board[0][0] == player &&
        board[1][1] == player &&
        board[2][2] == player) {
      return true;
    }
    if (board[0][2] == player &&
        board[1][1] == player &&
        board[2][0] == player) {
      return true;
    }
    return false;
  }
}
