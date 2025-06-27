extends "res://npc/npc_base.gd"

#@export var difficulty: NostraAIEnemy.Difficulty = NostraAIEnemy.Difficulty.EASY
#@export var win_multiplier: float = 1.0

func _ready():
	if npc_id.is_empty():
		push_error("NpcEnemy ohne ID!")
		return

	GameManager.npc_manager.register_enemy(npc_id)

	if GameManager.npc_manager.is_enemy_defeated(npc_id):
		print("already defeated")

func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("Interact"):
		Main.switch_scene("nostra", npc_name, difficulty, npc_portrait, win_multiplier)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		can_interact = false
