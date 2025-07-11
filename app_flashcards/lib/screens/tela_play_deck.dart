import 'package:app_flashcards/database/db_helper.dart';
import 'package:app_flashcards/model/card.dart';
import 'package:app_flashcards/model/dao_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TelaDeckPlay extends StatefulWidget {
  final int deckId;

  const TelaDeckPlay({super.key, required this.deckId});

  @override
  State<TelaDeckPlay> createState() => _TelaDeckPlayState();
}

class _TelaDeckPlayState extends State<TelaDeckPlay> {
  List<Flashcard> _cards = [];
  List<Flashcard> _activeCards = [];
  List<Flashcard> masteredCards = [];
  int _currentIndex = 0;
  int _rounds = 0;
  int roundsUntilReset = 5;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final db = await DBHelper.getInstance();
    final cards = await CardDao.getAllCardsByDeckId(db, widget.deckId);
    setState(() {
      _cards = cards;
      _activeCards = cards;
    });
  }

  void _nextCard() async {
    setState(() {
      _showAnswer = false;
      _currentIndex++;

      if(_currentIndex >= _activeCards.length){
        _rounds++;
        _currentIndex = 0;

        //Inserir cards dominados após X rodadas
        if(_rounds >= roundsUntilReset) {
          _activeCards.addAll(masteredCards);
          masteredCards.clear();
          _rounds = 0;
        }

        //Remover cards dominados
        _activeCards.removeWhere((card){
          if(card.consecutiveHits >= 3) {
            masteredCards.add(card);
            return true;
          }
          return false;
        });
        _ordenarCards();
      }
    });
  }

  void _ordenarCards() {
    // Ordena do menor para o maior número de acertos
    _activeCards.sort((a,b) => a.consecutiveHits.compareTo(b.consecutiveHits));

  }

  @override
  Widget build(BuildContext context) {
    if (_activeCards.isEmpty) {
      return Scaffold(
        appBar: AppBar(backgroundColor: const Color.fromARGB(255, 124, 48, 114)),
        body: Center(
          child: Text(
            'Todos os cards foram dominados!',
            style: TextStyle(fontSize: 18),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final deckId = widget.deckId;
            context.go('/deck/$deckId');
          },
          child: const Icon(Icons.arrow_back),
        ),
      );
    }

    final currentCard = _activeCards[_currentIndex];

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 124, 48, 114)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Center(
            child: GestureDetector(
              onTap: () => setState(() => _showAnswer = !_showAnswer),
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    currentCard.question, 
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

          if(_showAnswer)
            Center(
              child: Card(
                color: Colors.deepPurple[50],
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    currentCard.answer,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          if(_showAnswer)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      setState(() {
                        currentCard.consecutiveHits++;
                      });
                      _nextCard();
                    }, 
                    label: const Text('Right'),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        currentCard.consecutiveHits = 0;
                      });
                      _nextCard();
                    }, 
                    label: const Text('Wrong'),
                  )
                ],
              )
            ),
          FloatingActionButton(
            onPressed: () {
              final deckId = widget.deckId;
              context.go('/deck/$deckId');
            },
            child: const Icon(Icons.arrow_back),
          ),
        ],
      ),
    );    
  }
}