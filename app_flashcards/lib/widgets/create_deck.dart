import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:app_flashcards/model/dao_deck.dart';
import 'package:app_flashcards/database/db_helper.dart';
import 'package:app_flashcards/model/deck.dart';
import 'package:firebase_auth/firebase_auth.dart';


void showCreateDeckDialog(BuildContext context) {
  final nameController = TextEditingController();
  final descController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Criar Deck'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nome do Deck'),
          ),
          TextField(
            controller: descController,
            decoration: const InputDecoration(labelText: 'Descrição'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            final desc = descController.text.trim();
            createDeck(name, desc, context);
            // refresh the deck list
            context.go('/home');
          },
          child: const Text('Criar'),
        ),
      ],
    ),
  );
}

void createDeck(String name, String desc, BuildContext context) {
  try {

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O nome do deck não pode estar vazio.')),
      );
      return;
    } else if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A descrição não pode estar vazia.')),
      );
      return;
    }

    final userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    final deck = {
      'name': name,
      'description': desc,
      'userEmail': userEmail,
      'cardsReviewed': 0,
      'totalCards': 0,
    };

    DBHelper.getInstance().then((db) {
      DeckDao.insertDeck(db, deck);
    });
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Deck criado com sucesso!')),
    );
    


  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro: $e')),
    );
  }
}