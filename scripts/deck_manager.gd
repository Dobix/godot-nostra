var all_cards: Array[CardData] = []

func _ready():
	print("ready aufgerufen")
	all_cards = [
		CardData.new("Lucca", CardData.CardType.BRUDER, 1, "blue", "res://assets/nostra/cards/01-blue.jpg"),
		CardData.new("Lucca", CardData.CardType.BRUDER, 1, "green", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Vincente", CardData.CardType.BRUDER, 2, "blue", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Vincente", CardData.CardType.BRUDER, 2, "green", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Ricardo", CardData.CardType.BRUDER, 3, "blue", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Ricardo", CardData.CardType.BRUDER, 3, "green", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Emilio", CardData.CardType.BRUDER, 4, "blue", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Emilio", CardData.CardType.BRUDER, 4, "green", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Miguel", CardData.CardType.BRUDER, 5, "blue", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Miguel", CardData.CardType.BRUDER, 5, "green", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Luis", CardData.CardType.BRUDER, 6, "blue", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Luis", CardData.CardType.BRUDER, 6, "green", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Philipe", CardData.CardType.BRUDER, 7, "blue", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Philipe", CardData.CardType.BRUDER, 7, "green", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Julio", CardData.CardType.BRUDER, 8, "blue", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Julio", CardData.CardType.BRUDER, 8, "green", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Benito", CardData.CardType.BRUDER, 9, "blue", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Benito", CardData.CardType.BRUDER, 9, "green", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Francisco", CardData.CardType.BRUDER, 10, "blue", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Francisco", CardData.CardType.BRUDER, 10, "green", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Bernardo", CardData.CardType.BRUDER, 11, "blue", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Bernardo", CardData.CardType.BRUDER, 11, "green", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Lorenz", CardData.CardType.BRUDER, 12, "blue", "res://assets/nostra/cards/01-green.jpg"),
		CardData.new("Lorenz", CardData.CardType.BRUDER, 12, "green", "res://assets/nostra/cards/01-green.jpg"),
		# etc.
	]
	
func get_deck() -> Array[CardData]:
	_ready()
	return all_cards.duplicate()
