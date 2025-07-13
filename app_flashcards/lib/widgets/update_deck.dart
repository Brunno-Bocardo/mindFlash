import 'package:app_flashcards/database/db_helper.dart';
import 'package:app_flashcards/model/dao_deck.dart';
import 'package:app_flashcards/model/deck.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<bool> showUpdateDeckDialog(BuildContext context, Deck? deck) async {
  final nameController = TextEditingController();
  final descController = TextEditingController();

  if(deck != null) {
    nameController.text = deck.name;
    descController.text = deck.description;
  }

  final result = await showDialog<bool>(
    context: context, 
    builder: (dialogContext) => AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 254, 255),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Editar Deck',
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
            controller: nameController,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: 'Nome do Deck',
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
            controller: descController,
            maxLength: 100,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Descrição',
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
            if(deck != null) {
              final deleted = await _deleteDeck(deck, context);
              if(deleted) {
                Navigator.of(dialogContext).pop(true);
              }
              context.go('/home');
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
            final name = nameController.text.trim();
            final desc = descController.text.trim();
            if(deck != null){
              final updated = await _updateDeck(name, desc, deck, context);
              if(updated) {
                Navigator.of(dialogContext).pop(true);
              }
            }
          }, 
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 176, 72, 163),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Salvar', style: TextStyle(fontSize: 20))
        ),
      ],
    )
  );
  return result ?? false;
}

Future<bool> _updateDeck(String name, String desc, Deck? oldDeck, BuildContext context) async {

  try {

    if(name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O nome do deck não pode estar vazio.')),
      );
      return false;
    } else if(desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A descrição não pode estar vazia.')),
      );
      return false;
    } else if (oldDeck == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O deck não pode ser nulo.')),
      );
      return false;
    }

    final userEmail = FirebaseAuth.instance.currentUser?.email ?? '';


    final deck = Deck(id: oldDeck.id, name: name, description: desc, userEmail: userEmail, totalCards: oldDeck.totalCards);

    DBHelper.getInstance().then((db) {
      DeckDao.updateDeck(db, deck);
    });
    return true;

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro: $e')),
    );
    return false;
  }
}

Future<bool> _deleteDeck(Deck deck, BuildContext context) async {
  final db = await DBHelper.getInstance();
  await DeckDao.deleteDeck(db, deck.id!);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Deck excluído!')),
  );
  return true;
}