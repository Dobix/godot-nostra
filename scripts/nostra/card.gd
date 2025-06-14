class_name Card
extends Panel

@export var image: Texture2D
@export var hover_enabled: bool = true
@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var border: ColorRect = $Border

var card_data: CardData = null

signal card_selected(card: Card)

var selected = false

func _ready() -> void:
	texture_rect.texture = image


func get_scaled_size(hand_size: Vector2) -> Vector2:
	var scale_factor := 0.9  # 90 % der Höhe
	var card_height := hand_size.y * scale_factor
	var aspect_ratio := 120.0 / 180.0  # original width / height
	return Vector2(card_height * aspect_ratio, card_height)

func _on_mouse_entered() -> void:
	if hover_enabled:
		anim.play("hover_in")
	
func _on_mouse_exited() -> void:
	if hover_enabled:
		anim.play("hover_out")

func _on_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		emit_signal("card_selected", self)
