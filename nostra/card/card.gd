class_name Card
extends Panel

@export var image: Texture2D
@export var hover_enabled: bool = true
@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var border: ColorRect = $Border

var drag_start_position := Vector2.ZERO
var card_data: CardData = null
var selected = false

signal card_selected(card: Card)

func _ready() -> void:
	texture_rect.texture = image

func get_scaled_size(hand_size: Vector2) -> Vector2:
	var card_height := hand_size.y
	var aspect_ratio := 120.0 / 180.0  # original width / height
	return Vector2(card_height * aspect_ratio, card_height)

func update_image():
	texture_rect.texture = image

func _on_mouse_entered() -> void:
	if hover_enabled:
		anim.play("hover_in")
	
func _on_mouse_exited() -> void:
	if hover_enabled:
		anim.play("hover_out")

#func _on_gui_input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("left_click"):
		#emit_signal("card_selected", self)
		
func _get_drag_data(_pos: Vector2) -> Variant:
	var drag_preview = make_drag_preview()
	set_drag_preview(drag_preview)
	return self  # <== Das wird zur Drop-Ziel-Komponente gesendet

func make_drag_preview() -> Control:
	var preview := duplicate()
	preview.modulate = Color(1, 1, 1, 0.6)
	preview.scale = Vector2(0.8, 0.8)
	return preview
