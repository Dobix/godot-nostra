extends "res://npc/npc_base.gd"

@export var npc_data_enemy: EnemyNpcData

func _ready():
	if npc_data_enemy == null:
		push_error("NpcEnemy ohne gültige npc_data!")
		return

	if GameManager.player_stats.defeated_enemy_ids.has(npc_data_enemy.id):
		print("already defeated")

func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("Interact"):
		start_nostra_battle()

func start_nostra_battle():
	var nostra_scene = preload("res://nostra/nostra_game.tscn")
	var nostra_instance = nostra_scene.instantiate()
	get_tree().current_scene.add_child(nostra_instance)

	nostra_instance.start_nostra(npc_data_enemy)
	GameManager.nostra_active = true
