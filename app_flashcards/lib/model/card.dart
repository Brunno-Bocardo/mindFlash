
class Flashcard {
  int? id;
  int deckId;
  String question;
  String answer;
  int consecutiveHits;
  bool hidden;

  Flashcard({
    this.id,
    required this.deckId,
    required this.question,
    required this.answer,
    this.consecutiveHits = 0,
    this.hidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deckId': deckId,
      'question': question,
      'answer': answer,
      'consecutiveHits': consecutiveHits,
      'hidden': hidden ? 1 : 0,
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      deckId: map['deckId'],
      question: map['question'],
      answer: map['answer'],
      consecutiveHits: map['consecutiveHits'],
      hidden: map['hidden'] == 1,
    );
  }
}
