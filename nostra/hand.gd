class_name Hand
extends ColorRect

const CARD = preload("res://nostra/card/card.tscn")
var selected_card: Card = null

@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotation_degrees := 5
@export var x_sep := -10
@export var y_min := 0
@export var y_max := -15

@export var on_card_played: Callable


@export var allowed_to_interact := false

func draw_card(card_data: CardData) -> void:
	var new_card = CARD.instantiate()
	new_card.hand_ref = self
	new_card.card_data = card_data
	new_card.image = load(card_data.image_path)
	new_card.card_display_ref = $"../Card_Display"
	new_card.dragging_allowed = allowed_to_interact
	add_child(new_card)
	new_card.connect("card_selected", Callable(self, "_on_card_selected"))
	_update_cards()

func set_all_cards_interactable(active: bool):
	for card in get_children():
		card.dragging_allowed = active

func discard_card() -> void:
	if get_child_count() < 1:
		return
	
	var child := get_child(-1)
	child.reparent(get_tree().root)
	child.queue_free()
	_update_cards()

func _on_card_selected(card: Card) -> void:
	if not allowed_to_interact:
		print("Nicht dein Zug!")
		return

	allowed_to_interact = false
	set_all_cards_interactable(false)

	print("Karte ausgewählt mit ID:", card.card_data.id)

	if on_card_played.is_valid():
		on_card_played.call(card)


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
		var tween = get_tree().create_tween()
		tween.tween_property(card, "position", Vector2(final_x, final_y), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(card, "rotation_degrees", max_rotation_degrees * rot_multiplier, 0.2)
		card.rotation_degrees = max_rotation_degrees * rot_multiplier
		card.set_size(card_size)


func remove_card_by_id(card_id: int) -> void:
	for card in get_children():
		if card.card_data != null and card.card_data.id == card_id:
			card.reparent(get_tree().root)
			card.queue_free()
			await get_tree().process_frame
			_update_cards()
			break
