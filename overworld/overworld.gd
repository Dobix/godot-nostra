extends Node2D

func _ready() -> void:
	GameManager.npc_manager.scan_enemies_in_overworld(self)
	var total_enemies = GameManager.npc_manager.all_enemy_ids.size()
	print("Gegner insgesamt: "+str(total_enemies))
