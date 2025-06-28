extends Panel

@onready var card_display_grid: HBoxContainer = $Card_Display_grid

const BACK_IMAGE = preload("res://assets/nostra/cards/Backcover.png")
const CARD = preload("res://nostra/card/card.tscn")

signal card_dropped_on_display(card: Card)

var displayed_cards: Array = []

func add_card(card_data: CardData):
	var card = CARD.instantiate()
	card.card_data = card_data
	card.image = BACK_IMAGE
	card.hover_enabled = false
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_display_grid.add_child(card)
	displayed_cards.append(card)

func reveal_cards():
	for card in displayed_cards:
		card.image = load(card.card_data.image_path)
		card.update_image()

func clear_display():
	for card in displayed_cards:
		card.queue_free()
	displayed_cards.clear()

# === DRAG & DROP ===

func _can_drop_data(_pos: Vector2, data: Variant) -> bool:
	return data is Card  # Nur Cards dürfen gedroppt werden

func _drop_data(_pos: Vector2, data: Variant) -> void:
	print("Karte gedroppt!")
