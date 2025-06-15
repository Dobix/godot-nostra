extends CanvasLayer

@onready var deck_manager = preload("res://scripts/nostra/deck_manager.gd").new()
@onready var ai = preload("res://scripts/nostra/nostra_ai_enemy.gd").new()
@onready var score_handler = preload("res://scripts/nostra/nostra_score_handler.gd").new()

@onready var hand: ColorRect = $Hand
@onready var enemy_hand: ColorRect = $Enemy_Hand
@onready var popup: PopupPanel = $PopupPanel
@onready var dice_result: Label = $Dice_result
@onready var roll_button: Button = $Button_Roll
@onready var turn_label: Label = $Turn_label
@onready var npc_decision_label: Label = $npc_decision_label
@onready var round_result_label: Label = $round_result_label
@onready var next_turn_button: Button = $Button_Next_Turn
@onready var show_end_result_button: Button = $Button_show_end_result

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

var current_attacker: String
var current_defender: String
var attacker_card_data: CardData = null
var defender_card_data: CardData = null
var attacker_decision: String

var player_discard_pile: Array[CardData] = []
var npc_discard_pile: Array[CardData] = []

var round_just_ended := false
var needed_scores
var current_scores

func start_nostra(npc_name: String, difficulty: int, npc_portrait: Texture2D, win_multiplier: float):
	ai.difficulty = difficulty
	turn_label.text = ""
	hand.allowed_to_interact = false
	hand.on_card_dbl_click = Callable(self, "show_card_popup")
	$Enemy_Info/VBoxContainer/Enemy_Name.text = npc_name
	$Enemy_Info/Enemy_Portrait.texture = npc_portrait
	$Player_Info/VBoxContainer/Player_Name.text = "Du"
	$Player_Info/Player_Portrait.texture = npc_portrait

	var full_deck = deck_manager.get_deck()
	player_deck = full_deck.duplicate()
	npc_deck = full_deck.duplicate()
	player_deck.shuffle()
	npc_deck.shuffle()
	player_hand = deck_manager.draw_cards_from_deck(player_deck, 3)
	npc_hand = deck_manager.draw_cards_from_deck(npc_deck, 3)

	var deck_age_sum = score_handler.sum_card_age(full_deck)
	needed_scores = score_handler.get_needed_scores(win_multiplier, deck_age_sum)

	update_score_labels(0, 0)

	for card_data in player_hand:
		hand.draw_card(card_data)
	for card_data in npc_hand:
		enemy_hand.draw_card(card_data)

func update_score_labels(player_score: int, npc_score: int):
	$Player_Info/VBoxContainer/Player_Score.text = str(player_score) + "/" + str(needed_scores.player)
	$Enemy_Info/VBoxContainer/Enemy_Score.text = str(npc_score) + "/" + str(needed_scores.npc)

func show_card_popup(card_data: CardData):
	selected_popup_card = card_data
	popup.popup_centered()

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

	var result = ai.choose_attack_card(npc_hand)
	attacker_card_data = result["card"]
	attacker_decision = result["decision"]
	npc_hand = npc_hand.filter(func(c): return c.id != attacker_card_data.id)
	enemy_hand.discard_card()

	npc_decision_label.text = "Ich sage, meine Karte ist " + attacker_decision + "."
	npc_decision_label.show()

	await get_tree().create_timer(2.0).timeout
	request_player_response()

func request_player_response():
	turn_label.text = "Dein Zug: Reagiere!"
	hand.allowed_to_interact = true

func respond_npc():
	await get_tree().create_timer(1.0).timeout
	var result = ai.choose_defense_card(npc_hand)
	defender_card_data = result["card"]
	var decision = result["decision"]
	npc_hand = npc_hand.filter(func(c): return c.id != defender_card_data.id)
	enemy_hand.discard_card()

	await get_tree().create_timer(1.5).timeout
	resolve_round(attacker_card_data, defender_card_data, attacker_decision, decision)

func evaluate_round(player: String, card_data: CardData, decision: String):
	if player == current_attacker:
		attacker_card_data = card_data
		attacker_decision = decision
		if current_defender == "NPC":
			remove_card_from_player_hand(card_data.id)
			respond_npc()
	else:
		defender_card_data = card_data
		remove_card_from_player_hand(card_data.id)
		resolve_round(attacker_card_data, defender_card_data, attacker_decision, decision)

func resolve_round(card1: CardData, card2: CardData, decision1: String, decision2: String):
	npc_decision_label.hide()
	turn_label.text = ""

	var result = score_handler.resolve_round(card1, card2, decision1, decision2)
	var attacker_wins = result.attacker_wins
	var defender_wins = result.defender_wins

	var result_text = """
		%s sagt: Meine Karte (%s) ist %s
		%s sagt: Meine Karte (%s) ist %s

		""" % [current_attacker, card1.value, decision1, current_defender, card2.value, decision2]

	if attacker_wins and defender_wins:
		result_text += "Beide hatten recht!"
		add_cards_to_discard([
			{"who": current_attacker, "card": card1},
			{"who": current_defender, "card": card2}
		])
	elif attacker_wins:
		result_text += current_attacker + " gewinnt die Runde!"
		add_cards_to_discard([
			{"who": current_attacker, "card": card1},
			{"who": current_attacker, "card": card2}
		])

	elif defender_wins:
		result_text += current_defender + " gewinnt die Runde!"
		add_cards_to_discard([
			{"who": current_defender, "card": card1},
			{"who": current_defender, "card": card2}
		])
	else:
		result_text += "Niemand hat recht!"
		if current_attacker == "Spieler":
			_insert_card_back(player_deck, card1)
			_insert_card_back(npc_deck, card2)
		else:
			_insert_card_back(npc_deck, card1)
			_insert_card_back(player_deck, card2)
		next_turn_button.show()

	round_result_label.text = result_text
	round_result_label.show()
	round_just_ended = true

func add_cards_to_discard(pairs: Array[Dictionary]):
	for entry in pairs:
		var who = entry["who"]
		var card = entry["card"]
		if who == "Spieler":
			player_discard_pile.append(card)
		elif who == "NPC":
			npc_discard_pile.append(card)
	var current_scores = score_handler.get_current_scores(player_discard_pile, npc_discard_pile)
	update_score_labels(current_scores.player, current_scores.npc)
	check_gameover(current_scores, needed_scores)


func check_gameover(current_scores, needed_scores):
	if current_scores.player >= needed_scores.player and current_scores.npc < needed_scores.npc:
		handle_gameover("player")
	elif current_scores.npc >= needed_scores.npc and current_scores.player < needed_scores.player:
		handle_gameover("npc")
	elif current_scores.npc >= needed_scores.npc and current_scores.player >= needed_scores.player:
		handle_gameover("draw")
	else:
		next_turn_button.show()

func handle_gameover(winner):
	match winner:
		"player":
			print("player won")
		"npc":
			print("npc won")
		"draw":
			print("draw")

func _insert_card_back(deck: Array[CardData], card: CardData):
	var index = randi() % (deck.size() + 1)
	deck.insert(index, card)

func _on_button_next_turn_pressed():
	round_result_label.hide()
	next_turn_button.hide()
	round_just_ended = false
	draw_cards_if_possible()
	next_turn()
	
func next_turn():
	round_active = false
	match current_turn:
		Turn.PLAYER:
			_start_npc_turn()
		Turn.NPC:
			_start_player_turn()

func remove_card_from_player_hand(card_id: int):
	for card in hand.get_children():
		if card.card_data != null and card.card_data.id == card_id:
			player_hand = player_hand.filter(func(c): return c.id != card_id)
			card.reparent(get_tree().root)
			card.queue_free()
			await get_tree().process_frame
			hand._update_cards()
			break

func draw_cards_if_possible():
	if not player_deck.is_empty():
		var card_data: CardData = player_deck.pop_front()
		player_hand.append(card_data)
		hand.draw_card(card_data)
		$Deck_Pile/Deck_Pile_Sum.text = str(player_deck.size())

	if not npc_deck.is_empty():
		var card_data: CardData = npc_deck.pop_front()
		npc_hand.append(card_data)
		enemy_hand.draw_card(card_data)

func _on_older_pressed() -> void:
	if selected_popup_card:
		popup.hide()
		hand.allowed_to_interact = false
		evaluate_round("Spieler", selected_popup_card, "älter")
		npc_decision_label.hide()

func _on_younger_pressed() -> void:
	if selected_popup_card:
		popup.hide()
		hand.allowed_to_interact = false
		evaluate_round("Spieler", selected_popup_card, "jünger")
		npc_decision_label.hide()
