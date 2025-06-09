var all_cards: Array[CardData] = []

func _ready():
	all_cards = [
		CardData.new("Lucca", CardData.CardType.BRUDER, 1, "blue", "res://assets/nostra/cards/01-blue.jpg"),
		CardData.new("Lucca", CardData.CardType.BRUDER, 2, "green", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Vincente", CardData.CardType.BRUDER, 3, "blue", "res://assets/nostra/cards/02-blue.jpg"),
		CardData.new("Vincente", CardData.CardType.BRUDER, 4, "green", "res://assets/nostra/cards/02-green.jpg"),
		CardData.new("Ricardo", CardData.CardType.BRUDER, 5, "blue", "res://assets/nostra/cards/03-blue.jpg"),
		CardData.new("Ricardo", CardData.CardType.BRUDER, 6, "green", "res://assets/nostra/cards/03-green.jpg"),
		CardData.new("Emilio", CardData.CardType.BRUDER, 7, "blue", "res://assets/nostra/cards/04-blue.jpg"),
		CardData.new("Emilio", CardData.CardType.BRUDER, 8, "green", "res://assets/nostra/cards/04-green.jpg"),
		CardData.new("Miguel", CardData.CardType.BRUDER, 9, "blue", "res://assets/nostra/cards/05-blue.jpg"),
		CardData.new("Miguel", CardData.CardType.BRUDER, 10, "green", "res://assets/nostra/cards/05-green.jpg"),
		CardData.new("Luis", CardData.CardType.BRUDER, 11, "blue", "res://assets/nostra/cards/06-blue.jpg"),
		CardData.new("Luis", CardData.CardType.BRUDER, 12, "green", "res://assets/nostra/cards/06-green.jpg"),
		CardData.new("Philipe", CardData.CardType.BRUDER, 13, "blue", "res://assets/nostra/cards/07-blue.jpg"),
		CardData.new("Philipe", CardData.CardType.BRUDER, 14, "green", "res://assets/nostra/cards/07-green.jpg"),
		CardData.new("Julio", CardData.CardType.BRUDER, 15, "blue", "res://assets/nostra/cards/08-blue.jpg"),
		CardData.new("Julio", CardData.CardType.BRUDER, 16, "green", "res://assets/nostra/cards/08-green.jpg"),
		CardData.new("Benito", CardData.CardType.BRUDER, 17, "blue", "res://assets/nostra/cards/09-blue.jpg"),
		CardData.new("Benito", CardData.CardType.BRUDER, 18, "green", "res://assets/nostra/cards/09-green.jpg"),
		CardData.new("Francisco", CardData.CardType.BRUDER, 19, "blue", "res://assets/nostra/cards/10-blue.jpg"),
		CardData.new("Francisco", CardData.CardType.BRUDER, 20, "green", "res://assets/nostra/cards/10-green.jpg"),
		CardData.new("Bernardo", CardData.CardType.BRUDER, 21, "blue", "res://assets/nostra/cards/11-blue.jpg"),
		CardData.new("Bernardo", CardData.CardType.BRUDER, 22, "green", "res://assets/nostra/cards/11-green.jpg"),
		CardData.new("Lorenz", CardData.CardType.BRUDER, 23, "blue", "res://assets/nostra/cards/12-blue.jpg"),
		CardData.new("Lorenz", CardData.CardType.BRUDER, 24, "green", "res://assets/nostra/cards/12-green.jpg"),
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
