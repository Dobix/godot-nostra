extends Node2D

func _ready() -> void:
	GameManager.npc_manager.scan_enemies_in_overworld(self)
	var total_enemies = GameManager.npc_manager.get_total_enemy_count()
	print("Gesamtanzahl an Gegner-NPCs:", total_enemies)
