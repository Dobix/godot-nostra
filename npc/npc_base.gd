extends Area2D

@export var npc_name: String = "Kalle"
@export var npc_portrait: Texture2D
@export var npc_id: String

var can_interact := false

func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("Interact"):
		print("interacted with base enemy")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		can_interact = false
