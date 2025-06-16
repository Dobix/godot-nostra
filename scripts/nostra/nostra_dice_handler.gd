extends Node

enum result { PLAYER, NPC, DRAW }
var dice_result

signal dice_finished(result)

func _ready() -> void:
	print("dice loaded")
	$AnimatedSprite2D.play("rolling")
	$AnimationPlayer.play("jump")
	await get_tree().create_timer(1.0).timeout
	var player_result = randi() % 6 + 1
	$AnimatedSprite2D.play("face_%d" % player_result)
	$Label.text = "Du hast eine " + str(player_result) + " gewürfelt."
	await get_tree().create_timer(2.0).timeout
	$AnimatedSprite2D.play("rolling")
	$AnimationPlayer.play("jump")
	var npc_result = randi() % 6 + 1
	await get_tree().create_timer(1.0).timeout
	$AnimatedSprite2D.play("face_%d" % npc_result)
	$Label.text = "Gegner würfelt eine " + str(npc_result) + "."
	if player_result > npc_result:
		dice_result = result.PLAYER 
	elif npc_result > player_result:
		dice_result = result.NPC
	else:
		dice_result = result.DRAW
		
	emit_signal("dice_finished", dice_result)
