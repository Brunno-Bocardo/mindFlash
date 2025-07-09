import 'package:app_flashcards/database/db_helper.dart';
import 'package:app_flashcards/model/dao_card.dart';
import 'package:flutter/material.dart';

void showCreateCardDialog(BuildContext context, int? deckId) {
  final frontController = TextEditingController();
  final backController = TextEditingController();

  showDialog(
    context: context, 
    builder: (dialogContext) => AlertDialog(
      title: const Text('Criar Card'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: frontController,
            decoration: const InputDecoration(
              labelText: 'Pergunta' 
            ),
          ),
          TextField(
            controller: backController,
            decoration: const InputDecoration(
              labelText: 'Resposta',
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(), 
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final front = frontController.text.trim();
            final back = backController.text.trim();
            createCard(front, back, deckId, context);

          }, 
          child: const Text('Criar'))
      ],
    )
  );
}

void createCard(String front, String back, int? deckId, BuildContext context) {
  try {

    if(front.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A frente do card não pode estar vazia.')),
      );
      return;
    } else if (back.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O campo resposta não pode estar vazio.')),
      );
      return;
    }

    final card =  {
      'deckId': deckId,
      'question': front,
      'answer': back,
      'consecutiveHits': 0,
      'hidden': false
    };

    DBHelper.getInstance().then((db) {
      CardDao.insertCard(db, card);
    });
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Card criado com sucesso!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro: $e')),
    );
  }
}