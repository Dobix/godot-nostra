extends Area2D

var npc_data: NpcData

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
