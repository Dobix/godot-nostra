class_name Enemy_Hand
extends ColorRect

const CARD = preload("res://nostra/card/card.tscn")
@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotation_degrees := 5
@export var x_sep := -10
@export var y_min := 0
@export var y_max := -15

@export var card_id: int = -1
@export var on_card_dbl_click: Callable

@export var allowed_to_interact := false

func draw_card(card_data: CardData) -> void:
	var new_card = CARD.instantiate()
	new_card.image = load("res://assets/nostra/cards/Backcover.png")
	new_card.card_data = card_data
	new_card.hover_enabled = false
	add_child(new_card)
	_update_cards()

	
func discard_card() -> void:
	if get_child_count() < 1:
		return
	
	var child := get_child(-1)
	child.reparent(get_tree().root)
	child.queue_free()
	_update_cards()

func _update_cards() -> void:
	var cards := get_child_count()
	if cards == 0:
		return
	
	# Neue dynamische Kartengröße berechnen
	var card_size := Card.new().get_scaled_size(size)
	
	# Diese Zeile ersetzt Card.SIZE überall im Code:
	var all_cards_size := card_size.x * cards + x_sep * (cards - 1)
	var final_x_sep := x_sep
	
	if all_cards_size > size.x:
		final_x_sep = (size.x - card_size.x * cards) / (cards - 1)
		all_cards_size = size.x
		
	var offset := (size.x - all_cards_size) / 2
	
	for i in cards:
		var card := get_child(i)
		
		var y_multiplier := hand_curve.sample(1.0 / (cards-1) * i) if cards > 1 else 0.6
		var rot_multiplier := rotation_curve.sample(1.0 / (cards-1) * i) if cards > 1 else 0.0
		
		# Positionieren
		var final_x: float = offset + card_size.x * i + final_x_sep * i
		var final_y: float = y_min + y_max * y_multiplier
		
		card.position = Vector2(final_x, final_y)
		card.rotation_degrees = max_rotation_degrees * rot_multiplier
		
		# Dynamische Größe setzen
		card.set_size(card_size)
