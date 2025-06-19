extends HBoxContainer

const CARD = preload("res://scenes/nostra/card.tscn")

var displayed_cards: Array = []

func add_card(card_data: CardData):
	var card = CARD.instantiate()
	card.card_data = card_data
	card.image = load("res://assets/nostra/cards/01-blue.jpg")
	add_child(card)
	displayed_cards.append(card)

func reveal_cards():
	for card in displayed_cards:
		card.image = load(card.card_data.image_path)

func clear_display():
	for card in displayed_cards:
		card.queue_free()
	displayed_cards.clear()
