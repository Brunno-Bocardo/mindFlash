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
          onPressed: () async {_deleteCard(card, context);}, 
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
            _updateCard(question, answer, card, context);
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