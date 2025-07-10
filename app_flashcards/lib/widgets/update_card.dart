import 'package:flutter/material.dart';
import 'package:app_flashcards/model/card.dart';
import 'package:app_flashcards/model/dao_card.dart';
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
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            final newQuestion = questionController.text.trim();
            final newAnswer = answerController.text.trim();
            if (newQuestion.isEmpty || newAnswer.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preencha todos os campos.')),
              );
              return;
            }
            final updatedCard = Flashcard(
              id: card.id,
              deckId: card.deckId,
              question: newQuestion,
              answer: newAnswer,
              consecutiveHits: card.consecutiveHits,
              hidden: card.hidden,
            );
            final db = await DBHelper.getInstance();
            await CardDao.updateCard(db, updatedCard);
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Card atualizado!')),
            );
          },
          child: const Text('Salvar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 208, 90, 81)),
          onPressed: () async {
            final db = await DBHelper.getInstance();
            await CardDao.deleteCard(db, card.id!);
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Card excluído!')),
            );
          },
          child: const Text('Excluir'),
        ),
      ],
    ),
  );
}