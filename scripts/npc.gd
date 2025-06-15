extends Area2D

@export var npc_name: String = "Kalle"
@export var difficulty: NostraAIEnemy.Difficulty = NostraAIEnemy.Difficulty.EASY
@export var npc_portrait: Texture2D
@export var win_multiplier: float

var can_interact := false

func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("Interact"):
		Main.switch_scene("nostra", npc_name, difficulty, npc_portrait, win_multiplier)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		can_interact = false
