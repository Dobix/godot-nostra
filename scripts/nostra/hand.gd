class_name Hand
extends ColorRect

const CARD = preload("res://scenes/nostra/card.tscn")
var selected_card: Card = null

@export var is_enemy := false

@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotation_degrees := 5
@export var x_sep := -10
@export var y_min := 0
@export var y_max := -15

@export var card_id: int = -1
@export var on_card_dbl_click: Callable

@export var allowed_to_interact := false


func _ready() -> void:
	_update_hand_size()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_update_hand_size()
		_update_cards()
		

func _update_hand_size() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	size = Vector2(screen_size.x * 0.50, screen_size.y * 0.30)
	position = Vector2(
		(screen_size.x - size.x) / 2,
		screen_size.y - size.y
	)

func draw_card(card_data: CardData) -> void:
	var new_card = CARD.instantiate()
	new_card.image = load(card_data.image_path)
	new_card.card_data = card_data
	add_child(new_card)
	new_card.connect("card_selected", Callable(self, "_on_card_selected"))
	_update_cards()

	
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

	if selected_card and selected_card != card:
		selected_card.selected = false
		selected_card.border.visible = false

	if selected_card == card:
		if on_card_dbl_click.is_valid():
			on_card_dbl_click.call(card.card_data)
	else:
		card.selected = true
		card.border.visible = true
		selected_card = card
		print("Karte ausgewählt mit ID:", card.card_data.id)


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
