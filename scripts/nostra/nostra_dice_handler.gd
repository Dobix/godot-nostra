extends Node

enum Result { PLAYER, NPC, DRAW }
var dice_result

var player_result
var npc_result

@onready var result_label: Label = $Result_label
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer

signal round_start_dice_finished(result)
signal decide_winner_dice_finished(result)

func start_dice_round(purpose: String) -> void:
	player_roll()
	await get_tree().create_timer(2.0).timeout
	npc_roll()
	await get_tree().create_timer(2.0).timeout

	if player_result > npc_result:
		dice_result = Result.PLAYER
		result_label.text = "Du beginnst!"
	elif npc_result > player_result:
		dice_result = Result.NPC
		result_label.text = "Gegner beginnt!"
	else:
		dice_result = Result.DRAW
		result_label.text = "Unentschieden! Nochmal würfeln!"

	await get_tree().create_timer(1.0).timeout
	result_label.text = ""

	match purpose:
		"round_start":
			emit_signal("round_start_dice_finished", dice_result)
		"decide_winner":
			emit_signal("decide_winner_dice_finished", dice_result)


func player_roll() -> void:
	anim_sprite.play("rolling")
	anim.play("jump")
	await get_tree().create_timer(1.0).timeout
	player_result = randi() % 6 + 1
	anim_sprite.play("face_%d" % player_result)
	result_label.text = "Du hast eine " + str(player_result) + " gewürfelt."

func npc_roll() -> void:
	anim_sprite.play("rolling")
	anim.play("jump")
	result_label.text = ""
	npc_result = randi() % 6 + 1
	await get_tree().create_timer(1.0).timeout
	anim_sprite.play("face_%d" % npc_result)
	result_label.text = "Gegner würfelt eine " + str(npc_result) + "."
