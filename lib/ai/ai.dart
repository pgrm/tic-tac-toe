class Move {
  int row;
  int col;

  Move(this.row, this.col);
}

abstract class AI {
  Move? getMove(List<List<String>> board, String aiPlayer);
}

class NoneAI implements AI {
  const NoneAI();

  @override
  Move? getMove(List<List<String>> board, String aiPlayer) {
    return null;
  }
}
