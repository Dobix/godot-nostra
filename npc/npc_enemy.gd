extends "res://npc/npc_base.gd"

@export var win_multiplier: float = 1.0
@export var difficulty: NostraAIEnemy.Difficulty = NostraAIEnemy.Difficulty.EASY

func _ready():
	if npc_id.is_empty():
		push_error("NpcEnemy ohne ID!")
		return

	# Nur prüfen, ob besiegt (Registrierung passiert in Overworld durch Scanning)
	if GameManager.npc_manager.is_enemy_defeated(npc_id):
		print("already defeated")

func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("Interact"):
		start_nostra_battle()

func start_nostra_battle():
	var nostra_scene = preload("res://nostra/nostra_game.tscn")
	var nostra_instance = nostra_scene.instantiate()
	get_tree().current_scene.add_child(nostra_instance)
	nostra_instance.start_nostra(npc_name, difficulty, npc_portrait, win_multiplier)
	GameManager.nostra_active = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		can_interact = false
