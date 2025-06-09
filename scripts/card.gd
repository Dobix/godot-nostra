class_name Card
extends Panel

@export var image: Texture2D
@onready var texture_rect: TextureRect = $TextureRect
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	texture_rect.texture = image
	scale = Vector2.ONE

func apply_card_size(size: Vector2) -> void:
	custom_minimum_size = size
	texture_rect.custom_minimum_size = size

func get_scaled_size(hand_size: Vector2) -> Vector2:
	var scale_factor := 0.9  # 90 % der Höhe
	var card_height := hand_size.y * scale_factor
	var aspect_ratio := 120.0 / 180.0  # original width / height
	return Vector2(card_height * aspect_ratio, card_height)


func _on_mouse_entered() -> void:
	anim.play("hover_in")
	
func _on_mouse_exited() -> void:
	anim.play("hover_out")
