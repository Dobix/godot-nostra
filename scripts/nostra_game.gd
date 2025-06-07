extends CanvasLayer

func start_nostra(npc_name: String):
	print("Starte gegen:", npc_name)
	$MarginContainer/Enemy_Label.text = "You play against: " + npc_name

func _on_button_pressed() -> void:
	queue_free()
