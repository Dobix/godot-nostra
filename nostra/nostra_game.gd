extends CanvasLayer

@onready var deck_manager = preload("res://nostra/deck_manager.gd").new()
@onready var ai = preload("res://nostra/nostra_ai_enemy.gd").new()
@onready var score_handler = preload("res://nostra/nostra_score_handler.gd").new()

const dice_game = preload("res://nostra/dice_game.tscn")

@onready var hand: ColorRect = $Hand
@onready var enemy_hand: ColorRect = $Enemy_Hand
@onready var popup: PopupPanel = $PopupPanel
@onready var dice_result: Label = $Dice_result
@onready var turn_label: Label = $Turn_label
@onready var npc_decision_label: Label = $npc_decision_label
@onready var round_result_label: Label = $round_result_label
@onready var card_display: Panel = $Card_Display

enum Turn { PLAYER, NPC }
var current_turn: Turn
enum game_result { PLAYER, NPC, DRAW }
var round_active := false

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

var npc_data: EnemyNpcData

func _unhandled_input(event):
	if event.is_action_pressed("close"):
		GameManager.nostra_active = false
		queue_free()

func start_nostra(data: EnemyNpcData):
	npc_data = data
	ai.difficulty = npc_data.difficulty
	turn_label.text = ""
	hand.allowed_to_interact = false
	hand.on_card_dbl_click = Callable(self, "show_card_popup")
	$Enemy_Info/VBoxContainer/Enemy_Name.text = npc_data.name
	$Enemy_Info/Enemy_Portrait.texture = npc_data.portrait
	$Player_Info/VBoxContainer/Player_Name.text = "Du"
	$Player_Info/Player_Portrait.texture = npc_data.portrait

	var full_deck = deck_manager.get_deck()
	player_deck = full_deck.duplicate()
	npc_deck = full_deck.duplicate()
	player_deck.shuffle()
	npc_deck.shuffle()
	player_hand = deck_manager.draw_cards_from_deck(player_deck, 3)
	npc_hand = deck_manager.draw_cards_from_deck(npc_deck, 3)
	$Deck_Pile/Deck_Pile_Sum.text = str(player_deck.size())

	var deck_value_sum = score_handler.sum_card_value(full_deck)
	needed_scores = score_handler.get_needed_scores(npc_data.win_multiplier, deck_value_sum)
	current_scores = score_handler.get_current_scores(player_discard_pile, npc_discard_pile)

	update_score_labels()

	for card_data in player_hand:
		hand.draw_card(card_data)
	for card_data in npc_hand:
		enemy_hand.draw_card(card_data)
		
	var dice = dice_game.instantiate()
	add_child(dice)
	dice.start_dice_round("round_start")
	dice.connect("round_start_dice_finished", Callable(self, "_on_round_start_dice_finished").bind(dice))

func update_score_labels():
	$Player_Info/VBoxContainer/Player_Score.text = str(current_scores.player) + "/" + str(needed_scores.player)
	$Enemy_Info/VBoxContainer/Enemy_Score.text = str(current_scores.npc) + "/" + str(needed_scores.npc)

func show_card_popup(card_data: CardData):
	selected_popup_card = card_data
	popup.popup_centered()

func _on_round_start_dice_finished(result: Variant, dice_node: Node) -> void:
	dice_node.queue_free()
	match result:
		game_result.PLAYER:
			_start_player_turn()
		game_result.NPC:
			_start_npc_turn()
		game_result.DRAW:
			var dice = dice_game.instantiate()
			add_child(dice)
			dice.start_dice_round("round_start")
			dice.connect("round_start_dice_finished", Callable(self, "_on_round_start_dice_finished").bind(dice))

func _on_decide_winner_dice_finished(result: Variant, dice_node: Node, card1, card2) -> void:
	dice_node.queue_free()
	match result:
		game_result.PLAYER:
			add_cards_to_discard([
			{"who": "player", "card": card1},
			{"who": "player", "card": card2}
		])
		game_result.NPC:
			add_cards_to_discard([
			{"who": "npc", "card": card1},
			{"who": "npc", "card": card2}
		])
		game_result.DRAW:
			add_cards_to_discard([
			{"who": current_attacker, "card": card1},
			{"who": current_defender, "card": card2}
		])

func _start_player_turn():
	current_turn = Turn.PLAYER
	current_attacker = "player"
	current_defender = "npc"
	round_active = true
	hand.allowed_to_interact = true
	turn_label.text = "Du bist dran"

func _start_npc_turn():
	current_turn = Turn.NPC
	current_attacker = "npc"
	current_defender = "player"
	round_active = true
	hand.allowed_to_interact = false
	turn_label.text = "Gegner denkt …"

	await get_tree().create_timer(1.0).timeout

	var result = ai.choose_attack_card(npc_hand)
	attacker_card_data = result["card"]
	attacker_decision = result["decision"]
	npc_hand = npc_hand.filter(func(c): return c.id != attacker_card_data.id)
	enemy_hand.discard_card()
	card_display.add_card(attacker_card_data)

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
	card_display.add_card(defender_card_data)

	await get_tree().create_timer(1.5).timeout
	resolve_round(attacker_card_data, defender_card_data, attacker_decision, decision)

func evaluate_round(player: String, card_data: CardData, decision: String):
	if player == current_attacker:
		attacker_card_data = card_data
		attacker_decision = decision
		if current_defender == "npc":
			hand.remove_card_by_id(card_data.id)
			card_display.add_card(card_data)
			respond_npc()
	else:
		defender_card_data = card_data
		hand.remove_card_by_id(card_data.id)
		card_display.add_card(card_data)
		resolve_round(attacker_card_data, defender_card_data, attacker_decision, decision)

func resolve_round(card1: CardData, card2: CardData, decision1: String, decision2: String):
	card_display.reveal_cards()
	npc_decision_label.hide()
	turn_label.text = ""

	var result = score_handler.resolve_round(card1, card2, decision1, decision2)

	if result.attacker_wins and result.defender_wins:
		round_result_label.text = "Beide hatten recht!"
		add_cards_to_discard([
			{"who": current_attacker, "card": card1},
			{"who": current_defender, "card": card2}
		])
	elif result.attacker_wins:
		round_result_label.text = current_attacker + " gewinnt die Runde!"
		add_cards_to_discard([
			{"who": current_attacker, "card": card1},
			{"who": current_attacker, "card": card2}
		])

	elif result.defender_wins:
		round_result_label.text = current_defender + " gewinnt die Runde!"
		add_cards_to_discard([
			{"who": current_defender, "card": card1},
			{"who": current_defender, "card": card2}
		])
	else:
		round_result_label.text = "Niemand hat recht! Würfel den Gewinner!"
		round_result_label.show()
		await get_tree().create_timer(2.0).timeout
		round_result_label.text = ""
		var dice = dice_game.instantiate()
		add_child(dice)
		dice.start_dice_round("decide_winner")
		dice.connect("decide_winner_dice_finished", Callable(self, "_on_decide_winner_dice_finished").bind(dice, card1, card2))

	round_result_label.show()
	round_just_ended = true


func add_cards_to_discard(pairs: Array[Dictionary]):
	for entry in pairs:
		var who = entry["who"]
		var card = entry["card"]
		if who == "player":
			player_discard_pile.append(card)
		elif who == "npc":
			npc_discard_pile.append(card)
	check_gameover()

func check_gameover():
	current_scores = score_handler.get_current_scores(player_discard_pile, npc_discard_pile)
	update_score_labels()
	if current_scores.player >= needed_scores.player and current_scores.npc < needed_scores.npc:
		handle_gameover(game_result.PLAYER)
	elif current_scores.npc >= needed_scores.npc and current_scores.player < needed_scores.player:
		handle_gameover(game_result.NPC)
	elif current_scores.npc >= needed_scores.npc and current_scores.player >= needed_scores.player:
		handle_gameover(game_result.DRAW)
	else:
		await get_tree().create_timer(3.0).timeout
		next_turn()

func handle_gameover(result):
	match result:
		game_result.PLAYER:
			print("player won")
			GameManager.npc_manager.mark_enemy_as_defeated(npc_data.id)
			var defeated_enemies = GameManager.npc_manager.get_defeated_enemy_count()
			print("Besiegte Gegner: "+str(defeated_enemies))
		game_result.NPC:
			print("npc won")
		game_result.DRAW:
			print("draw")

func _insert_card_back(deck: Array[CardData], card: CardData):
	var index = randi() % (deck.size() + 1)
	deck.insert(index, card)
	
func next_turn():
	card_display.clear_display()
	draw_cards_if_possible()
	round_result_label.hide()
	round_just_ended = false
	round_active = false
	match current_turn:
		Turn.PLAYER:
			_start_npc_turn()
		Turn.NPC:
			_start_player_turn()

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

func _on_higher_pressed() -> void:
	if selected_popup_card:
		popup.hide()
		hand.allowed_to_interact = false
		evaluate_round("player", selected_popup_card, "higher")
		npc_decision_label.hide()

func _on_lower_pressed() -> void:
	if selected_popup_card:
		popup.hide()
		hand.allowed_to_interact = false
		evaluate_round("player", selected_popup_card, "lower")
		npc_decision_label.hide()
