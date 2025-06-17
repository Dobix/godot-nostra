extends Node

var player_needed_score: int
var npc_needed_score: int

var player_current_score: int
var npc_current_score: int

var player_bonus: int
var npc_bonus: int


func sum_card_age(deck: Array[CardData]) -> int:
	var total := 0
	for card in deck:
		total += card.age
	return total

func add_bonus(player_bonus_value: int, npc_bonus_value: int):
	player_bonus += player_bonus_value
	npc_bonus += npc_bonus_value

func get_current_scores(player_discard: Array[CardData], npc_discard: Array[CardData]) -> Dictionary:
	player_current_score = sum_card_age(player_discard) + player_bonus
	npc_current_score = sum_card_age(npc_discard) + npc_bonus
	if player_current_score >= player_needed_score:
		player_current_score = player_needed_score
	elif npc_current_score >= npc_needed_score:
		npc_current_score = npc_needed_score
	return {
		"player": player_current_score,
		"npc": npc_current_score,
	}

func get_needed_scores(win_mulitplier: float, deck_age_sum: int) -> Dictionary:
	player_needed_score = (deck_age_sum * win_mulitplier)
	npc_needed_score = (deck_age_sum * win_mulitplier - deck_age_sum)
	return {
		"player": player_needed_score,
		"npc": npc_needed_score
	}


func resolve_round(card1: CardData, card2: CardData, decision1: String, decision2: String) -> Dictionary:
	var attacker_wins = false
	var defender_wins = false

	if decision1 == "älter" and card1.value > card2.value:
		attacker_wins = true
	elif decision1 == "jünger" and card1.value < card2.value:
		attacker_wins = true

	if decision2 == "älter" and card2.value > card1.value:
		defender_wins = true
	elif decision2 == "jünger" and card2.value < card1.value:
		defender_wins = true

	return {
		"attacker_wins": attacker_wins,
		"defender_wins": defender_wins
	}
