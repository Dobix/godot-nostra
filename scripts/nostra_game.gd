extends CanvasLayer

@onready var deck_manager = preload("res://scripts/deck_manager.gd").new()

var player_hand: Array[CardData] = []
var npc_hand: Array[CardData] = []

func start_nostra(npc_name: String):
	print("Starte gegen:", npc_name)
	$MarginContainer/Enemy_Label.text = "You play against: " + npc_name
	# 1. Deck holen & mischen
	var full_deck = deck_manager.get_deck()
	full_deck.shuffle()
	# 2. 24 Karten ziehen (unique)
	var full_game_deck = full_deck.slice(0, 24)
	# 3. Aufteilen in 2 x 12
	player_hand = full_game_deck.slice(0, 12)
	npc_hand = full_game_deck.slice(12, 24)
	# Debug check
	print("Spielerhand:")
	for card in player_hand:
		print(" - ", card.name+" ", card.color)

	print("Gegnerhand:")
	for card in npc_hand:
		print(" - ", card.name+" ", card.color)

func _on_button_pressed() -> void:
	Main.switch_scene("overworld")
	queue_free()
