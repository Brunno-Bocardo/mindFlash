import 'package:app_flashcards/database/db_helper.dart';
import 'package:app_flashcards/model/dao_card.dart';
import 'package:app_flashcards/model/dao_deck.dart';
import 'package:flutter/material.dart';

void showCreateCardDialog(BuildContext context, int? deckId) {
  final frontController = TextEditingController();
  final backController = TextEditingController();

  showDialog(
    context: context, 
    builder: (dialogContext) => AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 254, 255),
      title: Row(
        children: [
          Text(
            'Criar Card',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 124, 48, 114),
            ),
          ),
          SizedBox(width: 90),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Icon(Icons.close, size: 40, color: Color.fromARGB(255, 124, 48, 114)),
          ),
      ]),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: frontController,
            maxLength: 200,
            maxLines: 2,
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
          SizedBox(height: 15),
          TextField(
            controller: backController,
            maxLength: 400,
            maxLines: 3,
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
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final front = frontController.text.trim();
            final back = backController.text.trim();
            createCard(front, back, deckId, context);

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 176, 72, 163),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder( // borda arredondada
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Criar', style: TextStyle(fontSize: 20)))
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
    // incrementa o total de cards no deck
    DBHelper.getInstance().then((db) {
      DeckDao.incrementTotalCards(db, deckId!);
    });
    // fecha e finaliza
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