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
  List<Flashcard> _activeCards = [];
  int _currentIndex = 0;
  int _rounds = 0;
  int roundsUntilReset = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    // carrega os cards visíveis do BD 
    final db = await DBHelper.getInstance();
    final cards = await CardDao.getVisibleCards(db, widget.deckId);
    setState(() {
      _activeCards = cards;
      _currentIndex = 0;
      _rounds = 0;
      roundsUntilReset = cards.length * 6; // aqui define que para resetar completamente o deck, é necessário passar por 6 vezes o número de cards
    });
  }

  Future<void> _acertouCard() async {
    // incrementa o acerto consecutivo e chama o próximo card
    final db = await DBHelper.getInstance();
    final card = _activeCards[_currentIndex];
    await CardDao.incrementConsecutiveHits(db, card.id!);
    setState(() {
      card.consecutiveHits++; 
    });
    await _nextCard();
  }

  Future<void> _errouCard() async {
    // reseta o acerto consecutivo e chama o próximo card
    final db = await DBHelper.getInstance();
    final card = _activeCards[_currentIndex];
    await CardDao.resetConsecutiveHits(db, card.id!);
    setState(() {
      card.consecutiveHits = 0;
    });
    await _nextCard();
  }

  Future<void> _nextCard() async {
    final db = await DBHelper.getInstance();

    // define o próximo indice como sendo o atual
    int nextIndex = _currentIndex;

    // Verifica o card atual
    if (_currentIndex < _activeCards.length) {
      final card = _activeCards[_currentIndex];
      // se dominado, esconde o card no banco e remove da lista de ativos
      if (card.consecutiveHits >= 3) {
        await CardDao.hideCard(db, card.id!);
        _activeCards.removeAt(_currentIndex);
        // nesse caso, não incrementa o índice pois removemos um item da lista
        // o próximo terá o mesmo índice

        // recarrega cards visíveis caso algum card tenha sido dominado
        final cards = await CardDao.getVisibleCards(db, widget.deckId);
        setState(() {
          _activeCards = cards;
        });
      }
      else {
        // incrementa pois não foi removido nenhum indice de _activeCards
        nextIndex++;
      }
    }

    // define o próximo índice e o próximo round. Também ordena os cards com base nos acertos
    int nextRounds = _rounds;
    if (nextIndex >= _activeCards.length) {
      nextIndex = 0;
      nextRounds++;
      _ordenarCards();
    }

    // rodou todos os rounds estimados, resetar
    if (nextRounds >= roundsUntilReset) {
      _resetDeck();
    }


    setState(() {
      _currentIndex = nextIndex;
      _rounds = nextRounds;
      _showAnswer = false;
    });
    
  }

  void _ordenarCards() {
    setState(() {
      _activeCards.sort((a, b) => a.consecutiveHits.compareTo(b.consecutiveHits));
      print(_activeCards);
    });
  }

  void _resetDeck() async {
    final db = await DBHelper.getInstance();
    await CardDao.showAllCardsByDeckId(db, widget.deckId);
    await CardDao.resetConsecutiveHitsByDeckId(db, widget.deckId);
    await _loadCards();
  }

  @override
  Widget build(BuildContext context) {
    if (_activeCards.isEmpty) {
      return Scaffold(
        appBar: AppBar(backgroundColor: const Color.fromARGB(255, 124, 48, 114)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Todos os cards foram dominados!',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              IconButton(
                icon: const Icon(Icons.refresh),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 126, 49, 115),
                ),
                onPressed: ()  { _resetDeck(); },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final deckId = widget.deckId;
            context.go('/deck/$deckId');
          },
          backgroundColor: const Color.fromARGB(255, 126, 49, 115),
          foregroundColor: Colors.white,
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
                    onPressed: _acertouCard,
                    label: const Text('Right'),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.close),
                    onPressed: _errouCard,
                    label: const Text('Wrong'),
                  )
                ],
              )
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final deckId = widget.deckId;
          context.go('/deck/$deckId');
        },
        backgroundColor: const Color.fromARGB(255, 126, 49, 115),
        foregroundColor: Colors.white,
        child: const Icon(Icons.arrow_back),
      ),
    );    
  }
}