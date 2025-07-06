import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/create_deck.dart';
import '../model/dao_deck.dart';
import '../database/db_helper.dart';
import '../model/deck.dart';

class TelaPrincipal extends StatefulWidget {
  final String nomeUsuario;
  const TelaPrincipal({super.key, required this.nomeUsuario});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  Future<List<Deck>> _fetchDecks() async {
    final db = await DBHelper.getInstance();
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    return await DeckDao.getAllDecksByEmail(db, userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGO AQUI'),
        backgroundColor: const Color.fromARGB(255, 124, 48, 114),
      ),
      body: FutureBuilder<List<Deck>>(
        future: _fetchDecks(),
        builder: (context, snapshot) {
          // esperando retorno da busca
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final decks = snapshot.data ?? [];

          // não existem decks
          if (decks.isEmpty) {
            return const Center(child: Text('Nenhum deck cadastrado. Crie um novo!'));
          }

          // mostra os decks
          return ListView.builder(
            itemCount: decks.length,
            itemBuilder: (context, index) {
              final deck = decks[index];
              return Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 185, 77, 171),
                  borderRadius: BorderRadius.circular(8.0),
                  
                ),
                child: ListTile(
                  onTap: () {
                    context.go('/deck/${deck.id}');
                  },
                  title: Text(
                    deck.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (idx) {
          setState(() {
            if (idx == 1) {
              showCreateDeckDialog(context);
            } else if (idx == 2) {
              context.go('/settings');
            }
          });
        },
      ),
    );
  }
}