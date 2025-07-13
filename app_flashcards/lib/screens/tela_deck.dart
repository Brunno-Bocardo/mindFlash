import 'package:app_flashcards/database/db_helper.dart';
import 'package:app_flashcards/model/card.dart';
import 'package:app_flashcards/model/dao_card.dart';
import 'package:app_flashcards/model/dao_deck.dart';
import 'package:app_flashcards/model/deck.dart';
import 'package:app_flashcards/widgets/create_card.dart';
import 'package:app_flashcards/widgets/update_card.dart';
import 'package:app_flashcards/widgets/update_deck.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_flashcards/widgets/bottom_navigation_bar.dart';

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
                            // abrir popup pra editar ou excluir o card
                            onTap: () async {
                              final cardUpdated = await showUpdateCardDialog(context, card);
                              if (cardUpdated) {
                                // espera e garante que a carta foi atualizada antes de "recarregar" a tela
                                setState(() { });
                              }
                            },
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        final cardCreated = await showCreateCardDialog(context, widget.deckId);
                        if (cardCreated) {
                          // espera e garante que a carta foi criada antes de "recarregar" a tela
                          setState(() { });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 176, 72, 163),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(Icons.add, size: 40, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    height: 75,
                    width: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        // Ir para tela de play do deck
                        final deckId = widget.deckId;
                        context.go('/deck/play/$deckId');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 176, 72, 163),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(Icons.play_arrow, size: 50, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Abrir popup para editar o deck
                        final deckUpdated = await showUpdateDeckDialog(context, deck);
                        if (deckUpdated) {
                          // espera e garante que o deck foi atualizado antes de "recarregar" a tela
                          setState(() { });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 176, 72, 163),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(Icons.edit, size: 30, color: Colors.white,),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          );
        }
      ),

      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (idx) {
          if (idx == 0) {
            context.go('/home');
          }
          else if (idx == 1) {
            context.go('/settings');
          }
        },
      ),
    );
  }
}