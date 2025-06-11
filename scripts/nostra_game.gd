extends CanvasLayer

@onready var deck_manager = preload("res://scripts/deck_manager.gd").new()
@onready var hand: ColorRect = $MarginContainer/Hand
@onready var popup: PopupPanel = $MarginContainer/PopupPanel
@onready var dice_result: Label = $MarginContainer/Dice_result
@onready var roll_button: Button = $MarginContainer/Button_Roll
@onready var turn_label: Label = $MarginContainer/Turn_label

enum Turn { PLAYER, NPC }
var current_turn: Turn
var round_active := false

var player_roll := 0
var npc_roll := 0

var player_deck: Array[CardData] = []
var npc_deck: Array[CardData] = []

var player_hand: Array[CardData] = []
var npc_hand: Array[CardData] = []

var selected_popup_card: CardData = null

var current_attacker: String  # "Spieler" oder "NPC"
var current_defender: String
var attacker_card_id: int
var attacker_decision: String

func start_nostra(npc_name: String):
	hand.allowed_to_interact = false
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

func _on_button_roll_pressed() -> void:
	player_roll = randi() % 6 + 1
	dice_result.text = "Du hast eine " + str(player_roll) + " gewürfelt."
	roll_button.hide()

	await get_tree().create_timer(1.0).timeout

	npc_roll = randi() % 6 + 1
	dice_result.text += "\nGegner würfelt eine " + str(npc_roll) + "."

	await get_tree().create_timer(1.0).timeout

	if player_roll > npc_roll:
		dice_result.text += "\nDu beginnst!"
		await get_tree().create_timer(1.5).timeout
		dice_result.hide()
		_start_player_turn()
	elif npc_roll > player_roll:
		dice_result.text += "\nGegner beginnt!"
		await get_tree().create_timer(1.5).timeout
		dice_result.hide()
		_start_npc_turn()
	else:
		dice_result.text += "\nGleichstand! Nochmal würfeln..."
		await get_tree().create_timer(2.0).timeout
		roll_button.show()


func _start_player_turn():
	current_turn = Turn.PLAYER
	current_attacker = "Spieler"
	current_defender = "NPC"
	round_active = true
	hand.allowed_to_interact = true
	turn_label.text = "Du bist dran"


func _start_npc_turn():
	current_turn = Turn.NPC
	current_attacker = "NPC"
	current_defender = "Spieler"
	round_active = true
	hand.allowed_to_interact = false
	turn_label.text = "Gegner denkt …"
	
	await get_tree().create_timer(1.0).timeout

	var card_data = npc_hand.pop_front()
	attacker_card_id = card_data.id
	attacker_decision = ["älter", "jünger"].pick_random()

	print("NPC spielt Karte mit ID %d und sagt: %s" % [attacker_card_id, attacker_decision])

	await get_tree().create_timer(1.5).timeout
	request_player_response()

func request_player_response():
	print("Spieler darf reagieren!")
	hand.allowed_to_interact = true

	
func respond_npc():
	await get_tree().create_timer(1.0).timeout
	var card_data = npc_hand.pop_front()
	var decision = ["älter", "jünger"].pick_random()

	print("NPC reagiert mit Karte ID %d (%s)" % [card_data.id, decision])
	await get_tree().create_timer(1.5).timeout

	resolve_round(attacker_card_id, card_data.id, attacker_decision, decision)


func next_turn():
	round_active = false
	if current_turn == Turn.PLAYER:
		_start_npc_turn()
	else:
		_start_player_turn()

func evaluate_round(player: String, card_id: int, decision: String):
	if player == current_attacker:
		attacker_card_id = card_id
		attacker_decision = decision

		if current_defender == "NPC":
			respond_npc()
		else:
			request_player_response()
	else:
		var defender_card_id = card_id
		print("[%s reagiert mit Karte ID %d (%s)]" % [player, defender_card_id, decision])

		resolve_round(attacker_card_id, card_id, attacker_decision, decision)

func resolve_round(id1: int, id2: int, decision1: String, decision2: String):
	print("\n🔍 Runde auswerten:")
	print("Angreifer: ID %d (%s)" % [id1, decision1])
	print("Verteidiger: ID %d (%s)" % [id2, decision2])

	# Hier kannst du Vergleiche, Punkte oder Siegbedingungen einbauen

	await get_tree().create_timer(2.0).timeout
	next_turn()

func _on_older_pressed() -> void:
	if selected_popup_card:
		popup.hide()
		hand.allowed_to_interact = false
		evaluate_round("Spieler", selected_popup_card.id, "älter")

func _on_younger_pressed() -> void:
	if selected_popup_card:
		popup.hide()
		hand.allowed_to_interact = false
		evaluate_round("Spieler", selected_popup_card.id, "jünger")
