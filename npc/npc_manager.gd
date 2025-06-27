extends Node
class_name NpcManager

const NpcEnemy = preload("res://npc/npc_enemy.gd")

var all_enemy_ids: Array[String] = []

# Dynamisch alle Gegner-NPCs im aktuellen Level erfassen
func scan_enemies_in_overworld(root: Node):
	all_enemy_ids.clear()
	_scan_recursive(root)

func _scan_recursive(node: Node):
	if node is NpcEnemy:
		var enemy = node as NpcEnemy
		var data = enemy.npc_data_enemy
		if data and not data.id.is_empty():
			if not all_enemy_ids.has(data.id):
				all_enemy_ids.append(data.id)

			if is_enemy_defeated(data.id):
				print("npc defeated:", data.id)
	else:
		for child in node.get_children():
			_scan_recursive(child)

func mark_enemy_as_defeated(id):
	if not GameManager.player_stats.defeated_enemy_ids.has(id):
		GameManager.player_stats.defeated_enemy_ids.append(id)
		print("NPC besiegt:", id)


func is_enemy_defeated(id: String) -> bool:
	return GameManager.player_stats.defeated_enemy_ids.has(id)

func get_total_enemy_count() -> int:
	return all_enemy_ids.size()

func get_defeated_enemy_count() -> int:
	return GameManager.player_stats.defeated_enemy_ids.size()
