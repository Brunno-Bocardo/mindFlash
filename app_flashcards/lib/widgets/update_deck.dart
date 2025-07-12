import 'package:app_flashcards/database/db_helper.dart';
import 'package:app_flashcards/model/dao_deck.dart';
import 'package:app_flashcards/model/deck.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showUpdateDeckDialog(BuildContext context, Deck? deck) {
  final nameController = TextEditingController();
  final descController = TextEditingController();

  if(deck != null) {
    nameController.text = deck.name;
    descController.text = deck.description;
  }

  showDialog(
    context: context, 
    builder: (dialogContext) => AlertDialog(
      title: const Text('Editar Deck'),
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
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 208, 90, 81)
          ),
          onPressed: () async { 
            if(deck != null) {
              _deleteDeck(deck, context);
              context.go('/home');
            }
          },
          child: const Text('Excluir')
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(), 
          child: const Text('Cancelar')
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            final desc = descController.text.trim();
            if(deck != null){
              _updateDeck(name, desc, deck, context);
            }
            //Modificar para dar refresh depois
            Navigator.of(dialogContext).pop();
          }, 
          child: const Text('Salvar')
        ),
      ],
    )
  );
}

void _updateDeck(String name, String desc, Deck? oldDeck, BuildContext context) {

  try {

    if(name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O nome do deck não pode estar vazio.')),
      );
      return;
    } else if(desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A descrição não pode estar vazia.')),
      );
      return;
    } else if (oldDeck == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O deck não pode ser nulo.')),
      );
      return;
    }

    final userEmail = FirebaseAuth.instance.currentUser?.email ?? '';


    final deck = Deck(id: oldDeck.id, name: name, description: desc, userEmail: userEmail, totalCards: oldDeck.totalCards);

    DBHelper.getInstance().then((db) {
      DeckDao.updateDeck(db, deck);
    });

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro: $e')),
    );
  }
}

void _deleteDeck(Deck deck, BuildContext context) async {
  final db = await DBHelper.getInstance();
  await DeckDao.deleteDeck(db, deck.id!);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Deck excluído!')),
  );
}