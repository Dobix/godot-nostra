class_name Card
extends Panel

const SIZE := Vector2(100, 140)

@export var image: Texture2D
@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	texture_rect.texture = image
