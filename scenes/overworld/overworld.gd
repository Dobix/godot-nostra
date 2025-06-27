extends Node2D

func _ready() -> void:
	GameManager.npc_manager.scan_enemies_in_overworld(self)
