class_name Card
extends Panel

@export var image: Texture2D
@export var hover_enabled: bool = true
@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var anim: AnimationPlayer = $AnimationPlayer

var drag_start_position := Vector2.ZERO
var card_data: CardData = null
var selected = false

var mouse_in: bool = false
var is_dragging: bool = false
var original_position: Vector2
var original_rotation := 0.0
var card_display_ref: Panel = null
var dragging_allowed := true

var hand_ref: Hand = null

# Für Drag vs DoubleClick
var mouse_down_pos: Vector2
var was_double_clicked := false

signal card_selected(card: Card)

func _ready() -> void:
	texture_rect.texture = image

func get_scaled_size(hand_size: Vector2) -> Vector2:
	var card_height := hand_size.y
	var aspect_ratio := 130.0 / 180.0  # original width / height
	return Vector2(card_height * aspect_ratio, card_height)

func update_image():
	texture_rect.texture = image

func _gui_input(event: InputEvent) -> void:
	if not dragging_allowed:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				mouse_down_pos = event.position
				was_double_clicked = event.double_click
				if was_double_clicked:
					handle_double_click()
			else:
				if is_dragging:
					_end_drag()
				is_dragging = false
				was_double_clicked = false

	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if was_double_clicked:
			return  # Kein Drag, wenn gerade Doppelklick

		var distance = event.position.distance_to(mouse_down_pos)
		if distance > 6.0 and not is_dragging:
			_begin_drag()

		if is_dragging:
			global_position = get_global_mouse_position() - size / 2.0

func _begin_drag():
	is_dragging = true
	original_position = position
	original_rotation = rotation
	rotation = 0
	GameManager.node_being_dragged = self

func _end_drag():
	GameManager.node_being_dragged = null
	var mouse_pos := get_global_mouse_position()

	if card_display_ref == null:
		print("❌ Card_Display Referenz fehlt!")
		return

	var card_display_rect := Rect2(card_display_ref.global_position, card_display_ref.size)

	if card_display_rect.has_point(mouse_pos):
		print("✅ Karte wurde korrekt gedroppt")
		var target_slot = card_display_ref.get_node("Card_Display_grid/Player_Slot")
		reparent(target_slot)
		await get_tree().process_frame
		var target_pos = target_slot.size / 2 - size / 2
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", target_pos, 0.2)
		hover_enabled = false
		mouse_filter = Control.MOUSE_FILTER_IGNORE

		if is_instance_valid(hand_ref):
			await get_tree().process_frame
			hand_ref._update_cards()

		emit_signal("card_selected", self)
	else:
		print("↩️ Karte snappt zurück")
		rotation = original_rotation
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", original_position, 0.2)

func handle_double_click():
	if not dragging_allowed:
		return

	if card_display_ref == null:
		print("❌ Card_Display Referenz fehlt!")
		return

	var target_slot = card_display_ref.get_node("Card_Display_grid/Player_Slot")
	reparent(target_slot)
	await get_tree().process_frame

	var target_pos = target_slot.size / 2 - size / 2

	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target_pos, 0.2)

	rotation = 0
	hover_enabled = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	if is_instance_valid(hand_ref):
		await get_tree().process_frame
		hand_ref._update_cards()

	emit_signal("card_selected", self)

func _on_mouse_entered() -> void:
	if hover_enabled:
		anim.play("hover_in")
	mouse_in = true

func _on_mouse_exited() -> void:
	if hover_enabled:
		anim.play("hover_out")
	mouse_in = false
