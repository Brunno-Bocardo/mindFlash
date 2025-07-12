import 'package:flutter/material.dart';
import 'package:app_flashcards/model/card.dart';
import 'package:app_flashcards/model/dao_card.dart';
import 'package:app_flashcards/model/dao_deck.dart';
import 'package:app_flashcards/database/db_helper.dart';

void showUpdateCardDialog(BuildContext context, Flashcard card) {
  final questionController = TextEditingController(text: card.question);
  final answerController = TextEditingController(text: card.answer);

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Editar Card'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: questionController,
            decoration: const InputDecoration(labelText: 'Pergunta'),
          ),
          TextField(
            controller: answerController,
            decoration: const InputDecoration(labelText: 'Resposta'),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 208, 90, 81)
          ),
          onPressed: () async { _deleteCard(card, context); },
          child: const Text('Excluir'),
        ),
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.of(dialogContext).pop(),
        ),
        ElevatedButton(
          child: const Text('Salvar'),
          onPressed: () async {
            final question = questionController.text.trim();
            final answer = answerController.text.trim();
            _updateCard(question, answer, card, context);
          },
        ),
      ],
    ),
  );
}

void _updateCard(String question, String answer, Flashcard oldCard, BuildContext context) {
  try {
    if (question.isEmpty || answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }
    final updatedCard = Flashcard(id: oldCard.id, deckId: oldCard.deckId, question: question, answer: answer, consecutiveHits: oldCard.consecutiveHits, hidden: oldCard.hidden, );

    DBHelper.getInstance().then((db) {
      CardDao.updateCard(db, updatedCard);
    });
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card atualizado!')),
    );
  } 
  
  catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao atualizar card: $e')),
    );
  }
}

void _deleteCard(Flashcard card, BuildContext context) async {
  final db = await DBHelper.getInstance();
  await CardDao.deleteCard(db, card.id!);
  await DeckDao.decrementTotalCards(db, card.deckId);
  Navigator.of(context).pop();
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Card excluído!')),
  );
}