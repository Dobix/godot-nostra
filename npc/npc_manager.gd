extends Node
class_name NpcManager

const NpcEnemy = preload("res://npc/npc_enemy.gd")

var all_enemy_ids: Array[String] = []
var defeated_enemy_ids: Array[String] = []

# Dynamisch alle Gegner-NPCs im aktuellen Level erfassen
func scan_enemies_in_overworld(root: Node):
	all_enemy_ids.clear()

	for node in root.get_children():
		_scan_recursive(node)

func _scan_recursive(node: Node):
	if node is NpcEnemy:
		if not node.npc_id.is_empty() and not all_enemy_ids.has(node.npc_id):
			all_enemy_ids.append(node.npc_id)

			if is_enemy_defeated(node.npc_id):
				node.queue_free()  # Gegner schon besiegt? Aus Szene entfernen
	elif node.get_child_count() > 0:
		for child in node.get_children():
			_scan_recursive(child)

func mark_enemy_as_defeated(id: String):
	if not defeated_enemy_ids.has(id):
		defeated_enemy_ids.append(id)

func is_enemy_defeated(id: String) -> bool:
	return defeated_enemy_ids.has(id)

func get_total_enemy_count() -> int:
	return all_enemy_ids.size()

func get_defeated_enemy_count() -> int:
	return defeated_enemy_ids.size()
