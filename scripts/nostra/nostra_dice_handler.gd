extends Node

enum result { PLAYER, NPC, DRAW }
var dice_result

func roll_dice() -> Dictionary:
	var player_roll = randi() % 6 + 1
	var npc_roll = randi() % 6 + 1
	print("Gegner würfelt eine " + str(npc_roll) + ".")
	print("Du hast eine " + str(player_roll) + " gewürfelt.")
	await get_tree().create_timer(3.0).timeout
	
	if player_roll > npc_roll:
		dice_result = result.PLAYER 
	elif npc_roll > player_roll:
		dice_result = result.NPC
	else:
		dice_result = result.DRAW
	return {
		"result": dice_result,
		"player_roll": player_roll,
		"npc_roll": npc_roll
	}
