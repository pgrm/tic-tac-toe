import 'dart:math';
import 'ai.dart';

class EasyAI implements AI {
  const EasyAI();

  @override
  Move? getMove(List<List<String>> board, String aiPlayer) {
    List<Move> availableMoves = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          availableMoves.add(Move(i, j));
        }
      }
    }

    if (availableMoves.isEmpty) {
      return null;
    }

    Random random = Random();
    int randomIndex = random.nextInt(availableMoves.length);
    return availableMoves[randomIndex];
  }
}
