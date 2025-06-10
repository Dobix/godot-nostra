var all_cards: Array[CardData] = []

func _ready():
	all_cards = [
		CardData.new("Lucca", CardData.CardType.BRUDER, 1, "blue", "res://assets/nostra/cards/01-blue.jpg", 1),
		CardData.new("Lucca", CardData.CardType.BRUDER, 2, "green", "res://assets/nostra/cards/01-green.jpg", 2),
		CardData.new("Vincente", CardData.CardType.BRUDER, 3, "blue", "res://assets/nostra/cards/02-blue.jpg", 3),
		CardData.new("Vincente", CardData.CardType.BRUDER, 4, "green", "res://assets/nostra/cards/02-green.jpg", 4),
		CardData.new("Ricardo", CardData.CardType.BRUDER, 5, "blue", "res://assets/nostra/cards/03-blue.jpg", 5),
		CardData.new("Ricardo", CardData.CardType.BRUDER, 6, "green", "res://assets/nostra/cards/03-green.jpg", 6),
		CardData.new("Emilio", CardData.CardType.BRUDER, 7, "blue", "res://assets/nostra/cards/04-blue.jpg", 7),
		CardData.new("Emilio", CardData.CardType.BRUDER, 8, "green", "res://assets/nostra/cards/04-green.jpg", 8),
		CardData.new("Miguel", CardData.CardType.BRUDER, 9, "blue", "res://assets/nostra/cards/05-blue.jpg", 9),
		CardData.new("Miguel", CardData.CardType.BRUDER, 10, "green", "res://assets/nostra/cards/05-green.jpg", 10),
		CardData.new("Luis", CardData.CardType.BRUDER, 11, "blue", "res://assets/nostra/cards/06-blue.jpg", 11),
		CardData.new("Luis", CardData.CardType.BRUDER, 12, "green", "res://assets/nostra/cards/06-green.jpg", 12),
		CardData.new("Philipe", CardData.CardType.BRUDER, 13, "blue", "res://assets/nostra/cards/07-blue.jpg", 13),
		CardData.new("Philipe", CardData.CardType.BRUDER, 14, "green", "res://assets/nostra/cards/07-green.jpg", 14),
		CardData.new("Julio", CardData.CardType.BRUDER, 15, "blue", "res://assets/nostra/cards/08-blue.jpg", 15),
		CardData.new("Julio", CardData.CardType.BRUDER, 16, "green", "res://assets/nostra/cards/08-green.jpg", 16),
		CardData.new("Benito", CardData.CardType.BRUDER, 17, "blue", "res://assets/nostra/cards/09-blue.jpg", 17),
		CardData.new("Benito", CardData.CardType.BRUDER, 18, "green", "res://assets/nostra/cards/09-green.jpg", 18),
		CardData.new("Francisco", CardData.CardType.BRUDER, 19, "blue", "res://assets/nostra/cards/10-blue.jpg", 19),
		CardData.new("Francisco", CardData.CardType.BRUDER, 20, "green", "res://assets/nostra/cards/10-green.jpg", 20),
		CardData.new("Bernardo", CardData.CardType.BRUDER, 21, "blue", "res://assets/nostra/cards/11-blue.jpg", 21),
		CardData.new("Bernardo", CardData.CardType.BRUDER, 22, "green", "res://assets/nostra/cards/11-green.jpg", 22),
		CardData.new("Lorenz", CardData.CardType.BRUDER, 23, "blue", "res://assets/nostra/cards/12-blue.jpg", 23),
		CardData.new("Lorenz", CardData.CardType.BRUDER, 24, "green", "res://assets/nostra/cards/12-green.jpg", 24),
		# etc.
	]
	
func get_deck() -> Array[CardData]:
	_ready()
	return all_cards.duplicate()

func draw_cards_from_deck(deck: Array[CardData], count: int) -> Array[CardData]:
	var hand: Array[CardData] = []
	for i in range(count):
		if deck.is_empty():
			break  # kein Nachziehfehler
		var card = deck.pop_front()  # zieht vorn die Karte raus
		hand.append(card)
	return hand
