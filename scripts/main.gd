extends Node2D

var nostra_active = false

func switch_scene(scene_name: String, npc_name: String = ""):
	match scene_name:
		"nostra":
			nostra_active = true
			var nostra_scene = load("res://scenes/nostra/nostra_game.tscn")
			var nostra_instance = nostra_scene.instantiate()
			get_tree().current_scene.add_child(nostra_instance)
			nostra_instance.start_nostra(npc_name)
		
		"overworld":
			nostra_active = false
