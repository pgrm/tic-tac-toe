import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/game_logic.dart';
import 'package:tic_tac_toe/ai/easy_ai.dart';
import 'package:tic_tac_toe/ai/advanced_ai.dart';
import 'package:tic_tac_toe/ai/hard_ai.dart';

void main() {
  group('GameLogic Tests', () {
    late GameLogic gameLogic;

    setUp(() {
      gameLogic = GameLogic();
    });

    test('Initial board is empty', () {
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          expect(gameLogic.board[i][j], GameLogic.empty);
        }
      }
    });

    test('Make move updates board', () {
      gameLogic.makeMove(0, 0);
      expect(gameLogic.board[0][0], 'X');
      gameLogic.makeMove(1, 1);
      expect(gameLogic.board[1][1], 'O');
    });

    test('Alternating players', () {
      expect(gameLogic.currentPlayer, 'X');
      gameLogic.makeMove(0, 0);
      expect(gameLogic.currentPlayer, 'O');
      gameLogic.makeMove(1, 1);
      expect(gameLogic.currentPlayer, 'X');
    });

    test('Detect horizontal win', () {
      gameLogic.makeMove(0, 0); // X
      gameLogic.makeMove(1, 0); // O
      gameLogic.makeMove(0, 1); // X
      gameLogic.makeMove(1, 1); // O
      gameLogic.makeMove(0, 2); // X - Win

      expect(gameLogic.winner, 'X');
      expect(gameLogic.gameOver, true);
    });

    test('Detect vertical win', () {
      gameLogic.makeMove(0, 0); // X
      gameLogic.makeMove(0, 1); // O
      gameLogic.makeMove(1, 0); // X
      gameLogic.makeMove(1, 1); // O
      gameLogic.makeMove(2, 0); // X - Win

      expect(gameLogic.winner, 'X');
      expect(gameLogic.gameOver, true);
    });

    test('Detect diagonal win', () {
      gameLogic.makeMove(0, 0); // X
      gameLogic.makeMove(0, 1); // O
      gameLogic.makeMove(1, 1); // X
      gameLogic.makeMove(1, 2); // O
      gameLogic.makeMove(2, 2); // X - Win

      expect(gameLogic.winner, 'X');
      expect(gameLogic.gameOver, true);
    });

    test('Detect tie game', () {
      gameLogic.makeMove(0, 0); // X
      gameLogic.makeMove(0, 1); // O
      gameLogic.makeMove(0, 2); // X
      gameLogic.makeMove(1, 0); // O
      gameLogic.makeMove(1, 2); // X
      gameLogic.makeMove(1, 1); // O
      gameLogic.makeMove(2, 0); // X
      gameLogic.makeMove(2, 2); // O
      gameLogic.makeMove(2, 1); // X - Tie

      expect(gameLogic.winner, 'Tie');
      expect(gameLogic.gameOver, true);
    });
  });

  group('AI Tests', () {
    test('Easy AI makes a random move', () {
      const ai = EasyAI();
      final board = List.generate(3, (_) => List.generate(3, (_) => ''));
      final move = ai.getMove(board, 'X');

      // Check that the move is within valid bounds
      expect(move, isNotNull);
      expect(move!.row, greaterThanOrEqualTo(0));
      expect(move.row, lessThan(3));
      expect(move.col, greaterThanOrEqualTo(0));
      expect(move.col, lessThan(3));

      // Check that the chosen cell is empty
      expect(board[move.row][move.col], '');
    });

    test('Advanced AI blocks player from winning', () {
      const ai = AdvancedAI();
      final board = [
        ['X', 'X', ''],
        ['O', '', ''],
        ['', '', ''],
      ];
      final move = ai.getMove(board, 'O');

      expect(move, isNotNull);
      expect(move!.row, 0);
      expect(move.col, 2);
    });

    test('Advanced AI wins when possible', () {
      const ai = AdvancedAI();
      final board = [
        ['X', 'X', ''],
        ['O', '', ''],
        ['O', '', ''],
      ];
      final move = ai.getMove(board, 'X');

      expect(move, isNotNull);
      expect(move!.row, 0);
      expect(move.col, 2);
    });

    test('Hard AI makes a valid move', () {
      const ai = HardAI();
      final board = List.generate(3, (_) => List.generate(3, (_) => ''));
      final move = ai.getMove(board, 'X');

      expect(move, isNotNull);
      expect(move!.row, greaterThanOrEqualTo(0));
      expect(move.row, lessThan(3));
      expect(move.col, greaterThanOrEqualTo(0));
      expect(move.col, lessThan(3));
    });

    test('Hard AI should return a move that leads to a win or tie', () {
      // Arrange
      const ai = HardAI();
      final board = [
        ['X', '', 'O'],
        ['', 'X', ''],
        ['', '', 'O']
      ];

      // Act
      final move = ai.getMove(board, 'X');

      // Assert
      expect(move, isNotNull);
      expect(move!.row, equals(1));
      expect(move.col, equals(2));
    });
  });
}
