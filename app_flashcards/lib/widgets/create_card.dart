import 'package:app_flashcards/database/db_helper.dart';
import 'package:app_flashcards/model/dao_card.dart';
import 'package:app_flashcards/model/dao_deck.dart';
import 'package:flutter/material.dart';

Future<bool> showCreateCardDialog(BuildContext context, int? deckId) async {
  final frontController = TextEditingController();
  final backController = TextEditingController();
  
  // result é retornado para validar na tela que chamou o Dialog
  final result = await showDialog<bool>(
    context: context, 
    builder: (dialogContext) => AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 254, 255),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Criar Card',
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
            controller: frontController,
            maxLength: 200,
            maxLines: 1,
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
            controller: backController,
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
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final front = frontController.text.trim();
            final back = backController.text.trim();
            final success = await createCard(front, back, deckId, dialogContext);
            if (success) {
              Navigator.of(dialogContext).pop(true);
            }
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
  
  return result ?? false;
}

Future<bool> createCard(String front, String back, int? deckId, BuildContext context) async {
  try {
    if(front.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A frente do card não pode estar vazia.')),
      );
      return false;
    } else if (back.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O campo resposta não pode estar vazio.')),
      );
      return false;
    }

    final card = {
      'deckId': deckId,
      'question': front,
      'answer': back,
      'consecutiveHits': 0,
      'hidden': 0
    };

    DBHelper.getInstance().then((db) {
      CardDao.insertCard(db, card);
    });
    // incrementa o total de cards no deck
    DBHelper.getInstance().then((db) {
      DeckDao.incrementTotalCards(db, deckId!);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Card criado com sucesso!')),
    );
    return true;
  } 
  catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro: $e')),
    );
    return false;
  }
}