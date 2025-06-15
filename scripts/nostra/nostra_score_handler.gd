extends Node

var player_needed_score: int
var npc_needed_score: int
enum winner { PLAYER, NPC }

func sum_card_age(deck: Array[CardData]) -> int:
	var total := 0
	for card in deck:
		total += card.age
	return total

func get_current_scores(player_discard: Array[CardData], npc_discard: Array[CardData]) -> Dictionary:
	var player_current_score := sum_card_age(player_discard)
	var npc_current_score := sum_card_age(npc_discard)
	if player_current_score >= player_needed_score:
		handle_gameover(winner.PLAYER)
	elif npc_current_score >= npc_needed_score:
		handle_gameover(winner.NPC)
	return {
		"player_score": player_current_score,
		"npc_score": npc_current_score
	}

func handle_gameover(winner):
	print("game over")


func get_needed_scores(win_mulitplier: float, deck_age_sum: int) -> Dictionary:
	player_needed_score = (deck_age_sum * win_mulitplier)
	npc_needed_score = (deck_age_sum * win_mulitplier - deck_age_sum)
	return {
		"player_needed_score": player_needed_score,
		"npc_needed_score": npc_needed_score
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
