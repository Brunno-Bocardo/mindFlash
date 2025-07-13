import 'package:flutter/material.dart';
import 'package:app_flashcards/model/card.dart';
import 'package:app_flashcards/model/dao_card.dart';
import 'package:app_flashcards/model/dao_deck.dart';
import 'package:app_flashcards/database/db_helper.dart';

Future<bool> showUpdateCardDialog(BuildContext context, Flashcard card) async {
  final questionController = TextEditingController(text: card.question);
  final answerController = TextEditingController(text: card.answer);

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 254, 255),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Editar Card',
            style: TextStyle(
              fontSize: 22,
              color: Color.fromARGB(255, 124, 48, 114),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Icon(Icons.close, size: 40, color: Color.fromARGB(255, 124, 48, 114)),
          ),
      ]),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: questionController,
            maxLength: 200,
            decoration: InputDecoration(
              labelText: 'Pergunta',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromARGB(164, 126, 126, 126), // cor da borda
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                  color: Color.fromARGB(255, 149, 34, 134),
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          TextField(
            controller: answerController,
            maxLength: 400,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Resposta',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromARGB(164, 126, 126, 126), // cor da borda
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                  color: Color.fromARGB(255, 149, 34, 134),
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final deleted = await _deleteCard(card, context);
            if (deleted) {
              Navigator.of(dialogContext).pop(true);
            }
          }, 
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 208, 90, 81),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder( // borda arredondada
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Excluir', style: TextStyle(fontSize: 20))
        ),
        ElevatedButton(
          onPressed: () async {
            final question = questionController.text.trim();
            final answer = answerController.text.trim();
            final updated = await _updateCard(question, answer, card, context);
            if (updated) {
              Navigator.of(dialogContext).pop(true);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 176, 72, 163),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Salvar', style: TextStyle(fontSize: 20)))
      ],
    ),
  );
  return result ?? false;
}

Future<bool> _updateCard(String question, String answer, Flashcard oldCard, BuildContext context) async {
  try {
    if (question.isEmpty || answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return false;
    }
    final updatedCard = Flashcard(id: oldCard.id, deckId: oldCard.deckId, question: question, answer: answer, consecutiveHits: oldCard.consecutiveHits, hidden: oldCard.hidden, );


    final db = await DBHelper.getInstance();
    await CardDao.updateCard(db, updatedCard);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card atualizado!')),
    );
    return true;
  } 
  catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao atualizar card: $e')),
    );
    return false;
  }
}

Future<bool> _deleteCard(Flashcard card, BuildContext context) async {
  final db = await DBHelper.getInstance();
  await CardDao.deleteCard(db, card.id!);
  await DeckDao.decrementTotalCards(db, card.deckId);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Card excluído!')),
  );
  return true;
}