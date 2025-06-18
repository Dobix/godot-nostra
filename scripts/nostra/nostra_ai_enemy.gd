class_name NostraAIEnemy

enum Difficulty { EASY, MEDIUM, HARD }
var difficulty: Difficulty = Difficulty.EASY

func choose_attack_card(hand: Array[CardData]) -> Dictionary:
	match difficulty:
		Difficulty.EASY:
			return _easy_strategy(hand)
			
		Difficulty.MEDIUM:
			return _medium_strategy(hand)

		Difficulty.HARD:
			return _hard_strategy(hand)

	return {"card": null, "decision": ""}  # fallback

func choose_defense_card(hand: Array[CardData]) -> Dictionary:
	match difficulty:
		Difficulty.EASY:
			return _easy_strategy(hand)

		Difficulty.MEDIUM:
			return _medium_strategy(hand)

		Difficulty.HARD:
			return _hard_strategy(hand)

	return {"card": null, "decision": ""}  # fallback

func _easy_strategy(hand: Array[CardData]) -> Dictionary:
	var card = hand[0] if hand.size() > 0 else null
	var decision = ["higher", "lower"].pick_random()
	return {"card": card, "decision": decision}

func _medium_strategy(hand: Array[CardData]) -> Dictionary:
	return _easy_strategy(hand)

func _hard_strategy(hand: Array[CardData]) -> Dictionary:
	return _easy_strategy(hand)
