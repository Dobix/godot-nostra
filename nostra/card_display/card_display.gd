extends Panel

@onready var card_display_grid: HBoxContainer = $Card_Display_grid

const BACK_IMAGE = preload("res://assets/nostra/cards/Backcover.png")
const CARD = preload("res://nostra/card/card.tscn")

var displayed_cards: Array = []

func add_card(card_data: CardData, is_enemy: bool = false):
	var card = CARD.instantiate()
	card.card_data = card_data
	card.image = BACK_IMAGE
	card.hover_enabled = false
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE

	insert_card(card, is_enemy)

	displayed_cards.append(card)

func insert_card(card: Card, is_enemy: bool) -> void:
	var slot = $Card_Display_grid/Enemy_Slot if is_enemy else $Card_Display_grid/Player_Slot

	slot.add_child(card)
	await get_tree().process_frame
	card.position = slot.size / 2 - card.size / 2
	card.rotation = 0
	card.hover_enabled = not is_enemy
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE

func reveal_cards():
	for card in displayed_cards:
		card.image = load(card.card_data.image_path)
		card.update_image()

func clear_display():
	for card in displayed_cards:
		card.queue_free()
	displayed_cards.clear()

func _can_drop_data(_pos: Vector2, data: Variant) -> bool:
	return data is Card
