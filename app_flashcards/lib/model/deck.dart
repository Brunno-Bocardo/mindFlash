
class Deck {
  int? id;
  String name;
  String description;
  String userEmail;
  int totalCards;

  Deck({
    this.id,
    required this.name,
    required this.description,
    this.userEmail = '',
    this.totalCards = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'userEmail': userEmail,
      'totalCards': totalCards,
    };
  }

  factory Deck.fromMap(Map<String, dynamic> map) {
    return Deck(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      userEmail: map['userEmail'] ?? '',
      totalCards: map['totalCards'],
    );
  }
}
