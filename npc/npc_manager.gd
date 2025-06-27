extends Node
class_name NpcManager

# Alle registrierten (besiegbaren) NPC-IDs
var all_enemy_ids: Array[String] = []

# Die IDs der NPCs, die der Spieler besiegt hat
var defeated_enemy_ids: Array[String] = []

# Ein NPC (z. B. in NpcEnemy.gd) ruft das auf, wenn er geladen wird
func register_enemy(id: String):
	if not all_enemy_ids.has(id):
		all_enemy_ids.append(id)

# Wird aufgerufen nach einem gewonnenen Kampf
func mark_enemy_as_defeated(id: String):
	if not defeated_enemy_ids.has(id):
		defeated_enemy_ids.append(id)
		print("Enemy besiegt:", id)

# Zum Speichern
func get_defeated_enemies() -> Array[String]:
	return defeated_enemy_ids

# Zum Laden
func set_defeated_enemies(loaded_ids: Array[String]):
	defeated_enemy_ids = loaded_ids

# Gibt true zurück, wenn NPC schon besiegt wurde
func is_enemy_defeated(id: String) -> bool:
	return defeated_enemy_ids.has(id)

# Fortschritt
func get_total_enemy_count() -> int:
	return all_enemy_ids.size()

func get_defeated_enemy_count() -> int:
	return defeated_enemy_ids.size()

# Optional: Check ob alle besiegbarern NPCs erledigt sind
func are_all_enemies_defeated() -> bool:
	return get_defeated_enemy_count() >= get_total_enemy_count()
