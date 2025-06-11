extends CanvasLayer

@onready var deck_manager = preload("res://scripts/deck_manager.gd").new()
@onready var hand: ColorRect = $MarginContainer/Hand
@onready var popup: PopupPanel = $MarginContainer/PopupPanel

var player_deck: Array[CardData] = []
var npc_deck: Array[CardData] = []

var player_hand: Array[CardData] = []
var npc_hand: Array[CardData] = []

var selected_popup_card: CardData = null

func start_nostra(npc_name: String):
	hand.on_card_dbl_click = Callable(self, "show_card_popup")
	print("Starte gegen:", npc_name)
	$MarginContainer/Enemy_Label.text = "You play against: " + npc_name
	
	var full_deck = deck_manager.get_deck()
	full_deck.shuffle()
	var full_game_deck = full_deck.slice(0, 24)
	player_deck = full_game_deck.slice(0, 12)
	npc_deck = full_game_deck.slice(12, 24)

	player_hand = deck_manager.draw_cards_from_deck(player_deck, 3)
	npc_hand = deck_manager.draw_cards_from_deck(npc_deck, 3)

	for card_data in player_hand:
		hand.draw_card(card_data)
	
	# Debug check
	#print("Spielerdeck:")
	#for card in player_deck:
		#print(" - ", card.name+" ", card.color)
#
	#print("Gegnerdeck:")
	#for card in npc_deck:
		#print(" - ", card.name+" ", card.color)
	#
	#print("Player Hand:")
	#for c in player_hand:
		#print(c.name+" ", c.color)e
#
	#print("NPC Hand:")
	#for c in npc_hand:
		#print(c.name+" ", c.color)

func show_card_popup(card_data: CardData):
	selected_popup_card = card_data
	popup.popup_centered()

func _on_button_draw_card_pressed() -> void:
	hand.draw_card("")

func _on_button_discard_card_pressed() -> void:
	hand.discard_card()


func _on_button_pressed() -> void:
	Main.switch_scene("overworld")
	queue_free()

func _on_older_pressed() -> void:
	if selected_popup_card:
		print("Karte mit ID %d wurde als älter ausgespielt" % selected_popup_card.id)
		popup.hide()

func _on_younger_pressed() -> void:
	if selected_popup_card:
		print("Karte mit ID %d wurde als jünger ausgespielt" % selected_popup_card.id)
		popup.hide()
