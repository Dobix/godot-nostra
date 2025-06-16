extends Node

enum result { PLAYER, NPC, DRAW }
var dice_result

signal dice_finished(result)

func _ready() -> void:
	$AnimatedSprite2D.play("rolling")
	$AnimationPlayer.play("jump")
	await get_tree().create_timer(1.0).timeout
	var player_result = randi() % 6 + 1
	$AnimatedSprite2D.play("face_%d" % player_result)
	$Label.text = "Du hast eine " + str(player_result) + " gewürfelt."
	await get_tree().create_timer(2.0).timeout
	$AnimatedSprite2D.play("rolling")
	$AnimationPlayer.play("jump")
	$Label.text = ""
	var npc_result = randi() % 6 + 1
	await get_tree().create_timer(1.0).timeout
	$AnimatedSprite2D.play("face_%d" % npc_result)
	$Label.text = "Gegner würfelt eine " + str(npc_result) + "."
	await get_tree().create_timer(1.0).timeout
	if player_result > npc_result:
		dice_result = result.PLAYER
		$Label.text = "Du beginnst!"
	elif npc_result > player_result:
		dice_result = result.NPC
		$Label.text = "Gegner beginnt!"
	else:
		dice_result = result.DRAW
		$Label.text = "Unentschieden! Nochmal würfeln!"
	await get_tree().create_timer(1.0).timeout
	$Label.text = ""
	emit_signal("dice_finished", dice_result)
