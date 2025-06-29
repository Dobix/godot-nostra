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

var hand_ref: Hand = null  # oder einfach Node

signal card_selected(card: Card)

func _ready() -> void:
	texture_rect.texture = image

func get_scaled_size(hand_size: Vector2) -> Vector2:
	var card_height := hand_size.y
	var aspect_ratio := 130.0 / 180.0  # original width / height
	return Vector2(card_height * aspect_ratio, card_height)

func update_image():
	texture_rect.texture = image

func _physics_process(delta: float) -> void:
	drag_logic(delta)
	
func drag_logic(delta: float) -> void:
	if not dragging_allowed:
		return
	var is_hovered_or_dragging := mouse_in or is_dragging
	var is_dragged_by_self := GameManager.node_being_dragged == null or GameManager.node_being_dragged == self
	if is_hovered_or_dragging and is_dragged_by_self:
		if Input.is_action_pressed("left_click"):
			if not is_dragging:
				original_rotation = rotation
				original_position = position
				rotation = 0
			global_position = lerp(global_position, get_global_mouse_position() - (size / 2.0), 22.0 * delta)
			is_dragging = true
			GameManager.node_being_dragged = self
		else:
			is_dragging = false
			if GameManager.node_being_dragged == self:
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
					var tween := get_tree().create_tween()
					tween.tween_property(self, "position", original_position, 0.2)


func _on_mouse_entered() -> void:
	if hover_enabled:
		anim.play("hover_in")
	mouse_in = true
	
func _on_mouse_exited() -> void:
	if hover_enabled:
		anim.play("hover_out")
	mouse_in = false
