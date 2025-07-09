import 'package:app_flashcards/database/db_helper.dart';
import 'package:app_flashcards/model/card.dart';
import 'package:app_flashcards/model/dao_card.dart';
import 'package:app_flashcards/model/dao_deck.dart';
import 'package:app_flashcards/model/deck.dart';
import 'package:app_flashcards/widgets/bottom_navigation.dart';
import 'package:app_flashcards/widgets/create_card.dart';
import 'package:app_flashcards/widgets/update_deck.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TelaDeck extends StatefulWidget{
  final int? deckId;
  const TelaDeck({super.key, this.deckId});

  @override
  State<TelaDeck> createState() => _TelaDeckState(); 
}

class _TelaDeckState extends State<TelaDeck> {
  Future<Deck?> _fetchDeck(deckId) async {
    final db = await DBHelper.getInstance();
    return await DeckDao.getDeckById(db, deckId);
  }

  Future<List<Flashcard>> _fetchCards(deckId) async {
    final db = await DBHelper.getInstance();
    return await CardDao.getAllCardsByDeckId(db, deckId);
  }


  @override
  Widget build(BuildContext context){

    if (widget.deckId == null || widget.deckId == -1) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 124, 48, 114),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Nenhum deck selecionado.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
            ],
          )
        ),
        bottomNavigationBar: CustomBottomNavigation(
          currentIndex: 1, 
          onTap: (idx) {
            setState(() {
              if(idx == 0) {
                context.go('/home');
              } else if (idx == 2) {
                context.go('/settings');
              }
            });
          }
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 124, 48, 114),
      ),
      body: FutureBuilder(
        future: _fetchDeck(widget.deckId), 
        builder: (context, snapshot) {
          //esperando retorno da busca
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final deck = snapshot.data;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //nome do deck
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  deck?.name ?? '',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 185, 77, 171)),
                ),
              ),
              //lista de cards
              Expanded(
                child: FutureBuilder(
                  future: _fetchCards(widget.deckId), 
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final cards = snapshot.data ?? [];

                    if(cards.isEmpty) {
                      return const Center(child: Text("Sem flashcards neste deck. Crie um novo!"));
                    }

                    return ListView.builder(
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 185, 77, 171),
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: ListTile(
                            // Editar o card tocado
                            // onTap: () {}
                            title: Text(
                              card.question,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    );
                  }
                )
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar'),
                      // Abre popup que adiciona o card
                      onPressed: () => showCreateCardDialog(context, widget.deckId),             
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play'),
                      onPressed: () {
                        // Abrir tela para dar play no deck
                      }
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                      onPressed: () {
                        // Abrir popup para editar o deck
                        showUpdateDeckDialog(context, deck);
                      }
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ),

      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 1, 
        onTap: (idx) {
          setState(() {
            if(idx == 0) {
              context.go('/home');
            } else if (idx == 2) {
              context.go('/settings/${widget.deckId}');
            }
          });
        }
      ),
    );
  }
}