extends HBoxContainer

const BACK_IMAGE = preload("res://assets/nostra/cards/01-blue.jpg")
const CARD = preload("res://scenes/nostra/card.tscn")
 
var displayed_cards: Array = []

func add_card(card_data: CardData):
	var card = CARD.instantiate()
	card.card_data = card_data
	card.image = BACK_IMAGE
	add_child(card)
	displayed_cards.append(card)

func reveal_cards():
	print("cards revealed")
	for card in displayed_cards:
		card.image = load(card.card_data.image_path)
		card.update_image()
		print(card.card_data.image_path)


func clear_display():
	for card in displayed_cards:
		card.queue_free()
	displayed_cards.clear()
