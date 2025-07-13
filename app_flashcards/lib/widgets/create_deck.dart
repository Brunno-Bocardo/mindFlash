import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:app_flashcards/model/dao_deck.dart';
import 'package:app_flashcards/database/db_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';


void showCreateDeckDialog(BuildContext context) {
  final nameController = TextEditingController();
  final descController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 254, 255),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Criar Deck',
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
          onPressed: () {
            final name = nameController.text.trim();
            final desc = descController.text.trim();
            createDeck(name, desc, context);
            // refresh the deck list
            context.go('/home');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 176, 72, 163),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Criar', style: TextStyle(fontSize: 20),
          ),
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