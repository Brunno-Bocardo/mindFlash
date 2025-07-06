
class Deck {
  int? id;
  String name;
  String description;
  String userEmail;
  int cardsReviewed;
  int totalCards;

  Deck({
    this.id,
    required this.name,
    required this.description,
    this.userEmail = '',
    this.cardsReviewed = 0,
    this.totalCards = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'userEmail': userEmail,
      'cardsReviewed': cardsReviewed,
      'totalCards': totalCards,
    };
  }

  factory Deck.fromMap(Map<String, dynamic> map) {
    return Deck(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      userEmail: map['userEmail'] ?? '',
      cardsReviewed: map['cardsReviewed'],
      totalCards: map['totalCards'],
    );
  }
}
